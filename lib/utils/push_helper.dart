import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';

Future<void> pushHelper(
  PushNotification notification, {
  Client? client,
  L10n? l10n,
  String? activeRoomId,
  Future<dynamic> Function(String?)? onSelectNotification,
}) async {
  final isBackgroundMessage = client == null;
  Logs().v(
    'Push helper has been started (background=$isBackgroundMessage).',
    notification.toJson(),
  );

  if (!isBackgroundMessage &&
      activeRoomId == notification.roomId &&
      activeRoomId != null &&
      client?.syncPresence == null) {
    Logs().v('Room is in foreground. Stop push helper here.');
    return;
  }

  // Initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await _flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('notifications_icon'),
      iOS: IOSInitializationSettings(
        onDidReceiveLocalNotification: (i, a, b, c) async => null,
      ),
    ),
    onSelectNotification: onSelectNotification,
  );

  client ??= (await ClientManager.getClients(initialize: false)).first;
  final event = await client.getEventByPushNotification(
    notification,
    storeInDatabase: isBackgroundMessage,
  );

  if (event == null) {
    Logs().v('Notification is a clearing indicator.');
    await _flutterLocalNotificationsPlugin.cancelAll();
    final store = await SharedPreferences.getInstance();
    await store.setString(SettingKeys.notificationCurrentIds, json.encode({}));
    return;
  }
  Logs().v('Push helper got notification event.');

  l10n ??= await L10n.delegate.load(window.locale);
  final matrixLocals = MatrixLocals(l10n);

  // Display notification// Calculate title
  final title = l10n.unreadMessages(notification.counts?.unread ?? 1);

  // Calculate the body
  final body = event.getLocalizedBody(
    matrixLocals,
    plaintextBody: true,
    hideReply: true,
    hideEdit: true,
    removeMarkdown: true,
  );

  // The person object for the android message style notification
  if (isBackgroundMessage) WidgetsFlutterBinding.ensureInitialized();
  final avatar = event.room.avatar?.toString();
  final person = Person(
    name: event.room.getLocalizedDisplayname(matrixLocals),
    icon: avatar == null ? null : ContentUriAndroidIcon(avatar),
  );

  // Show notification
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    AppConfig.pushNotificationsChannelId,
    AppConfig.pushNotificationsChannelName,
    AppConfig.pushNotificationsChannelDescription,
    styleInformation: MessagingStyleInformation(
      person,
      conversationTitle: title,
      groupConversation: !event.room.isDirectChat,
      messages: [
        Message(
          body,
          event.originServerTs,
          person,
        )
      ],
    ),
    ticker: l10n.newMessageInFluffyChat,
    importance: Importance.max,
    priority: Priority.high,
  );
  const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await _flutterLocalNotificationsPlugin.show(
    await mapRoomIdToInt(event.room.id),
    event.room.displayname,
    body,
    platformChannelSpecifics,
    payload: event.roomId,
  );
  Logs().v('Push helper has been completed!');
}

/// Workaround for the problem that local notification IDs must be int but we
/// sort by [roomId] which is a String. To make sure that we don't have duplicated
/// IDs we map the [roomId] to a number and store this number.
Future<int> mapRoomIdToInt(String roomId) async {
  final store = await SharedPreferences.getInstance();
  final idMap = Map<String, int>.from(jsonDecode(
      (store.getString(SettingKeys.notificationCurrentIds)) ?? '{}'));
  int? currentInt;
  try {
    currentInt = idMap[roomId];
  } catch (_) {
    currentInt = null;
  }
  if (currentInt != null) {
    return currentInt;
  }
  var nCurrentInt = 0;
  while (idMap.values.contains(currentInt)) {
    nCurrentInt++;
  }
  idMap[roomId] = nCurrentInt;
  await store.setString(SettingKeys.notificationCurrentIds, json.encode(idMap));
  return nCurrentInt;
}
