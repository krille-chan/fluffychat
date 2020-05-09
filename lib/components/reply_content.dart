import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'html_message.dart';
import 'matrix.dart';

class ReplyContent extends StatelessWidget {
  final Event replyEvent;
  final bool lightText;

  const ReplyContent(this.replyEvent, {this.lightText = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget replyBody;
    if (
      replyEvent != null && Matrix.of(context).renderHtml &&
      [EventTypes.Message, EventTypes.Encrypted].contains(replyEvent.type) &&
      [MessageTypes.Text, MessageTypes.Notice, MessageTypes.Emote].contains(replyEvent.messageType) &&
      !replyEvent.redacted && replyEvent.content['format'] == 'org.matrix.custom.html' && replyEvent.content['formatted_body'] is String
    ) {
      String html = replyEvent.content['formatted_body'];
      if (replyEvent.messageType == MessageTypes.Emote) {
        html = "* $html";
      }
      replyBody = HtmlMessage(
        html: html,
        textColor: lightText
            ? Colors.white
            : Theme.of(context).textTheme.bodyText2.color,
        maxLines: 1,
      );
    } else {
      replyBody = Text(
        replyEvent?.getLocalizedBody(
              L10n.of(context),
              withSenderNamePrefix: false,
              hideReply: true,
            ) ??
            "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
            color: lightText
                ? Colors.white
                : Theme.of(context).textTheme.bodyText2.color),
      );
    }
    return Row(
      children: <Widget>[
        Container(
          width: 3,
          height: 36,
          color: lightText ? Colors.white : Theme.of(context).primaryColor,
        ),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                (replyEvent?.sender?.calcDisplayname() ?? "") + ":",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      lightText ? Colors.white : Theme.of(context).primaryColor,
                ),
              ),
              replyBody,
            ],
          ),
        ),
      ],
    );
  }
}
