import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'matrix.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;
  final bool textOnly;

  const MessageContent(this.event, {this.textColor, this.textOnly = false});

  @override
  Widget build(BuildContext context) {
    final int maxLines = textOnly ? 1 : null;
    if (textOnly)
      return Text(
        event.getBody(),
        style: TextStyle(
          color: textColor,
          decoration: event.redacted ? TextDecoration.lineThrough : null,
        ),
        maxLines: maxLines,
      );
    switch (event.type) {
      case EventTypes.Audio:
      case EventTypes.Image:
      case EventTypes.File:
      case EventTypes.Video:
        return Container(
          width: 200,
          child: RaisedButton(
            color: Colors.blueGrey,
            child: Text(
              "Download ${event.getBody()}",
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
            ),
            onPressed: () => launch(
              MxContent(event.content["url"])
                  .getDownloadLink(Matrix.of(context).client),
            ),
          ),
        );
      case EventTypes.Text:
      case EventTypes.Reply:
      case EventTypes.Notice:
        return Text(
          event.getBody(),
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
      case EventTypes.Emote:
        return Text(
          "* " + event.getBody(),
          maxLines: maxLines,
          style: TextStyle(
            color: textColor,
            fontStyle: FontStyle.italic,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
      default:
        return Text(
          "${event.sender.calcDisplayname()} sent a ${event.typeKey} event",
          maxLines: maxLines,
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
    }
  }
}
