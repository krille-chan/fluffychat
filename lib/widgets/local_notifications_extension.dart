import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:image/image.dart';
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/join_codes/knock_notification_utils.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/push_helper.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension LocalNotificationsExtension on MatrixState {
  static final html.AudioElement _audioPlayer = html.AudioElement()
    ..src = 'assets/assets/sounds/notification.ogg'
    ..load();

  void showLocalNotification(Event event) async {
    final roomId = event.room.id;
    if (activeRoomId == roomId) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        return;
      }
    }

    final title = event.room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );
    // #Pangea
    // final body = await event.calcLocalizedBody(
    //   MatrixLocals(L10n.of(context)),
    //   withSenderNamePrefix:
    //       !event.room.isDirectChat ||
    //       event.room.lastEvent?.senderId == client.userID,
    //   plaintextBody: true,
    //   hideReply: true,
    //   hideEdit: true,
    //   removeMarkdown: true,
    // );
    final body = isKnockAcceptedInviteForClient(event: event, client: client)
        ? L10n.of(context).knockAccepted
        : await event.calcLocalizedBody(
            MatrixLocals(L10n.of(context)),
            withSenderNamePrefix:
                !event.room.isDirectChat ||
                event.room.lastEvent?.senderId == client.userID,
            plaintextBody: true,
            hideReply: true,
            hideEdit: true,
            removeMarkdown: true,
          );
    // Pangea#

    if (kIsWeb) {
      // #Pangea
      if (html.Notification.permission != 'granted') return;
      // Pangea#
      final avatarUrl = event.senderFromMemoryOrFallback.avatarUrl;
      Uri? thumbnailUri;

      if (avatarUrl != null) {
        const size = 128;
        const thumbnailMethod = ThumbnailMethod.crop;
        // Pre-cache so that we can later just set the thumbnail uri as icon:
        try {
          await client.downloadMxcCached(
            avatarUrl,
            width: size,
            height: size,
            thumbnailMethod: thumbnailMethod,
            isThumbnail: true,
            rounded: true,
          );
        } catch (e, s) {
          Logs().d('Unable to pre-download avatar for web notification', e, s);
        }

        thumbnailUri = await event.senderFromMemoryOrFallback.avatarUrl
            ?.getThumbnailUri(
              client,
              width: size,
              height: size,
              method: thumbnailMethod,
            );
      }

      // #Pangea
      _audioPlayer.volume = AppSettings.volume.value;
      // Pangea#
      _audioPlayer.play();

      html.Notification(
        title,
        body: body,
        icon: thumbnailUri?.toString(),
        tag: event.room.id,
      );
    } else if (Platform.isLinux) {
      final avatarUrl = event.room.avatar;
      final hints = [NotificationHint.soundName('message-new-instant')];

      if (avatarUrl != null) {
        const size = notificationAvatarDimension;
        const thumbnailMethod = ThumbnailMethod.crop;
        // Pre-cache so that we can later just set the thumbnail uri as icon:
        final data = await client.downloadMxcCached(
          avatarUrl,
          width: size,
          height: size,
          thumbnailMethod: thumbnailMethod,
          isThumbnail: true,
          rounded: true,
        );

        final image = decodeImage(data);
        if (image != null) {
          final realData = image.getBytes(order: ChannelOrder.rgba);
          hints.add(
            NotificationHint.imageData(
              image.width,
              image.height,
              realData,
              hasAlpha: true,
              channels: 4,
            ),
          );
        }
      }
      final notification = await linuxNotifications!.notify(
        title,
        body: body,
        replacesId: linuxNotificationIds[roomId] ?? 0,
        appName: AppSettings.applicationName.value,
        appIcon: 'fluffychat',
        actions: [
          NotificationAction(
            DesktopNotificationActions.openChat.name,
            L10n.of(context).openChat,
          ),
          NotificationAction(
            DesktopNotificationActions.seen.name,
            L10n.of(context).markAsRead,
          ),
        ],
        hints: hints,
      );
      notification.action.then((actionStr) {
        var action = DesktopNotificationActions.values.singleWhereOrNull(
          (a) => a.name == actionStr,
        );
        if (action == null && actionStr == "default") {
          action = DesktopNotificationActions.openChat;
        }
        switch (action!) {
          case DesktopNotificationActions.seen:
            event.room.setReadMarker(
              event.eventId,
              mRead: event.eventId,
              public: AppSettings.sendPublicReadReceipts.value,
            );
            break;
          case DesktopNotificationActions.openChat:
            setActiveClient(event.room.client);

            FluffyChatApp.router.go('/rooms/${event.room.id}');
            break;
        }
      });
      linuxNotificationIds[roomId] = notification.id;
    }
  }

  // #Pangea
  Future<bool> get notificationsEnabled {
    return kIsWeb
        ? Future.value(html.Notification.permission == 'granted')
        : Permission.notification.isGranted;
  }

  Future<void> requestNotificationPermission() async {
    try {
      if (kIsWeb) {
        await html.Notification.requestPermission();
      } else {
        final status = await Permission.notification.request();
        if (status.isGranted) {
          // Notification permissions granted
        } else if (status.isDenied) {
          // Notification permissions denied
        } else if (status.isPermanentlyDenied) {
          // Notification permissions permanently denied, open app settings
          await openAppSettings();
        }
      }

      notifPermissionNotifier.value = notifPermissionNotifier.value + 1;
    } catch (e, s) {
      final permission = await notificationsEnabled;
      ErrorHandler.logError(e: e, s: s, data: {'permission': permission});
    }
  }

  // Pangea#
}

enum DesktopNotificationActions { seen, openChat }
