import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:pedantic/pedantic.dart';

import '../avatar.dart';
import '../matrix.dart';

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;
  final Function onForget;

  const ChatListItem(this.room, {this.activeChat = false, this.onForget});

  void clickAction(BuildContext context) async {
    if (!activeChat) {
      if (room.membership == Membership.invite &&
          await Matrix.of(context).tryRequestWithLoadingDialog(room.join()) ==
              false) {
        return;
      }

      if (room.membership == Membership.ban) {
        Toast.show(I18n.of(context).youHaveBeenBannedFromThisChat, context,
            duration: 5);
        return;
      }

      if (room.membership == Membership.leave) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(I18n.of(context).archivedRoom),
            content: Text(I18n.of(context).thisRoomHasBeenArchived),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.of(context).close.toUpperCase(),
                    style: TextStyle(color: Colors.blueGrey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(I18n.of(context).delete.toUpperCase(),
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await Matrix.of(context)
                      .tryRequestWithLoadingDialog(room.forget());
                  await Navigator.of(context).pop();
                  if (this.onForget != null) this.onForget();
                },
              ),
              FlatButton(
                child: Text(I18n.of(context).rejoin.toUpperCase(),
                    style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  await Matrix.of(context)
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
          unawaited(room.sendEvent(Matrix.of(context).shareContent));
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activeChat ? Color(0xFFE8E8E8) : Colors.white,
      child: ListTile(
        leading: Avatar(room.avatar, room.displayname),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                room.getLocalizedDisplayname(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16),
            room.pushRuleState == PushRuleState.notify
                ? Container()
                : Icon(
                    Icons.notifications_off,
                    color: Colors.grey[400],
                    size: 16,
                  ),
            SizedBox(width: 4),
            Text(
              room.timeCreated.localizedTimeShort(context),
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 13,
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
                      I18n.of(context).youAreInvitedToThisChat,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Text(
                      room.lastEvent.getLocalizedBody(context,
                          withSenderNamePrefix: true, hideQuotes: true),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: room.lastEvent.redacted
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
                : Text(" "),
          ],
        ),
        onTap: () => clickAction(context),
      ),
    );
  }
}
