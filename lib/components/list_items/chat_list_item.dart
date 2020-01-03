import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/message_content.dart';
import 'package:fluffychat/utils/chat_time.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;

  const ChatListItem(this.room, {this.activeChat = false});

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
                room.displayname,
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
            Expanded(child: MessageContent(room.lastEvent, textOnly: true)),
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
        onTap: () {
          if (activeChat) {
            Navigator.pushReplacement(
              context,
              AppRoute.defaultRoute(context, Chat(room.id)),
            );
          } else {
            Navigator.push(
              context,
              AppRoute.defaultRoute(context, Chat(room.id)),
            );
          }
        },
        onLongPress: () {},
        /*trailing: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(ChatTime(room.timeCreated).toEventTimeString()),
              room.notificationCount > 0
                  ? Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(top: 3),
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
        ),*/
      ),
    );
  }
}
