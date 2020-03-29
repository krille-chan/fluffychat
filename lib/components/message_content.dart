import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/audio_player.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluffychat/utils/matrix_file_extension.dart';

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
            final int size = 400;
            return Bubble(
              padding: BubbleEdges.all(0),
              radius: Radius.circular(10),
              elevation: 0,
              child: Container(
                height: size.toDouble(),
                width: size.toDouble(),
                child: FutureBuilder<MatrixFile>(
                  future: event.downloadAndDecryptAttachment(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () => snapshot.data.open(),
                        child: Image.memory(snapshot.data.bytes),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            );
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
                        if (kIsWeb) {
                          if (event.room.encrypted) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(I18n.of(context).notSupportedInWeb),
                              ),
                            );
                          }
                          await launch(
                            MxContent(event.content["url"])
                                .getDownloadLink(event.room.client),
                          );
                          return;
                        }
                        final MatrixFile matrixFile = await Matrix.of(context)
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
