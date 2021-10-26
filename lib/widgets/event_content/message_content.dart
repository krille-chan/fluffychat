import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/pages/key_verification_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/widgets/event_content/audio_player.dart';
import 'package:fluffychat/widgets/event_content/image_bubble.dart';
import '../../config/app_config.dart';
import '../../pages/video_viewer.dart';
import '../../utils/platform_infos.dart';
import '../../utils/url_launcher.dart';
import '../matrix.dart';
import 'html_message.dart';
import 'map_bubble.dart';
import 'message_download_content.dart';
import 'sticker.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageContent(this.event, {Key key, this.textColor}) : super(key: key);

  void _verifyOrRequestKey(BuildContext context) async {
    if (event.content['can_request_session'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        event.type == EventTypes.Encrypted
            ? L10n.of(context).needPantalaimonWarning
            : event.getLocalizedBody(
                MatrixLocals(L10n.of(context)),
              ),
      )));
      return;
    }
    final client = Matrix.of(context).client;
    if (client.isUnknownSession && client.encryption.crossSigning.enabled) {
      final req =
          await client.userDeviceKeys[client.userID].startVerification();
      req.onUpdate = () async {
        if (req.state == KeyVerificationState.done) {
          for (var i = 0; i < 12; i++) {
            if (await client.encryption.keyManager.isCached()) {
              break;
            }
            await Future.delayed(const Duration(seconds: 1));
          }
          final timeline = await event.room.getTimeline();
          timeline.requestKeys();
          timeline.cancelSubscriptions();
        }
      };
      await KeyVerificationDialog(request: req).show(context);
    } else {
      final success = await showFutureLoadingDialog(
        context: context,
        future: () => event.requestKey(),
      );
      if (success.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(L10n.of(context).requestToReadOlderMessages)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize =
        DefaultTextStyle.of(context).style.fontSize * AppConfig.fontSizeFactor;
    switch (event.type) {
      case EventTypes.Message:
      case EventTypes.Encrypted:
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
            if (event.showThumbnail) {
              return ImageBubble(
                event,
                width: 400,
                height: 300,
                fit: BoxFit.cover,
              );
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Sticker:
            if (event.showThumbnail) {
              return Sticker(event);
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Audio:
            if (PlatformInfos.isMobile) {
              return AudioPlayerWidget(
                event,
                color: textColor,
              );
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Video:
            if (event.showThumbnail &&
                (PlatformInfos.isMobile || PlatformInfos.isWeb)) {
              return InkWell(
                onTap: () => showDialog(
                  context: Matrix.of(context).navigatorContext,
                  useRootNavigator: false,
                  builder: (_) => VideoViewer(event),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ImageBubble(
                      event,
                      width: 400,
                      height: 300,
                      fit: BoxFit.cover,
                      tapToView: false,
                    ),
                    const Icon(Icons.play_circle_outline,
                        size: 200, color: Colors.grey),
                  ],
                ),
              );
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.File:
            return MessageDownloadContent(event, textColor);

          case MessageTypes.Text:
          case MessageTypes.Notice:
          case MessageTypes.Emote:
            if (AppConfig.renderHtml &&
                !event.redacted &&
                event.isRichMessage) {
              var html = event.formattedText;
              if (event.messageType == MessageTypes.Emote) {
                html = '* $html';
              }
              final bigEmotes = event.onlyEmotes &&
                  event.numberEmotes > 0 &&
                  event.numberEmotes <= 10;
              return HtmlMessage(
                html: html,
                defaultTextStyle: TextStyle(
                  color: textColor,
                  fontSize: bigEmotes ? fontSize * 3 : fontSize,
                ),
                linkStyle: TextStyle(
                  color: textColor.withAlpha(150),
                  fontSize: bigEmotes ? fontSize * 3 : fontSize,
                  decoration: TextDecoration.underline,
                ),
                room: event.room,
                emoteSize: bigEmotes ? fontSize * 3 : fontSize * 1.5,
              );
            }
            // else we fall through to the normal message rendering
            continue textmessage;
          case MessageTypes.BadEncrypted:
          case EventTypes.Encrypted:
            return ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).scaffoldBackgroundColor,
                onPrimary: Theme.of(context).textTheme.bodyText1.color,
              ),
              onPressed: () => _verifyOrRequestKey(context),
              icon: const Icon(Icons.lock_outline),
              label: Text(L10n.of(context).encrypted),
            );
          case MessageTypes.Location:
            final geoUri =
                Uri.tryParse(event.content.tryGet<String>('geo_uri'));
            if (geoUri != null &&
                geoUri.scheme == 'geo' &&
                geoUri.path != null) {
              final latlong = geoUri.path
                  .split(';')
                  .first
                  .split(',')
                  .map((s) => double.tryParse(s))
                  .toList();
              if (latlong.length == 2 &&
                  latlong.first != null &&
                  latlong.last != null) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MapBubble(
                      latitude: latlong.first,
                      longitude: latlong.last,
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      icon: Icon(Icons.location_on_outlined, color: textColor),
                      onPressed:
                          UrlLauncher(context, geoUri.toString()).launchUrl,
                      label: Text(
                        L10n.of(context).openInMaps,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                );
              }
            }
            continue textmessage;
          case MessageTypes.None:
          textmessage:
          default:
            if (event.content['msgtype'] == Matrix.callNamespace) {
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                  onPrimary: Theme.of(context).textTheme.bodyText1.color,
                ),
                onPressed: () => launch(event.body),
                icon: const Icon(Icons.phone_outlined, color: Colors.green),
                label: Text(L10n.of(context).videoCall),
              );
            }
            if (event.redacted) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever_outlined, color: textColor),
                  const SizedBox(width: 4),
                  Text(
                    event.getLocalizedBody(MatrixLocals(L10n.of(context)),
                        hideReply: true),
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 0.5,
                    ),
                  ),
                ],
              );
            }
            final bigEmotes = event.onlyEmotes &&
                event.numberEmotes > 0 &&
                event.numberEmotes <= 10;
            return LinkText(
              text: event.getLocalizedBody(MatrixLocals(L10n.of(context)),
                  hideReply: true),
              textStyle: TextStyle(
                color: textColor,
                fontSize: bigEmotes ? fontSize * 3 : fontSize,
                decoration: event.redacted ? TextDecoration.lineThrough : null,
              ),
              linkStyle: TextStyle(
                color: textColor.withAlpha(150),
                fontSize: bigEmotes ? fontSize * 3 : fontSize,
                decoration: TextDecoration.underline,
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
