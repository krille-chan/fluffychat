import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/room_status_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pedantic/pedantic.dart';

import '../../utils/date_time_extension.dart';
import '../avatar.dart';
import '../../pages/send_file_dialog.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../matrix.dart';
import '../mouse_over_builder.dart';

enum ArchivedRoomAction { delete, rejoin }

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;
  final bool selected;
  final Function onForget;
  final Function onTap;
  final Function onLongPress;

  const ChatListItem(this.room,
      {this.activeChat = false,
      this.selected = false,
      this.onTap,
      this.onLongPress,
      this.onForget});

  void clickAction(BuildContext context) async {
    if (onTap != null) return onTap();
    if (!activeChat) {
      if (room.membership == Membership.invite &&
          (await showFutureLoadingDialog(
                      context: context, future: () => room.join()))
                  .error !=
              null) {
        return;
      }

      if (room.membership == Membership.ban) {
        AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).youHaveBeenBannedFromThisChat),
          ),
        );
        return;
      }

      if (room.membership == Membership.leave) {
        final action = await showModalActionSheet<ArchivedRoomAction>(
          context: context,
          title: L10n.of(context).archivedRoom,
          message: L10n.of(context).thisRoomHasBeenArchived,
          actions: [
            SheetAction(
              label: L10n.of(context).rejoin,
              key: ArchivedRoomAction.rejoin,
            ),
            SheetAction(
              label: L10n.of(context).delete,
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
          if (Matrix.of(context).shareContent['msgtype'] ==
              'chat.fluffy.shared_file') {
            await showDialog(
              context: context,
              builder: (c) => SendFileDialog(
                file: Matrix.of(context).shareContent['file'],
                room: room,
              ),
              useRootNavigator: false,
            );
          } else {
            unawaited(room.sendEvent(Matrix.of(context).shareContent));
          }
          Matrix.of(context).shareContent = null;
        }
        await AdaptivePageLayout.of(context)
            .pushNamedAndRemoveUntilIsFirst('/rooms/${room.id}');
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
          if (onForget != null) onForget();
        }
        return success;
      }
      final confirmed = await showOkCancelAlertDialog(
        context: context,
        title: L10n.of(context).areYouSure,
        okLabel: L10n.of(context).yes,
        cancelLabel: L10n.of(context).no,
        useRootNavigator: false,
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
    return Center(
      child: Material(
        color: FluffyThemes.chatListItemColor(context, activeChat, selected),
        child: ListTile(
          onLongPress: onLongPress,
          leading: MouseOverBuilder(
            builder: (context, hover) =>
                onLongPress != null && (hover || selected)
                    ? Container(
                        width: Avatar.defaultSize,
                        height: Avatar.defaultSize,
                        alignment: Alignment.center,
                        child: Checkbox(
                          value: selected,
                          onChanged: (_) => onLongPress(),
                        ),
                      )
                    : Avatar(room.avatar, room.displayname),
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              if (isMuted)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.notifications_off_outlined,
                    size: 16,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  room.timeCreated.localizedTimeShort(context),
                  style: TextStyle(
                    fontSize: 13,
                    color: room.notificationCount > 0
                        ? Theme.of(context).accentColor
                        : null,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (typingText.isEmpty && ownMessage) ...{
                Icon(
                  room.lastEvent.statusIcon,
                  size: 14,
                ),
                SizedBox(width: 4),
              },
              if (typingText.isNotEmpty) ...{
                Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).accentColor,
                  size: 14,
                ),
                SizedBox(width: 4),
              },
              Expanded(
                child: typingText.isNotEmpty
                    ? Text(
                        typingText,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                        softWrap: false,
                      )
                    : room.membership == Membership.invite
                        ? Text(
                            L10n.of(context).youAreInvitedToThisChat,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                            softWrap: false,
                          )
                        : Text(
                            room.lastEvent?.getLocalizedBody(
                                  MatrixLocals(L10n.of(context)),
                                  withSenderNamePrefix:
                                      !ownMessage && !room.isDirectChat,
                                  hideReply: true,
                                ) ??
                                '',
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: room.lastEvent?.redacted == true
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
              ),
              SizedBox(width: 8),
              if (room.isFavourite)
                Padding(
                  padding: EdgeInsets.only(
                      right: room.notificationCount > 0 ? 4.0 : 0.0),
                  child: Icon(
                    Icons.push_pin_outlined,
                    size: 20,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              if (room.isUnread)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  height: room.notificationCount > 0 ? 20 : 14,
                  decoration: BoxDecoration(
                    color: room.highlightCount > 0 || room.markedUnread
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: room.notificationCount > 0
                        ? Text(
                            room.notificationCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Container(),
                  ),
                ),
            ],
          ),
          onTap: () => clickAction(context),
        ),
      ),
    );
  }
}
