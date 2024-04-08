import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension LocalNotificationsExtension on MatrixState {
  static final html.AudioElement _audioPlayer = html.AudioElement()
    ..src = 'assets/assets/sounds/notification.ogg'
    ..load();

  void showLocalNotification(EventUpdate eventUpdate) async {
    final roomId = eventUpdate.roomID;
    if (activeRoomId == roomId) {
      if (kIsWeb && webHasFocus) return;
      if (PlatformInfos.isDesktop &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        return;
      }
    }
    final room = client.getRoomById(roomId);
    if (room == null) {
      Logs().w('Can not display notification for unknown room $roomId');
      return;
    }
    if (room.notificationCount == 0) return;

    final event = Event.fromJson(eventUpdate.content, room);
    final title = room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));
    final body = await event.calcLocalizedBody(
      MatrixLocals(L10n.of(context)!),
      withSenderNamePrefix:
          !room.isDirectChat || room.lastEvent?.senderId == client.userID,
      plaintextBody: true,
      hideReply: true,
      hideEdit: true,
      removeMarkdown: true,
    );
    final icon = event.senderFromMemoryOrFallback.avatarUrl?.getThumbnail(
          client,
          width: 64,
          height: 64,
          method: ThumbnailMethod.crop,
        ) ??
        room.avatar?.getThumbnail(
          client,
          width: 64,
          height: 64,
          method: ThumbnailMethod.crop,
        );
    if (kIsWeb) {
      _audioPlayer.play();
      html.Notification(
        title,
        body: body,
        icon: icon.toString(),
      );
    } else if (Platform.isLinux) {
      final appIconUrl = room.avatar?.getThumbnail(
        room.client,
        width: 56,
        height: 56,
      );
      File? appIconFile;
      if (appIconUrl != null) {
        final tempDirectory = await getApplicationSupportDirectory();
        final avatarDirectory =
            await Directory('${tempDirectory.path}/notiavatars/').create();
        appIconFile = File(
          '${avatarDirectory.path}/${Uri.encodeComponent(appIconUrl.toString())}',
        );
        if (await appIconFile.exists() == false) {
          final response = await http.get(appIconUrl);
          await appIconFile.writeAsBytes(response.bodyBytes);
        }
      }
      final notification = await linuxNotifications!.notify(
        title,
        body: body,
        replacesId: linuxNotificationIds[roomId] ?? 0,
        appName: AppConfig.applicationName,
        appIcon: appIconFile?.path ?? '',
        actions: [
          NotificationAction(
            DesktopNotificationActions.openChat.name,
            L10n.of(context)!.openChat,
          ),
          NotificationAction(
            DesktopNotificationActions.seen.name,
            L10n.of(context)!.markAsRead,
          ),
        ],
        hints: [
          NotificationHint.soundName('message-new-instant'),
        ],
      );
      notification.action.then((actionStr) {
        final action = DesktopNotificationActions.values
            .singleWhere((a) => a.name == actionStr);
        switch (action) {
          case DesktopNotificationActions.seen:
            room.setReadMarker(
              event.eventId,
              mRead: event.eventId,
              public: AppConfig.sendPublicReadReceipts,
            );
            break;
          case DesktopNotificationActions.openChat:
            context.go('/rooms/${room.id}');
            break;
        }
      });
      linuxNotificationIds[roomId] = notification.id;
    }
  }
}

enum DesktopNotificationActions { seen, openChat }
