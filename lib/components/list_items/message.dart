import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/redact_message_dialog.dart';
import 'package:fluffychat/components/message_content.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/views/content_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../avatar.dart';
import '../matrix.dart';
import 'state_message.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event nextEvent;

  const Message(this.event, {this.nextEvent});

  @override
  Widget build(BuildContext context) {
    if (![EventTypes.Message, EventTypes.Sticker].contains(event.type)) {
      return StateMessage(event);
    }

    Client client = Matrix.of(context).client;
    final bool ownMessage = event.senderId == client.userID;
    Alignment alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;
    Color color = Theme.of(context).secondaryHeaderColor;
    final bool sameSender = nextEvent != null &&
            [EventTypes.Message, EventTypes.Sticker].contains(nextEvent.type)
        ? nextEvent.sender.id == event.sender.id
        : false;
    BubbleNip nip = sameSender
        ? BubbleNip.no
        : ownMessage ? BubbleNip.rightBottom : BubbleNip.leftBottom;
    final Color textColor = ownMessage ? Colors.white : Colors.black;
    MainAxisAlignment rowMainAxisAlignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    if (ownMessage) {
      color = event.status == -1
          ? Colors.redAccent
          : Theme.of(context).primaryColor;
    }
    List<PopupMenuEntry<String>> popupMenuList = [];
    if (event.canRedact && !event.redacted && event.status > 1) {
      popupMenuList.add(
        PopupMenuItem<String>(
          value: "remove",
          child: Text(I18n.of(context).removeMessage),
        ),
      );
    }

    if (!event.redacted &&
        [
          MessageTypes.Text,
          MessageTypes.Reply,
          MessageTypes.Location,
          MessageTypes.Notice,
          MessageTypes.Emote,
          MessageTypes.None,
        ].contains(event.messageType) &&
        event.body.isNotEmpty) {
      popupMenuList.add(
        const PopupMenuItem<String>(
          value: "copy",
          child: Text('Copy'),
        ),
      );
    }

    if (!event.redacted) {
      popupMenuList.add(
        PopupMenuItem<String>(
          value: "forward",
          child: Text(I18n.of(context).forward),
        ),
      );
    }

    if (ownMessage && event.status == -1) {
      popupMenuList.add(
        PopupMenuItem<String>(
          value: "resend",
          child: Text(I18n.of(context).tryToSendAgain),
        ),
      );
      popupMenuList.add(
        PopupMenuItem<String>(
          value: "delete",
          child: Text(I18n.of(context).deleteMessage),
        ),
      );
    }

    List<Widget> rowChildren = [
      Expanded(
        child: PopupMenuButton(
          tooltip: I18n.of(context).tapToShowMenu,
          onSelected: (String choice) async {
            switch (choice) {
              case "remove":
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => RedactMessageDialog(event),
                );
                break;
              case "resend":
                await event.sendAgain();
                break;
              case "delete":
                await event.remove();
                break;
              case "copy":
                await Clipboard.setData(ClipboardData(text: event.body));
                break;
              case "forward":
                Matrix.of(context).shareContent = event.content;
                Navigator.of(context).popUntil((r) => r.isFirst);
                break;
            }
          },
          itemBuilder: (BuildContext context) => popupMenuList,
          child: Opacity(
            opacity: event.status == 0 ? 0.5 : 1,
            child: Bubble(
              elevation: 0,
              alignment: alignment,
              margin: BubbleEdges.symmetric(horizontal: 4),
              color: color,
              nip: nip,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        ownMessage
                            ? I18n.of(context).you
                            : event.sender.calcDisplayname(),
                        style: TextStyle(
                          color: ownMessage
                              ? textColor
                              : event.sender.calcDisplayname().color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        event.time.localizedTime(context),
                        style: TextStyle(
                          color: textColor.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                  MessageContent(
                    event,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
    final Widget avatarOrSizedBox = sameSender
        ? SizedBox(width: 40)
        : Avatar(
            event.sender.avatarUrl,
            event.sender.calcDisplayname(),
            onTap: () => Navigator.of(context).push(
              AppRoute.defaultRoute(
                context,
                ContentWebView(event.sender.avatarUrl),
              ),
            ),
          );
    if (ownMessage) {
      rowChildren.add(avatarOrSizedBox);
    } else {
      rowChildren.insert(0, avatarOrSizedBox);
    }

    return Padding(
      padding: EdgeInsets.only(
          left: 8.0, right: 8.0, bottom: sameSender ? 4.0 : 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: rowMainAxisAlignment,
        children: rowChildren,
      ),
    );
  }
}
