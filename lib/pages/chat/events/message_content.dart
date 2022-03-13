import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';

import 'package:fluffychat/pages/chat/events/video_player.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import '../../../utils/platform_infos.dart';
import '../../../utils/url_launcher.dart';
import '../../bootstrap/bootstrap_dialog.dart';
import 'audio_player.dart';
import 'html_message.dart';
import 'image_bubble.dart';
import 'map_bubble.dart';
import 'message_download_content.dart';
import 'sticker.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;
  final void Function(Event)? onInfoTab;

  const MessageContent(this.event,
      {this.onInfoTab, Key? key, required this.textColor})
      : super(key: key);

  void _verifyOrRequestKey(BuildContext context) async {
    if (event.content['can_request_session'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        event.type == EventTypes.Encrypted
            ? L10n.of(context)!.needPantalaimonWarning
            : event.getLocalizedBody(
                MatrixLocals(L10n.of(context)!),
              ),
      )));
      return;
    }
    final client = Matrix.of(context).client;
    if (client.isUnknownSession && client.encryption!.crossSigning.enabled) {
      await BootstrapDialog(
        client: Matrix.of(context).client,
      ).show(context);
      final timeline = await event.room.getTimeline();
      timeline.requestKeys();
      timeline.cancelSubscriptions();
    } else {
      final success = await showFutureLoadingDialog(
        context: context,
        future: () => event.requestKey(),
      );
      if (success.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(L10n.of(context)!.requestToReadOlderMessages)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;
    final buttonTextColor =
        event.senderId == Matrix.of(context).client.userID ? textColor : null;
    switch (event.type) {
      case EventTypes.Message:
      case EventTypes.Encrypted:
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
            return ImageBubble(
              event,
              width: 400,
              height: 300,
              fit: BoxFit.cover,
            );
          case MessageTypes.Sticker:
            return Sticker(event);
          case MessageTypes.Audio:
            if (PlatformInfos.isMobile || PlatformInfos.isDesktop) {
              return AudioPlayerWidget(
                event,
                color: textColor,
              );
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Video:
            if (PlatformInfos.isMobile || PlatformInfos.isWeb) {
              return EventVideoPlayer(event);
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
            return _ButtonContent(
              textColor: buttonTextColor,
              onPressed: () => _verifyOrRequestKey(context),
              icon: const Icon(Icons.lock_outline),
              label: L10n.of(context)!.encrypted,
            );
          case MessageTypes.Location:
            final geoUri =
                Uri.tryParse(event.content.tryGet<String>('geo_uri')!);
            if (geoUri != null && geoUri.scheme == 'geo') {
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
                      latitude: latlong.first!,
                      longitude: latlong.last!,
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      icon: Icon(Icons.location_on_outlined, color: textColor),
                      onPressed:
                          UrlLauncher(context, geoUri.toString()).launchUrl,
                      label: Text(
                        L10n.of(context)!.openInMaps,
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
            if (event.redacted) {
              return _ButtonContent(
                label: L10n.of(context)!
                    .redactedAnEvent(event.sender.calcDisplayname()),
                icon: const Icon(Icons.delete_outlined),
                textColor: buttonTextColor,
                onPressed: () => onInfoTab!(event),
              );
            }
            final bigEmotes = event.onlyEmotes &&
                event.numberEmotes > 0 &&
                event.numberEmotes <= 10;
            return LinkText(
              text: event.getLocalizedBody(MatrixLocals(L10n.of(context)!),
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
      case EventTypes.CallInvite:
        return _ButtonContent(
          label: L10n.of(context)!.startedACall(event.sender.calcDisplayname()),
          icon: const Icon(Icons.phone_outlined),
          textColor: buttonTextColor,
          onPressed: () => onInfoTab!(event),
        );
      default:
        return _ButtonContent(
          label: L10n.of(context)!
              .userSentUnknownEvent(event.sender.calcDisplayname(), event.type),
          icon: const Icon(Icons.info_outlined),
          textColor: buttonTextColor,
          onPressed: () => onInfoTab!(event),
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final Icon icon;
  final Color? textColor;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        primary: textColor,
        backgroundColor: Colors.white.withAlpha(64),
      ),
    );
  }
}
