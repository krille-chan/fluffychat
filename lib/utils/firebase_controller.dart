import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/l10n_en.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import '../components/matrix.dart';
import '../config/setting_keys.dart';
import 'famedlysdk_store.dart';
import 'matrix_locals.dart';

abstract class FirebaseController {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static BuildContext context;
  static const String CHANNEL_ID = 'fluffychat_push';
  static const String CHANNEL_NAME = 'FluffyChat push channel';
  static const String CHANNEL_DESCRIPTION = 'Push notifications for FluffyChat';
  static const String APP_ID = 'chat.fluffy.fluffychat';
  static const String GATEWAY_URL = 'https://janian.de:7023/';
  static const String PUSHER_FORMAT = 'event_id_only';

  static Future<void> setupFirebase(
      MatrixState matrix, String clientName) async {
    final client = matrix.client;
    if (Platform.isIOS) iOS_Permission();

    String token;
    try {
      token = await _firebaseMessaging.getToken();
    } catch (_) {
      token = null;
    }
    if (token?.isEmpty ?? true) {
      final storeItem = await matrix.store.getItem(SettingKeys.showNoGoogle);
      final configOptionMissing = storeItem == null || storeItem.isEmpty;
      if (configOptionMissing || (!configOptionMissing && storeItem == '1')) {
        BotToast.showText(
          text: L10n.of(context).noGoogleServicesWarning,
          duration: Duration(seconds: 15),
        );
        if (configOptionMissing) {
          await matrix.store.setItem(SettingKeys.showNoGoogle, '0');
        }
      }
      return;
    }
    final pushers = await client.requestPushers().catchError((e) {
      debugPrint('[Push] Unable to request pushers: ${e.toString()}');
      return <Pusher>[];
    });
    final currentPushers = pushers.where((pusher) => pusher.pushkey == token);
    if (currentPushers.length == 1 &&
        currentPushers.first.kind == 'http' &&
        currentPushers.first.appId == APP_ID &&
        currentPushers.first.appDisplayName == clientName &&
        currentPushers.first.deviceDisplayName == client.deviceName &&
        currentPushers.first.lang == 'en' &&
        currentPushers.first.data.url.toString() == GATEWAY_URL &&
        currentPushers.first.data.format == PUSHER_FORMAT) {
      debugPrint('[Push] Pusher already set');
    } else {
      if (currentPushers.isNotEmpty) {
        for (final currentPusher in currentPushers) {
          currentPusher.pushkey = token;
          currentPusher.kind = 'null';
          await client.setPusher(
            currentPusher,
            append: true,
          );
          debugPrint('[Push] Remove legacy pusher for this device');
        }
      }
      await client
          .setPusher(
        Pusher(
          token,
          APP_ID,
          clientName,
          client.deviceName,
          'en',
          PusherData(
            url: Uri.parse(GATEWAY_URL),
            format: PUSHER_FORMAT,
          ),
          kind: 'http',
        ),
        append: false,
      )
          .catchError((e) {
        debugPrint('[Push] Unable to set pushers: ${e.toString()}');
        return [];
      });
    }

    Function goToRoom = (dynamic message) async {
      try {
        String roomId;
        if (message is String) {
          roomId = message;
        } else if (message is Map) {
          roomId = (message['data'] ?? message)['room_id'];
        }
        if (roomId?.isEmpty ?? true) throw ('Bad roomId');
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (r) => r.isFirst);
      } catch (_) {
        BotToast.showText(text: 'Failed to open chat...');
        debugPrint(_);
      }
    };

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notifications_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (i, a, b, c) {
      return null;
    });
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: goToRoom);

    _firebaseMessaging.configure(
      onMessage: _onMessage,
      onBackgroundMessage: _onMessage,
      onResume: goToRoom,
      onLaunch: goToRoom,
    );
    debugPrint('[Push] Firebase initialized');
    return;
  }

  static Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    try {
      final data = message['data'] ?? message;
      final String roomId = data['room_id'];
      final String eventId = data['event_id'];
      final int unread = json.decode(data['counts'])['unread'];
      if ((roomId?.isEmpty ?? true) ||
          (eventId?.isEmpty ?? true) ||
          unread == 0) {
        await _flutterLocalNotificationsPlugin.cancelAll();
        return null;
      }
      if (context != null && Matrix.of(context).activeRoomId == roomId) {
        debugPrint('[Push] New clearing push');
        return null;
      }
      debugPrint('[Push] New message received');
      // FIXME unable to init without context currently https://github.com/flutter/flutter/issues/67092
      // Locked on EN until issue resolved
      final i18n = context == null ? L10nEn() : L10n.of(context);

      // Get the client
      Client client;
      var tempClient = false;
      try {
        client = Matrix.of(context).client;
      } catch (_) {
        client = null;
      }
      if (client == null) {
        tempClient = true;
        final platform = kIsWeb ? 'Web' : Platform.operatingSystem;
        final clientName = 'FluffyChat $platform';
        client = Client(clientName);
        client.database = await getDatabase(client);
        client.connect();
        debugPrint('[Push] Use a temp client');
        await client.onLoginStateChanged.stream
            .firstWhere((l) => l == LoginState.logged)
            .timeout(
              Duration(seconds: 5),
            );
      }

      // Get the room
      var room = client.getRoomById(roomId);
      if (room == null) {
        debugPrint('[Push] Wait for the room');
        await client.onRoomUpdate.stream
            .where((u) => u.id == roomId)
            .first
            .timeout(Duration(seconds: 5));
        debugPrint('[Push] Room found');
        room = client.getRoomById(roomId);
        if (room == null) return null;
      }

      // Get the event
      var event = await client.database.getEventById(client.id, eventId, room);
      if (event == null) {
        debugPrint('[Push] Wait for the event');
        final eventUpdate = await client.onEvent.stream
            .where((u) => u.content['event_id'] == eventId)
            .first
            .timeout(Duration(seconds: 5));
        debugPrint('[Push] Event found');
        event = Event.fromJson(eventUpdate.content, room);
        if (room == null) return null;
      }

      // Count all unread events
      var unreadEvents = 0;
      client.rooms
          .forEach((Room room) => unreadEvents += room.notificationCount);

      // Calculate title
      final title = unread > 1
          ? i18n.unreadMessagesInChats(
              unreadEvents.toString(), unread.toString())
          : i18n.unreadMessages(unreadEvents.toString());

      // Calculate the body
      final body = event.getLocalizedBody(
        MatrixLocals(i18n),
        withSenderNamePrefix: true,
        hideReply: true,
      );

      // The person object for the android message style notification
      final person = Person(
        name: room.getLocalizedDisplayname(MatrixLocals(i18n)),
        icon: room.avatar == null
            ? null
            : BitmapFilePathAndroidIcon(
                await downloadAndSaveAvatar(
                  room.avatar,
                  client,
                  width: 126,
                  height: 126,
                ),
              ),
      );

      // Show notification
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
          styleInformation: MessagingStyleInformation(
            person,
            conversationTitle: title,
            messages: [
              Message(
                body,
                event.originServerTs,
                person,
              )
            ],
          ),
          importance: Importance.max,
          priority: Priority.high,
          ticker: i18n.newMessageInFluffyChat);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
          0,
          room.getLocalizedDisplayname(MatrixLocals(i18n)),
          body,
          platformChannelSpecifics,
          payload: roomId);

      if (tempClient) {
        await client.dispose();
        client = null;
        debugPrint('[Push] Temp client disposed');
      }
    } catch (exception) {
      debugPrint('[Push] Error while processing notification: ' +
          exception.toString());
      await _showDefaultNotification(message);
    }
    return null;
  }

  static Future<dynamic> _showDefaultNotification(
      Map<String, dynamic> message) async {
    try {
      var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // Init notifications framework
      var initializationSettingsAndroid =
          AndroidInitializationSettings('notifications_icon');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // FIXME unable to init without context currently https://github.com/flutter/flutter/issues/67092
      // Locked on en for now
      //final l10n = L10n(Platform.localeName);
      final l10n = L10nEn();

      // Notification data and matrix data
      Map<dynamic, dynamic> data = message['data'] ?? message;
      String eventID = data['event_id'];
      String roomID = data['room_id'];
      final int unread = data.containsKey('counts')
          ? json.decode(data['counts'])['unread']
          : 1;
      await flutterLocalNotificationsPlugin.cancelAll();
      if (unread == 0 || roomID == null || eventID == null) {
        return;
      }

      // Display notification
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
          importance: Importance.max, priority: Priority.high);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      final title = l10n.unreadChats(unread.toString());
      await flutterLocalNotificationsPlugin.show(
          1, title, l10n.openAppToReadMessages, platformChannelSpecifics,
          payload: roomID);
    } catch (exception) {
      debugPrint('[Push] Error while processing background notification: ' +
          exception.toString());
    }
    return Future<void>.value();
  }

  static Future<String> downloadAndSaveAvatar(Uri content, Client client,
      {int width, int height}) async {
    final thumbnail = width == null && height == null ? false : true;
    final tempDirectory = (await getTemporaryDirectory()).path;
    final prefix = thumbnail ? 'thumbnail' : '';
    var file =
        File('$tempDirectory/${prefix}_${content.toString().split("/").last}');

    if (!file.existsSync()) {
      final url = thumbnail
          ? content.getThumbnail(client, width: width, height: height)
          : content.getDownloadLink(client);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
    }

    return file.path;
  }

  static void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      debugPrint('Settings registered: $settings');
    });
  }
}
