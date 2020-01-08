import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/message_content.dart';
import 'package:fluffychat/utils/chat_time.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/room_name_calculator.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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
        Toast.show("You have been banned from this chat", context, duration: 5);
        return;
      }

      if (room.membership == Membership.leave) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Archived Room"),
            content: Text("This room has been archived."),
            actions: <Widget>[
              FlatButton(
                child: Text("Close".toUpperCase(),
                    style: TextStyle(color: Colors.blueGrey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Forget".toUpperCase(),
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await Matrix.of(context)
                      .tryRequestWithLoadingDialog(room.forget());
                  await Navigator.of(context).pop();
                  if (this.onForget != null) this.onForget();
                },
              ),
              FlatButton(
                child: Text("Rejoin".toUpperCase(),
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
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, Chat(room.id)),
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
        leading: Avatar(room.avatar),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                RoomNameCalculator(room).name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16),
            Text(
              ChatTime(room.timeCreated).toEventTimeString(),
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
                      "You are invited to this chat",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : MessageContent(
                      room.lastEvent,
                      textOnly: true,
                    ),
            ),
            SizedBox(width: 8),
            room.pushRuleState == PushRuleState.notify
                ? Container()
                : Icon(
                    Icons.notifications_off,
                    color: Colors.grey,
                    size: 16,
                  ),
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
