import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:pedantic/pedantic.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import '../../utils/date_time_extension.dart';
import '../../widgets/avatar.dart';
import '../../widgets/matrix.dart';
import '../chat/send_file_dialog.dart';

enum ArchivedRoomAction { delete, rejoin }

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;
  final bool selected;
  final Function? onForget;
  final Function? onTap;
  final Function? onLongPress;

  const ChatListItem(
    this.room, {
    this.activeChat = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.onForget,
    Key? key,
  }) : super(key: key);

  dynamic clickAction(BuildContext context) async {
    if (onTap != null) return onTap!();
    if (!activeChat) {
      if (room.membership == Membership.invite &&
          (await showFutureLoadingDialog(
                      context: context,
                      future: () async {
                        final joinedFuture = room.client.onSync.stream
                            .where((u) =>
                                u.rooms?.join?.containsKey(room.id) ?? false)
                            .first;
                        await room.join();
                        await joinedFuture;
                      }))
                  .error !=
              null) {
        return;
      }

      if (room.membership == Membership.ban) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context)!.youHaveBeenBannedFromThisChat),
          ),
        );
        return;
      }

      if (room.membership == Membership.leave) {
        final action = await showModalActionSheet<ArchivedRoomAction>(
          context: context,
          title: L10n.of(context)!.archivedRoom,
          message: L10n.of(context)!.thisRoomHasBeenArchived,
          actions: [
            SheetAction(
              label: L10n.of(context)!.rejoin,
              key: ArchivedRoomAction.rejoin,
            ),
            SheetAction(
              label: L10n.of(context)!.delete,
              key: ArchivedRoomAction.delete,
              isDestructiveAction: true,
            ),
          ],
        );
        if (action != null) {
          switch (action) {
            case ArchivedRoomAction.delete:
              await archiveAction(context);
              break;
            case ArchivedRoomAction.rejoin:
              await showFutureLoadingDialog(
                context: context,
                future: () => room.join(),
              );
              break;
          }
        }
      }

      if (room.membership == Membership.join) {
        if (Matrix.of(context).shareContent != null) {
          if (Matrix.of(context).shareContent!['msgtype'] ==
              'chat.fluffy.shared_file') {
            await showDialog(
              context: context,
              useRootNavigator: false,
              builder: (c) => SendFileDialog(
                file: Matrix.of(context).shareContent!['file'],
                room: room,
              ),
            );
          } else {
            unawaited(room.sendEvent(Matrix.of(context).shareContent!));
          }
          Matrix.of(context).shareContent = null;
        }
        VRouter.of(context).toSegments(['rooms', room.id]);
      }
    }
  }

  Future<void> archiveAction(BuildContext context) async {
    {
      if ([Membership.leave, Membership.ban].contains(room.membership)) {
        final success = await showFutureLoadingDialog(
          context: context,
          future: () => room.forget(),
        );
        if (success.error == null) {
          if (onForget != null) onForget!();
        }
        return;
      }
      final confirmed = await showOkCancelAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context)!.areYouSure,
        okLabel: L10n.of(context)!.yes,
        cancelLabel: L10n.of(context)!.no,
      );
      if (confirmed == OkCancelResult.cancel) return;
      await showFutureLoadingDialog(
          context: context, future: () => room.leave());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = room.pushRuleState != PushRuleState.notify;
    final typingText = room.getLocalizedTypingText(context);
    final ownMessage =
        room.lastEvent?.senderId == Matrix.of(context).client.userID;
    final unread = room.isUnread || room.membership == Membership.invite;
    final unreadBubbleSize = unread || room.hasNewMessages
        ? room.notificationCount > 0
            ? 20.0
            : 14.0
        : 0.0;
    return Material(
      color: selected
          ? Theme.of(context).primaryColor.withAlpha(100)
          : activeChat
              ? Theme.of(context).secondaryHeaderColor
              : Colors.transparent,
      child: ListTile(
        selected: selected || activeChat,
        onLongPress: onLongPress as void Function()?,
        leading: selected
            ? SizedBox(
                width: Avatar.defaultSize,
                height: Avatar.defaultSize,
                child: Material(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Avatar.defaultSize),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              )
            : Avatar(
                mxContent: room.avatar,
                name: room.displayname,
                onTap: onLongPress as void Function()?,
              ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: unread
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            if (isMuted)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: 16,
                ),
              ),
            if (room.isFavourite)
              Padding(
                padding: EdgeInsets.only(
                    right: room.notificationCount > 0 ? 4.0 : 0.0),
                child: Icon(
                  Icons.push_pin_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                room.timeCreated.localizedTimeShort(context),
                style: TextStyle(
                  fontSize: 13,
                  color: unread
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (typingText.isEmpty &&
                ownMessage &&
                room.lastEvent!.status.isSending) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
              const SizedBox(width: 4),
            ],
            AnimatedContainer(
              width: typingText.isEmpty ? 0 : 18,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 14,
              ),
            ),
            Expanded(
              child: typingText.isNotEmpty
                  ? Text(
                      typingText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      softWrap: false,
                    )
                  : Text(
                      room.membership == Membership.invite
                          ? L10n.of(context)!.youAreInvitedToThisChat
                          : room.lastEvent?.getLocalizedBody(
                                MatrixLocals(L10n.of(context)!),
                                hideReply: true,
                                hideEdit: true,
                                plaintextBody: true,
                                removeMarkdown: true,
                                withSenderNamePrefix: !room.isDirectChat ||
                                    room.directChatMatrixID !=
                                        room.lastEvent?.senderId,
                              ) ??
                              L10n.of(context)!.emptyChat,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: unread
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).textTheme.bodyText2!.color,
                        decoration: room.lastEvent?.redacted == true
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              height: unreadBubbleSize,
              width:
                  room.notificationCount == 0 && !unread && !room.hasNewMessages
                      ? 0
                      : (unreadBubbleSize - 9) *
                              room.notificationCount.toString().length +
                          9,
              decoration: BoxDecoration(
                color: room.highlightCount > 0
                    ? Colors.red
                    : room.notificationCount > 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              ),
              child: Center(
                child: room.notificationCount > 0
                    ? Text(
                        room.notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
        onTap: () => clickAction(context),
      ),
    );
  }
}
