import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:famedlysdk/famedlysdk.dart';
import '../utils/event_extension.dart';
import '../utils/room_extension.dart';
import 'famedlysdk_store.dart';

abstract class FirebaseController {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static BuildContext context;

  static Future<void> setupFirebase(Client client, String clientName) async {
    if (Platform.isIOS) iOS_Permission();

    String token;
    try {
      token = await _firebaseMessaging.getToken();
    } catch (_) {
      token = null;
    }
    if (token?.isEmpty ?? true) {
      showToast(
        I18n.of(context).noGoogleServicesWarning,
        duration: Duration(seconds: 15),
      );
      return;
    }
    await client.setPushers(
      token,
      "http",
      "chat.fluffy.fluffychat",
      clientName,
      client.deviceName,
      "en",
      "https://janian.de:7022/",
      append: false,
      format: "event_id_only",
    );

    Function goToRoom = (dynamic message) async {
      try {
        String roomId;
        if (message is String) {
          roomId = message;
        } else if (message is Map) {
          roomId = (message["data"] ?? message)["room_id"];
        }
        if (roomId?.isEmpty ?? true) throw ("Bad roomId");
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (r) => r.isFirst);
      } catch (_) {
        showToast("Failed to open chat...");
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
        initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: goToRoom);

    _firebaseMessaging.configure(
      onMessage: _onMessage,
      onBackgroundMessage: _onMessage,
      onResume: goToRoom,
      onLaunch: goToRoom,
    );
    debugPrint("[Push] Firebase initialized");
    return;
  }

  static Future<dynamic> _onMessage(Map<String, dynamic> message) async {
    try {
      final data = message['data'] ?? message;
      final String roomId = data["room_id"];
      final String eventId = data["event_id"];
      final int unread = json.decode(data["counts"])["unread"];
      if ((roomId?.isEmpty ?? true) ||
          (eventId?.isEmpty ?? true) ||
          unread == 0) {
        await _flutterLocalNotificationsPlugin.cancelAll();
        return null;
      }
      if (context != null && Matrix.of(context).activeRoomId == roomId) {
        return null;
      }
      final i18n = context == null ? I18n('en') : I18n.of(context);

      // Get the client
      Client client;
      if (context != null) {
        client = Matrix.of(context).client;
      } else {
        final platform = kIsWeb ? "Web" : Platform.operatingSystem;
        final clientName = "FluffyChat $platform";
        client = Client(clientName, debug: false);
        client.storeAPI = ExtendedStore(client);
        await client.onLoginStateChanged.stream
            .firstWhere((l) => l == LoginState.logged)
            .timeout(
              Duration(seconds: 5),
            );
      }

      // Get the room
      Room room = client.getRoomById(roomId);
      if (room == null) {
        await client.onRoomUpdate.stream
            .where((u) => u.id == roomId)
            .first
            .timeout(Duration(seconds: 5));
        room = client.getRoomById(roomId);
        if (room == null) return null;
      }

      // Get the event
      Event event = await client.store.getEventById(eventId, room);
      if (event == null) {
        final EventUpdate eventUpdate = await client.onEvent.stream
            .where((u) => u.content["event_id"] == eventId)
            .first
            .timeout(Duration(seconds: 5));
        event = Event.fromJson(eventUpdate.content, room);
        if (room == null) return null;
      }

      // Count all unread events
      int unreadEvents = 0;
      client.rooms
          .forEach((Room room) => unreadEvents += room.notificationCount);

      // Calculate title
      final String title = unread > 1
          ? i18n.unreadMessagesInChats(
              unreadEvents.toString(), unread.toString())
          : i18n.unreadMessages(unreadEvents.toString());

      // Calculate the body
      final String body = event.getLocalizedBody(
        i18n,
        withSenderNamePrefix: true,
        hideReply: true,
      );

      // The person object for the android message style notification
      final person = Person(
        name: room.getLocalizedDisplayname(i18n),
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
          'fluffychat_push',
          'FluffyChat push channel',
          'Push notifications for FluffyChat',
          styleInformation: MessagingStyleInformation(
            person,
            conversationTitle: title,
            messages: [
              Message(
                body,
                event.time,
                person,
              )
            ],
          ),
          importance: Importance.Max,
          priority: Priority.High,
          ticker: i18n.newMessageInFluffyChat);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
          0, room.getLocalizedDisplayname(i18n), body, platformChannelSpecifics,
          payload: roomId);
    } catch (exception) {
      debugPrint("[Push] Error while processing notification: " +
          exception.toString());
      await _showDefaultNotification(message);
    }
    return null;
  }

  static Future<dynamic> _showDefaultNotification(
      Map<String, dynamic> message) async {
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      // Init notifications framework
      var initializationSettingsAndroid =
          AndroidInitializationSettings('notifications_icon');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Notification data and matrix data
      Map<dynamic, dynamic> data = message['data'] ?? message;
      String eventID = data["event_id"];
      String roomID = data["room_id"];
      final int unread = data.containsKey("counts")
          ? json.decode(data["counts"])["unread"]
          : 1;
      await flutterLocalNotificationsPlugin.cancelAll();
      if (unread == 0 || roomID == null || eventID == null) {
        return;
      }

      // Display notification
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'fluffychat_push',
          'FluffyChat push channel',
          'Push notifications for FluffyChat',
          importance: Importance.Max,
          priority: Priority.High);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      final String title = "$unread unread chats";
      await flutterLocalNotificationsPlugin.show(
          1, title, 'Open app to read messages', platformChannelSpecifics,
          payload: roomID);
    } catch (exception) {
      debugPrint("[Push] Error while processing background notification: " +
          exception.toString());
    }
    return Future<void>.value();
  }

  static Future<String> downloadAndSaveAvatar(Uri content, Client client,
      {int width, int height}) async {
    final bool thumbnail = width == null && height == null ? false : true;
    final String tempDirectory = (await getTemporaryDirectory()).path;
    final String prefix = thumbnail ? "thumbnail" : "";
    File file =
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
      debugPrint("Settings registered: $settings");
    });
  }
}
