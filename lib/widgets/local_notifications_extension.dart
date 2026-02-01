import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/desktop_notifications_manager.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/push_helper.dart';
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
    final body = await event.calcLocalizedBody(
      MatrixLocals(L10n.of(context)),
      withSenderNamePrefix:
          !event.room.isDirectChat ||
          event.room.lastEvent?.senderId == client.userID,
      plaintextBody: true,
      hideReply: true,
      hideEdit: true,
      removeMarkdown: true,
    );

    if (kIsWeb) {
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

      _audioPlayer.play();

      html.Notification(
        title,
        body: body,
        icon: thumbnailUri?.toString(),
        tag: event.room.id,
      );
    } else if (DesktopNotificationsManager.isSupported) {
      // Download and decode avatar for desktop notifications
      Uint8List? avatarData;
      int? avatarWidth;
      int? avatarHeight;

      final avatarUrl = event.room.avatar;
      if (avatarUrl != null && Platform.isLinux) {
        try {
          const size = notificationAvatarDimension;
          const thumbnailMethod = ThumbnailMethod.crop;
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
            avatarData = image.getBytes(order: ChannelOrder.rgba);
            avatarWidth = image.width;
            avatarHeight = image.height;
          }
        } catch (e, s) {
          Logs().d('Unable to download avatar for desktop notification', e, s);
        }
      }

      await DesktopNotificationsManager.instance.showNotification(
        title: title,
        body: body,
        roomId: roomId,
        eventId: event.eventId,
        avatarData: avatarData,
        avatarWidth: avatarWidth,
        avatarHeight: avatarHeight,
        openChatLabel: L10n.of(context).openChat,
        markAsReadLabel: L10n.of(context).markAsRead,
      );
    }
  }
}
