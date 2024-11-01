import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shortcuts/flutter_shortcuts.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/background_push.dart' show clientFromInstance;
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/callkeep_manager.dart';

//TODO: maybe introduce a class

Future<void> pushHelper(
  PushNotification notification, {
  List<Client>? clients,
  L10n? l10n,
  String? activeRoomId,
  Client? activeClient,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  required String instance,
}) async {
  try {
    await _tryPushHelper(
      notification,
      clients: clients,
      instance: instance,
      l10n: l10n,
      activeRoomId: activeRoomId,
      activeClient: activeClient,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  } catch (e, s) {
    Logs().v('Push Helper has crashed!', e, s);

    l10n ??= await lookupL10n(const Locale('en'));
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
  List<Client>? clients,
  L10n? l10n,
  String? activeRoomId,
  Client? activeClient,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  required String instance,
}) async {
  final isBackgroundMessage = clients == null;
  Logs().v(
    'Push helper has been started (background=$isBackgroundMessage).',
    notification.toJson(),
  );

  clients ??= (await ClientManager.getClients(
    initialize: false,
    store: await SharedPreferences.getInstance(),
  ));
  final client = clientFromInstance(instance, clients);
  if (client == null) {
    Logs().e("Not client could be found for $instance");
    return;
  }

  if (isInForeground(notification, activeRoomId, activeClient, client)) {
    Logs().v('Room is in foreground. Stop push helper here.');
    return;
  }

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

  if ((event.type.startsWith('m.call') &&
          event.type != EventTypes.CallInvite) ||
      event.type == EventTypes.CallSDPStreamMetadataChangedPrefix) {
    Logs().v('Push message was for a call, but not call invite.');
    return;
  }

  showNotification(
      l10n, event, notification, client, flutterLocalNotificationsPlugin);
  Logs().v('Push helper has been completed!');
}

Future<void> showNotification(
  L10n? l10n,
  Event event,
  PushNotification notification,
  Client client,
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
) async {
  l10n ??= await L10n.delegate.load(PlatformDispatcher.instance.locale);
  final locals = MatrixLocals(l10n);

  // Calculate the body
  final body = event.type == EventTypes.Encrypted
      ? l10n.newMessageInFluffyChat
      : await event.calcLocalizedBody(
          locals,
          plaintextBody: true,
          withSenderNamePrefix: false,
          hideReply: true,
          hideEdit: true,
          removeMarkdown: true,
        );

  final id = notification.roomId.hashCode;
  final title = event.room.getLocalizedDisplayname(locals);
  final roomName = event.room.getLocalizedDisplayname(locals);

  var notificationGroupId =
      event.room.isDirectChat ? 'directChats' : 'groupChats';
  notificationGroupId += client.clientName;
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

  final platformChannelSpecifics = await getPlatformChannelSpecifics(
    l10n,
    notification,
    event,
    client,
    id,
    body,
    title,
    roomName,
  );

  return await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: jsonEncode(
      NotificationResponsePayload(
        event.roomId ?? "",
        client.clientName,
      ).toJson(),
    ),
  );
}

Future<NotificationDetails> getPlatformChannelSpecifics(
  L10n l10n,
  PushNotification notification,
  Event event,
  Client client,
  int notificationId,
  String notificationBody,
  String notificationTitle,
  String roomName,
) async {
  // The person object for the android message style notification
  final avatar = event.room.avatar;
  final senderAvatar = event.room.isDirectChat
      ? avatar
      : event.senderFromMemoryOrFallback.avatarUrl;

  final roomAvatarFile = await getAvatarFile(client, avatar);
  final senderAvatarFile = event.room.isDirectChat
      ? roomAvatarFile
      : await getAvatarFile(client, senderAvatar);

  // Show notification
  final newMessage = Message(
    notificationTitle,
    event.originServerTs,
    Person(
      bot: event.messageType == MessageTypes.Notice,
      key: event.senderId,
      name: event.senderFromMemoryOrFallback.calcDisplayname(),
      icon: senderAvatarFile == null
          ? null
          : ByteArrayAndroidIcon(senderAvatarFile),
    ),
  );

  final messagingStyleInformation = PlatformInfos.isAndroid
      ? await AndroidFlutterLocalNotificationsPlugin()
          .getActiveNotificationMessagingStyle(notificationId)
      : null;
  messagingStyleInformation?.messages?.add(newMessage);

  if (PlatformInfos.isAndroid && messagingStyleInformation == null) {
    await _setShortcut(event, l10n, notificationTitle, roomAvatarFile);
  }

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
                : ByteArrayAndroidIcon(roomAvatarFile),
            key: event.roomId,
            important: event.room.isFavourite,
          ),
          conversationTitle: roomName,
          groupConversation: !event.room.isDirectChat,
          messages: [newMessage],
        ),
    ticker: event.calcLocalizedBodyFallback(
      MatrixLocals(l10n),
      plaintextBody: true,
      withSenderNamePrefix: true,
      hideReply: true,
      hideEdit: true,
      removeMarkdown: true,
    ),
    importance: Importance.high,
    priority: Priority.max,
    groupKey: event.room.spaceParents.firstOrNull?.roomId ?? 'rooms',
  );
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  return NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
}

/// Creates a shortcut for Android platform but does not block displaying the
/// notification. This is optional but provides a nicer view of the
/// notification popup.
Future<void> _setShortcut(
  Event event,
  L10n l10n,
  String title,
  Uint8List? avatarFile,
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
          : ShortcutMemoryIcon(jpegImage: avatarFile).toString(),
      shortcutIconAsset: avatarFile == null
          ? ShortcutIconAsset.androidAsset
          : ShortcutIconAsset.memoryAsset,
      isImportant: event.room.isFavourite,
    ),
  );
}

Future<Uint8List?> getAvatarFile(Client client, Uri? avatar) async {
  try {
    return avatar == null
        ? null
        : await client
            .downloadMxcCached(
              avatar,
              thumbnailMethod: ThumbnailMethod.scale,
              width: 256,
              height: 256,
              animated: false,
              isThumbnail: true,
            )
            .timeout(const Duration(seconds: 3));
  } catch (e, s) {
    Logs().e('Unable to get avatar picture', e, s);
    return null;
  }
}

bool isInForeground(
  PushNotification notification,
  String? activeRoomId,
  Client? activeClient,
  Client notifiedClient,
) {
  return notification.roomId != null &&
      activeRoomId == notification.roomId &&
      activeClient == notifiedClient &&
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
}

class NotificationResponsePayload {
  final String roomId;
  final String clientName;

  NotificationResponsePayload(this.roomId, this.clientName);

  NotificationResponsePayload.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        clientName = json['clientName'];

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'clientName': clientName,
    };
  }
}
