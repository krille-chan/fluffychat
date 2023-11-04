import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/callkeep_manager.dart';

Future<void> pushHelper(
  PushNotification notification, {
  Client? client,
  L10n? l10n,
  String? activeRoomId,
  void Function(NotificationResponse?)? onSelectNotification,
}) async {
  try {
    await _tryPushHelper(
      notification,
      client: client,
      l10n: l10n,
      activeRoomId: activeRoomId,
      onSelectNotification: onSelectNotification,
    );
  } catch (e, s) {
    Logs().wtf('Push Helper has crashed!', e, s);

    // Initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('notifications_icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    );

    l10n ??= lookupL10n(const Locale('en'));
    flutterLocalNotificationsPlugin.show(
      0,
      l10n.newMessageInFluffyChat,
      l10n.openAppToReadMessages,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          AppConfig.pushNotificationsChannelId,
          AppConfig.pushNotificationsChannelName,
          channelDescription: AppConfig.pushNotificationsChannelDescription,
          number: notification.counts?.unread,
          ticker: l10n.unreadChats(notification.counts?.unread ?? 1),
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
    );
    rethrow;
  }
}

Future<void> _tryPushHelper(
  PushNotification notification, {
  Client? client,
  L10n? l10n,
  String? activeRoomId,
  void Function(NotificationResponse?)? onSelectNotification,
}) async {
  final isBackgroundMessage = client == null;
  Logs().v(
    'Push helper has been started (background=$isBackgroundMessage).',
    notification.toJson(),
  );

  if (!isBackgroundMessage &&
      activeRoomId == notification.roomId &&
      activeRoomId != null &&
      client.syncPresence == null) {
    Logs().v('Room is in foreground. Stop push helper here.');
    return;
  }

  // Initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('notifications_icon'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: onSelectNotification,
    //onDidReceiveBackgroundNotificationResponse: onSelectNotification,
  );

  client ??= (await ClientManager.getClients(
    initialize: false,
    store: await SharedPreferences.getInstance(),
  ))
      .first;
  final event = await client.getEventByPushNotification(
    notification,
    storeInDatabase: isBackgroundMessage,
  );

  if (event == null) {
    Logs().v('Notification is a clearing indicator.');
    if (notification.counts?.unread == 0) {
      if (notification.counts == null || notification.counts?.unread == 0) {
        await flutterLocalNotificationsPlugin.cancelAll();
        final store = await SharedPreferences.getInstance();
        await store.setString(
          SettingKeys.notificationCurrentIds,
          json.encode({}),
        );
      }
    }
    return;
  }
  Logs().v('Push helper got notification event of type ${event.type}.');

  if (event.type.startsWith('m.call')) {
    // make sure bg sync is on (needed to update hold, unhold events)
    // prevent over write from app life cycle change
    client.backgroundSync = true;
  }

  if (event.type == EventTypes.CallInvite) {
    CallKeepManager().initialize();
  } else if (event.type == EventTypes.CallHangup) {
    client.backgroundSync = false;
  }

  if (event.type.startsWith('m.call') && event.type != EventTypes.CallInvite) {
    Logs().v('Push message is a m.call but not invite. Do not display.');
    return;
  }

  if ((event.type.startsWith('m.call') &&
          event.type != EventTypes.CallInvite) ||
      event.type == 'org.matrix.call.sdp_stream_metadata_changed') {
    Logs().v('Push message was for a call, but not call invite.');
    return;
  }

  l10n ??= await L10n.delegate.load(PlatformDispatcher.instance.locale);
  final matrixLocals = MatrixLocals(l10n);

  // Calculate the body
  final body = event.type == EventTypes.Encrypted
      ? l10n.newMessageInFluffyChat
      : await event.calcLocalizedBody(
          matrixLocals,
          plaintextBody: true,
          withSenderNamePrefix: false,
          hideReply: true,
          hideEdit: true,
          removeMarkdown: true,
        );

  // The person object for the android message style notification
  final avatar = event.room.avatar
      ?.getThumbnail(
        client,
        width: 126,
        height: 126,
      )
      .toString();
  File? avatarFile;
  try {
    avatarFile = avatar == null
        ? null
        : await DefaultCacheManager().getSingleFile(avatar);
  } catch (e, s) {
    Logs().e('Unable to get avatar picture', e, s);
  }

  final id = await mapRoomIdToInt(event.room.id);

  // Show notification
  final person = Person(
    name: event.senderFromMemoryOrFallback.calcDisplayname(),
    icon:
        avatarFile == null ? null : BitmapFilePathAndroidIcon(avatarFile.path),
  );
  final newMessage = Message(
    body,
    event.originServerTs,
    person,
  );

  final messagingStyleInformation = PlatformInfos.isAndroid
      ? await AndroidFlutterLocalNotificationsPlugin()
          .getActiveNotificationMessagingStyle(id)
      : null;
  messagingStyleInformation?.messages?.add(newMessage);

  final roomName = event.room.getLocalizedDisplayname(MatrixLocals(l10n));

  final notificationGroupId =
      event.room.isDirectChat ? 'directChats' : 'groupChats';
  final groupName = event.room.isDirectChat ? l10n.directChats : l10n.groups;

  final messageRooms = AndroidNotificationChannelGroup(
    notificationGroupId,
    groupName,
  );
  final roomsChannel = AndroidNotificationChannel(
    event.room.id,
    roomName,
    groupId: notificationGroupId,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannelGroup(messageRooms);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(roomsChannel);

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    event.room.id,
    roomName,
    channelDescription: groupName,
    number: notification.counts?.unread,
    category: AndroidNotificationCategory.message,
    styleInformation: messagingStyleInformation ??
        MessagingStyleInformation(
          person,
          conversationTitle: roomName,
          groupConversation: !event.room.isDirectChat,
          messages: [newMessage],
        ),
    ticker: l10n.unreadChats(notification.counts?.unread ?? 1),
    importance: Importance.max,
    priority: Priority.max,
    groupKey: notificationGroupId,
  );
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    id,
    event.room.getLocalizedDisplayname(
      MatrixLocals(l10n),
    ),
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
  final idMap = Map<String, int>.from(
    jsonDecode(store.getString(SettingKeys.notificationCurrentIds) ?? '{}'),
  );
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
  while (idMap.values.contains(nCurrentInt)) {
    nCurrentInt++;
  }
  idMap[roomId] = nCurrentInt;
  await store.setString(SettingKeys.notificationCurrentIds, json.encode(idMap));
  return nCurrentInt;
}
