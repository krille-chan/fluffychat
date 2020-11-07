import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/audio_player.dart';
import 'package:fluffychat/components/image_bubble.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix_link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/url_launcher.dart';
import '../config/app_config.dart';
import 'html_message.dart';
import 'matrix.dart';
import 'message_download_content.dart';

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
            if (event.showThumbnail) {
              return ImageBubble(event);
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Audio:
            return AudioPlayer(
              event,
              color: textColor,
            );
          case MessageTypes.Video:
          case MessageTypes.File:
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Text:
          case MessageTypes.Notice:
          case MessageTypes.Emote:
            if (AppConfig.renderHtml &&
                !event.redacted &&
                event.isRichMessage) {
              String html = event.content['formatted_body'];
              if (event.messageType == MessageTypes.Emote) {
                html = '* $html';
              }
              final bigEmotes = event.onlyEmotes &&
                  event.numberEmotes > 0 &&
                  event.numberEmotes <= 10;
              final fontSize = DefaultTextStyle.of(context).style.fontSize;
              return HtmlMessage(
                html: html,
                defaultTextStyle: TextStyle(
                  color: textColor,
                  fontSize: bigEmotes ? fontSize * 3 : fontSize,
                ),
                room: event.room,
                emoteSize: bigEmotes ? fontSize * 3 : fontSize * 1.5,
              );
            }
            // else we fall through to the normal message rendering
            continue textmessage;
          case MessageTypes.BadEncrypted:
          case MessageTypes.Location:
          case MessageTypes.None:
          textmessage:
          default:
            if (event.content['msgtype'] == Matrix.callNamespace) {
              return RaisedButton(
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.phone),
                    Text(L10n.of(context).videoCall),
                  ],
                ),
                onPressed: () => launch(event.body),
              );
            }
            final bigEmotes = event.onlyEmotes &&
                event.numberEmotes > 0 &&
                event.numberEmotes <= 10;
            final fontSize = DefaultTextStyle.of(context).style.fontSize;
            return LinkText(
              text: event.getLocalizedBody(MatrixLocals(L10n.of(context)),
                  hideReply: true),
              textStyle: TextStyle(
                color: textColor,
                fontSize: bigEmotes ? fontSize * 3 : fontSize,
                decoration: event.redacted ? TextDecoration.lineThrough : null,
              ),
              onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
            );
        }
        break;
      default:
        return Text(
          L10n.of(context)
              .userSentUnknownEvent(event.sender.calcDisplayname(), event.type),
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
    }
    return Container(); // else flutter analyze complains
  }
}
