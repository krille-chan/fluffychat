import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat_settings/utils/delete_room.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/delete_space_dialog.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

void chatContextMenuAction(
  Room room,
  BuildContext context,
  BuildContext outerContext,
  VoidCallback onChatTap, [
  Room? space,
]) async {
  final theme = Theme.of(context);
  final l10n = L10n.of(context);

  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final button = context.findRenderObject() as RenderBox;

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(const Offset(0, -65), ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  final displayname = room.getLocalizedDisplayname(MatrixLocals(l10n));

  final action = await showMenu<ChatContextAction>(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        value: ChatContextAction.open,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            Avatar(
              mxContent: room.avatar,
              name: displayname,
              userId: room.directChatMatrixID,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 128),
              child: Text(
                displayname,
                style: TextStyle(color: theme.colorScheme.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      if (space != null)
        PopupMenuItem(
          value: ChatContextAction.goToSpace,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(
                mxContent: space.avatar,
                size: Avatar.defaultSize / 2,
                name: space.getLocalizedDisplayname(),
                userId: space.directChatMatrixID,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.goToCourse(space.getLocalizedDisplayname()),
                ),
              ),
            ],
          ),
        ),
      if (room.membership == Membership.join) ...[
        PopupMenuItem(
          value: ChatContextAction.mute,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                room.pushRuleState == PushRuleState.notify
                    ? Icons.notifications_on_outlined
                    : Icons.notifications_off_outlined,
              ),
              const SizedBox(width: 12),
              Text(
                room.pushRuleState == PushRuleState.notify
                    ? l10n.notificationsOn
                    : l10n.notificationsOff,
              ),
            ],
          ),
        ),
        if (!room.isActivitySession)
          PopupMenuItem(
            value: ChatContextAction.markUnread,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.markedUnread
                      ? Icons.mark_as_unread
                      : Icons.mark_as_unread_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.markedUnread ? l10n.markAsRead : l10n.markAsUnread,
                ),
              ],
            ),
          ),
        if (!room.isActivitySession)
          PopupMenuItem(
            value: ChatContextAction.favorite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.isFavourite ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.isFavourite ? l10n.unpin : l10n.pin,
                ),
              ],
            ),
          ),
      ],
      if (room.isActiveInActivity && room.isActivityStarted)
        PopupMenuItem(
          value: ChatContextAction.endActivity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.stop_circle_outlined,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.endActivity,
              ),
            ],
          ),
        ),
      if (!room.isActivitySession || room.ownRole == null)
        PopupMenuItem(
          value: ChatContextAction.leave,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout_outlined,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Text(
                room.membership == Membership.invite ? l10n.delete : l10n.leave,
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      if (room.isRoomAdmin && !room.isDirectChat)
        PopupMenuItem(
          value: ChatContextAction.delete,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outlined,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.delete,
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  if (action == null) return;

  switch (action) {
    case ChatContextAction.open:
      onChatTap.call();
      return;
    case ChatContextAction.goToSpace:
      outerContext.go("/rooms/spaces/${space!.id}/details");
      return;
    case ChatContextAction.favorite:
      await showFutureLoadingDialog(
        context: context,
        future: () => room.setFavourite(!room.isFavourite),
      );
      return;
    case ChatContextAction.markUnread:
      await showFutureLoadingDialog(
        context: context,
        future: () => room.markUnread(!room.markedUnread),
      );
      return;
    case ChatContextAction.mute:
      await showFutureLoadingDialog(
        context: context,
        future: () => room.setPushRuleState(
          room.pushRuleState == PushRuleState.notify
              ? PushRuleState.mentionsOnly
              : PushRuleState.notify,
        ),
      );
      return;
    case ChatContextAction.leave:
      final confirmed = await showOkCancelAlertDialog(
        context: context,
        title: l10n.areYouSure,
        message: room.isSpace
            ? l10n.leaveSpaceDescription
            : l10n.leaveRoomDescription,
        okLabel: l10n.leave,
        cancelLabel: l10n.cancel,
        isDestructive: true,
      );
      if (confirmed != OkCancelResult.ok) return;

      final resp = await showFutureLoadingDialog(
        context: context,
        future: room.isSpace ? room.leaveSpace : room.leave,
      );
      if (!resp.isError) {
        outerContext.go(
          room.courseParent != null
              ? "/rooms/spaces/${room.courseParent!.id}/details"
              : "/rooms",
        );
      }

      return;
    case ChatContextAction.delete:
      if (room.isSpace) {
        final resp = await showDialog<bool?>(
          context: context,
          builder: (_) => DeleteSpaceDialog(space: room),
        );
        if (resp == true) {
          context.go("/rooms");
        }
      } else {
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: l10n.areYouSure,
          okLabel: l10n.delete,
          cancelLabel: l10n.cancel,
          isDestructive: true,
          message: room.isSpace ? l10n.deleteSpaceDesc : l10n.deleteChatDesc,
        );
        if (confirmed != OkCancelResult.ok) return;
        final resp = await showFutureLoadingDialog(
          context: context,
          future: room.delete,
        );
        if (!resp.isError) {
          outerContext.go(
            room.courseParent != null
                ? "/rooms/spaces/${room.courseParent!.id}/details"
                : "/rooms",
          );
        }
      }
      return;
    case ChatContextAction.endActivity:
      await showFutureLoadingDialog(
        context: context,
        future: room.finishActivity,
      );
      return;
  }
}
