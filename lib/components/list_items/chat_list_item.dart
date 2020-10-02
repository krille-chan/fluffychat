import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pedantic/pedantic.dart';

import '../../l10n/l10n.dart';
import '../../utils/app_route.dart';
import '../../utils/date_time_extension.dart';
import '../../views/chat.dart';
import '../theme_switcher.dart';
import '../avatar.dart';
import '../dialogs/simple_dialogs.dart';
import '../matrix.dart';
import '../dialogs/send_file_dialog.dart';

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
          await SimpleDialogs(context)
                  .tryRequestWithLoadingDialog(room.join()) ==
              false) {
        return;
      }

      if (room.membership == Membership.ban) {
        BotToast.showText(text: L10n.of(context).youHaveBeenBannedFromThisChat);
        return;
      }

      if (room.membership == Membership.leave) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(L10n.of(context).archivedRoom),
            content: Text(L10n.of(context).thisRoomHasBeenArchived),
            actions: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).close.toUpperCase(),
                    style: TextStyle(color: Colors.blueGrey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(L10n.of(context).delete.toUpperCase(),
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await archiveAction(context);
                  await Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(L10n.of(context).rejoin.toUpperCase(),
                    style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  await SimpleDialogs(context)
                      .tryRequestWithLoadingDialog(room.join());
                  await Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }

      if (room.membership == Membership.join) {
        if (Matrix.of(context).shareContent != null) {
          if (Matrix.of(context).shareContent['msgtype'] ==
              'chat.fluffy.shared_file') {
            await showDialog(
                context: context,
                builder: (context) => SendFileDialog(
                      file: Matrix.of(context).shareContent['file'],
                      room: room,
                    ));
          } else {
            unawaited(room.sendEvent(Matrix.of(context).shareContent));
          }
          Matrix.of(context).shareContent = null;
        }
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(room.id)),
          (r) => r.isFirst,
        );
      }
    }
  }

  Future<void> archiveAction(BuildContext context) async {
    {
      if ([Membership.leave, Membership.ban].contains(room.membership)) {
        final success = await SimpleDialogs(context)
            .tryRequestWithLoadingDialog(room.forget());
        if (success != false) {
          if (onForget != null) onForget();
        }
        return success;
      }
      final confirmed = await SimpleDialogs(context).askConfirmation();
      if (!confirmed) return;
      await SimpleDialogs(context).tryRequestWithLoadingDialog(room.leave());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = room.pushRuleState != PushRuleState.notify;
    return Center(
      child: Material(
        color: chatListItemColor(context, activeChat, selected),
        child: ListTile(
          onLongPress: onLongPress,
          leading: Avatar(room.avatar, room.displayname),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  room.getLocalizedDisplayname(L10n.of(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              room.isFavourite
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    )
                  : Container(),
              isMuted
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.notifications_off,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  room.timeCreated.localizedTimeShort(context),
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: room.membership == Membership.invite
                    ? Text(
                        L10n.of(context).youAreInvitedToThisChat,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        softWrap: false,
                      )
                    : Text(
                        room.lastEvent?.getLocalizedBody(
                              L10n.of(context),
                              withSenderNamePrefix: !room.isDirectChat ||
                                  room.lastEvent.senderId == room.client.userID,
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
              room.notificationCount > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 20,
                      decoration: BoxDecoration(
                        color: room.highlightCount > 0
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          room.notificationCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Text(' '),
            ],
          ),
          onTap: () => clickAction(context),
        ),
      ),
    );
  }
}
