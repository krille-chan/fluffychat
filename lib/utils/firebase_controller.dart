import 'dart:convert';
import 'dart:io';

import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/l10n_en.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unifiedpush/unifiedpush.dart';
import 'package:http/http.dart' as http;

import '../components/matrix.dart';
import '../config/setting_keys.dart';
import 'famedlysdk_store.dart';
import 'matrix_locals.dart';

abstract class FirebaseController {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static BuildContext context;
  static MatrixState matrix;

  static Future<void> setupFirebase(String clientName) async {
    if (!PlatformInfos.isMobile) return;
    if (Platform.isIOS) iOS_Permission();

    Function goToRoom = (dynamic message) async {
      try {
        String roomId;
        if (message is String && message[0] == '{') {
          message = json.decode(message);
        }
        if (message is String) {
          roomId = message;
        } else if (message is Map) {
          roomId = (message['data'] ??
              message['notification'] ??
              message)['room_id'];
        }
        if (roomId?.isEmpty ?? true) throw ('Bad roomId');
        await matrix.widget.apl.currentState
            .pushNamedAndRemoveUntilIsFirst('/rooms/${roomId}');
      } catch (_) {
        await FlushbarHelper.createError(message: 'Failed to open chat...')
            .show(context);
        rethrow;
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

    // ignore: unawaited_futures
    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details == null || !details.didNotificationLaunchApp) {
        return;
      }
      goToRoom(details.payload);
    });

    if (!Platform.isIOS && (await UnifiedPush.getDistributors()).isNotEmpty) {
      await setupUnifiedPush(clientName);
      return;
    }

    String fcmToken;
    try {
      fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken?.isEmpty ?? true) {
        throw '_firebaseMessaging.getToken() has not thrown an exception but returned no token';
      }
    } catch (e, s) {
      Logs().w('Unable to get firebase token', e, s);
      fcmToken = null;
    }
    if (fcmToken?.isEmpty ?? true) {
      // no google services warning
      if (await matrix.store.getItemBool(SettingKeys.showNoGoogle, true)) {
        await FlushbarHelper.createError(
          message: L10n.of(context).noGoogleServicesWarning,
          duration: Duration(seconds: 15),
        ).show(context);
        if (null == await matrix.store.getItemBool(SettingKeys.showNoGoogle)) {
          await matrix.store.setItemBool(SettingKeys.showNoGoogle, false);
        }
      }
      return;
    }
    await setupPusher(
      clientName: clientName,
      gatewayUrl: AppConfig.pushNotificationsGatewayUrl,
      token: fcmToken,
    );

    _firebaseMessaging.configure(
      onMessage: _onFcmMessage,
      onBackgroundMessage: _onFcmMessage,
      onResume: goToRoom,
      onLaunch: goToRoom,
    );
    Logs().i('[Push] Firebase initialized');
  }

  static Future<void> setupPusher({
    String clientName,
    String gatewayUrl,
    String token,
    Set<String> oldTokens,
  }) async {
    oldTokens ??= <String>{};
    final client = matrix.client;
    final pushers = await client.requestPushers().catchError((e) {
      Logs().w('[Push] Unable to request pushers', e);
      return <Pusher>[];
    });
    var setNewPusher = false;
    if (gatewayUrl != null && token != null && clientName != null) {
      final currentPushers = pushers.where((pusher) => pusher.pushkey == token);
      if (currentPushers.length == 1 &&
          currentPushers.first.kind == 'http' &&
          currentPushers.first.appId == AppConfig.pushNotificationsAppId &&
          currentPushers.first.appDisplayName == clientName &&
          currentPushers.first.deviceDisplayName == client.deviceName &&
          currentPushers.first.lang == 'en' &&
          currentPushers.first.data.url.toString() == gatewayUrl &&
          currentPushers.first.data.format ==
              AppConfig.pushNotificationsPusherFormat) {
        Logs().i('[Push] Pusher already set');
      } else {
        oldTokens.add(token);
        setNewPusher = true;
      }
    }
    for (final pusher in pushers) {
      if (oldTokens.contains(pusher.pushkey)) {
        pusher.kind = null;
        try {
          await client.setPusher(
            pusher,
            append: true,
          );
          Logs().i('[Push] Removed legacy pusher for this device');
        } catch (err) {
          Logs().w('[Push] Failed to remove old pusher', err);
        }
      }
    }
    if (setNewPusher) {
      try {
        await client.setPusher(
          Pusher(
            token,
            AppConfig.pushNotificationsAppId,
            clientName,
            client.deviceName,
            'en',
            PusherData(
              url: Uri.parse(gatewayUrl),
              format: AppConfig.pushNotificationsPusherFormat,
            ),
            kind: 'http',
          ),
          append: false,
        );
      } catch (e, s) {
        Logs().e('[Push] Unable to set pushers', e, s);
      }
    }
  }

  static Future<void> onUnifiedPushMessage(String payload) async {
    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(json.decode(payload)['notification']);
      await _onMessage(data);
    } catch (e, s) {
      Logs().e('[Push] Failed to display message', e, s);
      await _showDefaultNotification(data);
    }
  }

  static Future<void> onRemoveEndpoint() async {
    Logs().i('[Push] Removing UnifiedPush endpoint...');
    // we need our own store object as it is likely that we don't have a context here
    final store = Store();
    final oldEndpoint = await store.getItem(SettingKeys.unifiedPushEndpoint);
    await store.setItemBool(SettingKeys.unifiedPushRegistered, false);
    await store.deleteItem(SettingKeys.unifiedPushEndpoint);
    if (matrix != null && (oldEndpoint?.isNotEmpty ?? false)) {
      // remove the old pusher
      await setupPusher(
        oldTokens: {oldEndpoint},
      );
    }
  }

  static Future<void> onBackgroundNewEndpoint(String endpoint) async {
    // just remove the old endpoint. we'll deal with this when the app next starts up
    await onRemoveEndpoint();
  }

  static Future<void> setupUnifiedPush(String clientName) async {
    final onNewEndpoint = (String newEndpoint) async {
      if (newEndpoint?.isEmpty ?? true) {
        await onRemoveEndpoint();
        return;
      }
      var endpoint =
          'https://matrix.gateway.unifiedpush.org/_matrix/push/v1/notify';
      try {
        final url = Uri.parse(newEndpoint)
            .replace(
              path: '/_matrix/push/v1/notify',
              query: '',
            )
            .toString()
            .split('?')
            .first;
        final res = json.decode(utf8.decode((await http.get(url)).bodyBytes));
        if (res['gateway'] == 'matrix') {
          endpoint = url;
        }
      } catch (e) {
        Logs().i('[Push] No self-hosted unified push gateway present: ' +
            newEndpoint);
      }
      Logs().i('[Push] UnifiedPush using endpoint ' + endpoint);
      final oldTokens = <String>{};
      try {
        final fcmToken = await _firebaseMessaging.getToken();
        oldTokens.add(fcmToken);
      } catch (_) {}
      await setupPusher(
        clientName: clientName,
        gatewayUrl: endpoint,
        token: newEndpoint,
        oldTokens: oldTokens,
      );
      await matrix.store.setItem(SettingKeys.unifiedPushEndpoint, newEndpoint);
      await matrix.store.setItemBool(SettingKeys.unifiedPushRegistered, true);
    };
    await UnifiedPush.initialize(
      onNewEndpoint, // new endpoint
      onRemoveEndpoint, // registration failed
      onRemoveEndpoint, // registration removed
      onRemoveEndpoint, // unregistered
      onUnifiedPushMessage, // foreground message
      onBackgroundNewEndpoint, // background new endpoint (be static)
      onRemoveEndpoint, // background unregistered (be static)
      onUnifiedPushMessage, // background push message (be static)
    );
    if (!(await matrix.store
        .getItemBool(SettingKeys.unifiedPushRegistered, false))) {
      Logs().i('[Push] UnifiedPush not registered, attempting to do so...');
      await UnifiedPush.registerAppWithDialog();
    } else {
      // make sure the endpoint is up-to-date etc.
      await onNewEndpoint(
          await matrix.store.getItem(SettingKeys.unifiedPushEndpoint));
    }
  }

  static Future<dynamic> _onFcmMessage(Map<String, dynamic> message) async {
    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(message['data'] ?? message);
      await _onMessage(data);
    } catch (e, s) {
      Logs().e('[Push] Error while processing notification', e, s);
      await _showDefaultNotification(data);
    }
    return null;
  }

  static Future<dynamic> _onMessage(Map<String, dynamic> data) async {
    final String roomId = data['room_id'];
    final String eventId = data['event_id'];
    final unread = ((data['counts'] is String
            ? json.decode(data.tryGet<String>('counts', '{}'))
            : data.tryGet<Map<String, dynamic>>(
                'counts', <String, dynamic>{})) as Map<String, dynamic>)
        .tryGet<int>('unread');
    if ((roomId?.isEmpty ?? true) ||
        (eventId?.isEmpty ?? true) ||
        unread == 0) {
      Logs().i('[Push] New clearing push');
      await _flutterLocalNotificationsPlugin.cancelAll();
      return null;
    }
    if (matrix != null && matrix?.activeRoomId == roomId) {
      return null;
    }
    Logs().i('[Push] New message received');
    // FIXME unable to init without context currently https://github.com/flutter/flutter/issues/67092
    // Locked on EN until issue resolved
    final i18n = context == null ? L10nEn() : L10n.of(context);

    // Get the client
    var client = matrix?.client;
    var tempClient = false;
    if (client == null) {
      tempClient = true;
      final platform = kIsWeb ? 'Web' : Platform.operatingSystem;
      final clientName = 'FluffyChat $platform';
      client = Client(clientName, databaseBuilder: getDatabase)..init();
      Logs().i('[Push] Use a temp client');
      await client.onLoginStateChanged.stream
          .firstWhere((l) => l == LoginState.logged)
          .timeout(
            Duration(seconds: 20),
          );
    }

    final roomFuture =
        client.onRoomUpdate.stream.where((u) => u.id == roomId).first;
    final eventFuture = client.onEvent.stream
        .where((u) => u.content['event_id'] == eventId)
        .first;

    // Get the room
    var room = client.getRoomById(roomId);
    if (room == null) {
      Logs().i('[Push] Wait for the room');
      await roomFuture.timeout(Duration(seconds: 5));
      Logs().i('[Push] Room found');
      room = client.getRoomById(roomId);
      if (room == null) return null;
    } else {
      // cancel the future
      // ignore: unawaited_futures
      roomFuture.timeout(Duration(seconds: 0)).catchError((_) => null);
    }

    // Get the event
    var event = await client.database.getEventById(client.id, eventId, room);
    if (event == null) {
      Logs().i('[Push] Wait for the event');
      final eventUpdate = await eventFuture.timeout(Duration(seconds: 5));
      Logs().i('[Push] Event found');
      event = Event.fromJson(eventUpdate.content, room);
      if (room == null) return null;
    } else {
      // cancel the future
      // ignore: unawaited_futures
      eventFuture.timeout(Duration(seconds: 0)).catchError((_) => null);
    }

    // Count all unread events
    var unreadEvents = 0;
    client.rooms.forEach((Room room) => unreadEvents += room.notificationCount);

    // Calculate title
    final title = unread > 1
        ? i18n.unreadMessagesInChats(unreadEvents.toString(), unread.toString())
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
    var androidPlatformChannelSpecifics = _getAndroidNotificationDetails(
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
      ticker: i18n.newMessageInFluffyChat,
    );
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
      Logs().i('[Push] Temp client disposed');
    }
    return null;
  }

  static Future<dynamic> _showDefaultNotification(
      Map<String, dynamic> data) async {
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
      String eventID = data['event_id'];
      String roomID = data['room_id'];
      final unread = ((data['counts'] is String
              ? json.decode(data.tryGet<String>('counts', '{}'))
              : data.tryGet<Map<String, dynamic>>(
                  'counts', <String, dynamic>{})) as Map<String, dynamic>)
          .tryGet<int>('unread', 1);
      await flutterLocalNotificationsPlugin.cancelAll();
      if (unread == 0 || roomID == null || eventID == null) {
        return;
      }

      // Display notification
      var androidPlatformChannelSpecifics = _getAndroidNotificationDetails();
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      final title = l10n.unreadChats(unread.toString());
      await flutterLocalNotificationsPlugin.show(
          1, title, l10n.openAppToReadMessages, platformChannelSpecifics,
          payload: roomID);
    } catch (e, s) {
      Logs().e('[Push] Error while processing background notification', e, s);
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
      Logs().i('Settings registered: $settings');
    });
  }

  static AndroidNotificationDetails _getAndroidNotificationDetails(
      {MessagingStyleInformation styleInformation, String ticker}) {
    final color =
        context != null ? Theme.of(context).primaryColor : Color(0xFF5625BA);

    return AndroidNotificationDetails(
      AppConfig.pushNotificationsChannelId,
      AppConfig.pushNotificationsChannelName,
      AppConfig.pushNotificationsChannelDescription,
      styleInformation: styleInformation,
      importance: Importance.max,
      priority: Priority.high,
      ticker: ticker,
      color: color,
    );
  }
}
