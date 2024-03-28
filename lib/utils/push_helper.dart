import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shortcuts/flutter_shortcuts.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/app_config.dart';
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
    Logs().v('Push Helper has crashed!', e, s);

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
      notification.roomId?.hashCode ?? 0,
      l10n.newMessageInFluffyChat,
      l10n.openAppToReadMessages,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          AppConfig.pushNotificationsChannelId,
          l10n.incomingMessages,
          number: notification.counts?.unread,
          ticker: l10n.unreadChatsInApp(
            AppConfig.applicationName,
            (notification.counts?.unread ?? 0).toString(),
          ),
          importance: Importance.high,
          priority: Priority.max,
          shortcutId: notification.roomId,
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

  if (notification.roomId != null &&
      activeRoomId == notification.roomId &&
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
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
    if (notification.counts?.unread == null ||
        notification.counts?.unread == 0) {
      await flutterLocalNotificationsPlugin.cancelAll();
    } else {
      // Make sure client is fully loaded and synced before dismiss notifications:
      await client.roomsLoading;
      await client.oneShotSync();
      final activeNotifications =
          await flutterLocalNotificationsPlugin.getActiveNotifications();
      for (final activeNotification in activeNotifications) {
        final room = client.rooms.singleWhereOrNull(
          (room) => room.id.hashCode == activeNotification.id,
        );
        if (room == null || !room.isUnreadOrInvited) {
          flutterLocalNotificationsPlugin.cancel(activeNotification.id!);
        }
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
        width: 256,
        height: 256,
      )
      .toString();
  final senderAvatar = event.room.isDirectChat
      ? avatar
      : event.senderFromMemoryOrFallback.avatarUrl
          ?.getThumbnail(
            client,
            width: 256,
            height: 256,
          )
          .toString();

  File? roomAvatarFile, senderAvatarFile;
  try {
    roomAvatarFile = avatar == null
        ? null
        : await DefaultCacheManager().getSingleFile(avatar);
  } catch (e, s) {
    Logs().e('Unable to get avatar picture', e, s);
  }
  try {
    senderAvatarFile = event.room.isDirectChat
        ? roomAvatarFile
        : senderAvatar == null
            ? null
            : await DefaultCacheManager().getSingleFile(senderAvatar);
  } catch (e, s) {
    Logs().e('Unable to get avatar picture', e, s);
  }

  final id = notification.roomId.hashCode;

  // Show notification

  final newMessage = Message(
    body,
    event.originServerTs,
    Person(
      bot: event.messageType == MessageTypes.Notice,
      key: event.senderId,
      name: event.senderFromMemoryOrFallback.calcDisplayname(),
      icon: senderAvatarFile == null
          ? null
          : BitmapFilePathAndroidIcon(senderAvatarFile.path),
    ),
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
    AppConfig.pushNotificationsChannelId,
    l10n.incomingMessages,
    number: notification.counts?.unread,
    category: AndroidNotificationCategory.message,
    shortcutId: event.room.id,
    styleInformation: messagingStyleInformation ??
        MessagingStyleInformation(
          Person(
            name: event.senderFromMemoryOrFallback.calcDisplayname(),
            icon: roomAvatarFile == null
                ? null
                : BitmapFilePathAndroidIcon(roomAvatarFile.path),
            key: event.roomId,
            important: event.room.isFavourite,
          ),
          conversationTitle: roomName,
          groupConversation: !event.room.isDirectChat,
          messages: [newMessage],
        ),
    ticker: event.calcLocalizedBodyFallback(
      matrixLocals,
      plaintextBody: true,
      withSenderNamePrefix: true,
      hideReply: true,
      hideEdit: true,
      removeMarkdown: true,
    ),
    importance: Importance.high,
    priority: Priority.max,
    groupKey: notificationGroupId,
  );
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  final title = event.room.getLocalizedDisplayname(MatrixLocals(l10n));

  if (PlatformInfos.isAndroid && messagingStyleInformation == null) {
    await _setShortcut(event, l10n, title, roomAvatarFile);
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: event.roomId,
  );
  Logs().v('Push helper has been completed!');
}

/// Creates a shortcut for Android platform but does not block displaying the
/// notification. This is optional but provides a nicer view of the
/// notification popup.
Future<void> _setShortcut(
  Event event,
  L10n l10n,
  String title,
  File? avatarFile,
) async {
  final flutterShortcuts = FlutterShortcuts();
  await flutterShortcuts.initialize(debug: !kReleaseMode);
  await flutterShortcuts.pushShortcutItem(
    shortcut: ShortcutItem(
      id: event.room.id,
      action: AppConfig.inviteLinkPrefix + event.room.id,
      shortLabel: title,
      conversationShortcut: true,
      icon: avatarFile == null
          ? null
          : ShortcutMemoryIcon(jpegImage: await avatarFile.readAsBytes())
              .toString(),
      shortcutIconAsset: avatarFile == null
          ? ShortcutIconAsset.androidAsset
          : ShortcutIconAsset.memoryAsset,
      isImportant: event.room.isFavourite,
    ),
  );
}
