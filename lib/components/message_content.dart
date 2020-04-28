import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/audio_player.dart';
import 'package:fluffychat/components/image_bubble.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluffychat/utils/matrix_file_extension.dart';

import 'dialogs/simple_dialogs.dart';
import 'matrix.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageContent(this.event, {this.textColor});

  @override
  Widget build(BuildContext context) {
    switch (event.type) {
      case EventTypes.Message:
      case EventTypes.Encrypted:
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
          case MessageTypes.Sticker:
            return ImageBubble(event);
          case MessageTypes.Audio:
            return AudioPlayer(
              event,
              color: textColor,
            );
          case MessageTypes.Video:
          case MessageTypes.File:
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.blueGrey,
                      child: Text(
                        I18n.of(context).downloadFile,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        final MatrixFile matrixFile =
                            await SimpleDialogs(context)
                                .tryRequestWithLoadingDialog(
                          event.downloadAndDecryptAttachment(),
                        );
                        matrixFile.open();
                      }),
                  Text(
                    "- " +
                        (event.content.containsKey("filename")
                            ? event.content["filename"]
                            : event.body),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (event.sizeString != null)
                    Text(
                      "- " + event.sizeString,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            );
          case MessageTypes.BadEncrypted:
          case MessageTypes.Text:
          case MessageTypes.Reply:
          case MessageTypes.Location:
          case MessageTypes.None:
          case MessageTypes.Notice:
          case MessageTypes.Emote:
          default:
            if (event.content['msgtype'] == Matrix.callNamespace) {
              return RaisedButton(
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.phone),
                    Text(I18n.of(context).videoCall),
                  ],
                ),
                onPressed: () => launch(event.body),
              );
            }
            return LinkText(
              text: event.getLocalizedBody(context, hideReply: true),
              textStyle: TextStyle(
                color: textColor,
                decoration: event.redacted ? TextDecoration.lineThrough : null,
              ),
            );
        }
        break;
      default:
        return Text(
          I18n.of(context).userSentUnknownEvent(
              event.sender.calcDisplayname(), event.typeKey),
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
    }
  }
}
