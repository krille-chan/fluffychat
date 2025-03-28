import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/video_player.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/pangea_rich_text.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_token_text.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_toolbar_selection_area.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import '../../../config/app_config.dart';
import '../../../utils/platform_infos.dart';
import '../../../utils/url_launcher.dart';
import 'audio_player.dart';
import 'cute_events.dart';
import 'html_message.dart';
import 'image_bubble.dart';
import 'map_bubble.dart';
import 'message_download_content.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;
  final Color linkColor;
  final void Function(Event)? onInfoTab;
  final BorderRadius borderRadius;
  // #Pangea
  final PangeaMessageEvent? pangeaMessageEvent;
  //question: are there any performance benefits to using booleans
  //here rather than passing the choreographer? pangea rich text, a widget
  //further down in the chain is also using pangeaController so its not constant
  final bool immersionMode;
  final MessageOverlayController? overlayController;
  final ChatController controller;
  final Event? nextEvent;
  final Event? prevEvent;
  final bool isTransitionAnimation;
  // Pangea#
  final Timeline timeline;

  const MessageContent(
    this.event, {
    this.onInfoTab,
    super.key,
    required this.timeline,
    required this.textColor,
    // #Pangea
    this.pangeaMessageEvent,
    required this.immersionMode,
    this.overlayController,
    required this.controller,
    this.nextEvent,
    this.prevEvent,
    this.isTransitionAnimation = false,
    // Pangea#
    required this.linkColor,
    required this.borderRadius,
  });

  // #Pangea
  // void _verifyOrRequestKey(BuildContext context) async {
  //   final l10n = L10n.of(context);
  //   if (event.content['can_request_session'] != true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           event.calcLocalizedBodyFallback(MatrixLocals(l10n)),
  //         ),
  //       ),
  //     );
  //     return;
  //   }
  //   final client = Matrix.of(context).client;
  //   if (client.isUnknownSession && client.encryption!.crossSigning.enabled) {
  //     final success = await BootstrapDialog(
  //       client: Matrix.of(context).client,
  //     ).show(context);
  //     if (success != true) return;
  //   }
  //   event.requestKey();
  //   final sender = event.senderFromMemoryOrFallback;
  //   await showAdaptiveBottomSheet(
  //     context: context,
  //     builder: (context) => Scaffold(
  //       appBar: AppBar(
  //         leading: CloseButton(onPressed: Navigator.of(context).pop),
  //         title: Text(
  //           l10n.whyIsThisMessageEncrypted,
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //       ),
  //       body: SafeArea(
  //         child: ListView(
  //           padding: const EdgeInsets.all(16),
  //           children: [
  //             ListTile(
  //               contentPadding: EdgeInsets.zero,
  //               leading: Avatar(
  //                 mxContent: sender.avatarUrl,
  //                 name: sender.calcDisplayname(),
  //                 presenceUserId: sender.stateKey,
  //                 client: event.room.client,
  //               ),
  //               title: Text(sender.calcDisplayname()),
  //               subtitle: Text(event.originServerTs.localizedTime(context)),
  //               trailing: const Icon(Icons.lock_outlined),
  //             ),
  //             const Divider(),
  //             Text(
  //               event.calcLocalizedBodyFallback(
  //                 MatrixLocals(l10n),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void onClick(PangeaToken token) {
    token = pangeaMessageEvent?.messageDisplayRepresentation
            ?.getClosestNonPunctToken(token) ??
        token;

    if (overlayController != null) {
      overlayController?.onClickOverlayMessageToken(token);
      return;
    }

    controller.showToolbar(
      pangeaMessageEvent!.event,
      pangeaMessageEvent: pangeaMessageEvent,
      selectedToken: token,
    );
  }

  bool isSelected(PangeaToken token) {
    return overlayController!.isTokenSelected(token) ||
        overlayController!.isTokenHighlighted(token);
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;
    final buttonTextColor = textColor;
    switch (event.type) {
      // #Pangea
      // case EventTypes.Message:
      // Pangea#
      case EventTypes.Encrypted:
        // #Pangea
        return _ButtonContent(
          textColor: buttonTextColor,
          onPressed: () {},
          icon: '🔒',
          label: L10n.of(context).encrypted,
          fontSize: fontSize,
        );
      case EventTypes.Message:
      // Pangea#
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
          case MessageTypes.Sticker:
            if (event.redacted) continue textmessage;
            const maxSize = 256.0;
            final w = event.content
                .tryGetMap<String, Object?>('info')
                ?.tryGet<int>('w');
            final h = event.content
                .tryGetMap<String, Object?>('info')
                ?.tryGet<int>('h');
            var width = maxSize;
            var height = maxSize;
            var fit = event.messageType == MessageTypes.Sticker
                ? BoxFit.contain
                : BoxFit.cover;
            if (w != null && h != null) {
              fit = BoxFit.contain;
              if (w > h) {
                width = maxSize;
                height = max(32, maxSize * (h / w));
              } else {
                height = maxSize;
                width = max(32, maxSize * (w / h));
              }
            }
            return ImageBubble(
              event,
              width: width,
              height: height,
              fit: fit,
              borderRadius: borderRadius,
              timeline: timeline,
              textColor: textColor,
            );
          case CuteEventContent.eventType:
            return CuteContent(event);
          case MessageTypes.Audio:
            if (PlatformInfos.isMobile ||
                    PlatformInfos.isMacOS ||
                    PlatformInfos.isWeb
                // Disabled until https://github.com/bleonard252/just_audio_mpv/issues/3
                // is fixed
                //   || PlatformInfos.isLinux
                ) {
              return AudioPlayerWidget(
                event,
                color: textColor,
                linkColor: linkColor,
                fontSize: fontSize,
                // #Pangea
                isOverlay: overlayController != null,
                chatController: controller,
                // Pangea#
              );
            }
            return MessageDownloadContent(
              event,
              textColor: textColor,
              linkColor: linkColor,
            );
          case MessageTypes.Video:
            return EventVideoPlayer(event, textColor: textColor);
          case MessageTypes.File:
            return MessageDownloadContent(
              event,
              textColor: textColor,
              linkColor: linkColor,
            );

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
              return HtmlMessage(
                html: html,
                textColor: textColor,
                room: event.room,
                // #Pangea
                event: event,
                isOverlay: overlayController != null,
                controller: controller,
                pangeaMessageEvent: pangeaMessageEvent,
                nextEvent: nextEvent,
                prevEvent: prevEvent,
                isSelected: overlayController != null ? isSelected : null,
                onClick: event.isActivityMessage ? null : onClick,
                // Pangea#
                fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
                linkStyle: TextStyle(
                  color: linkColor,
                  fontSize:
                      AppConfig.fontSizeFactor * AppConfig.messageFontSize,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                ),
                onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
              );
            }
            // else we fall through to the normal message rendering
            continue textmessage;
          case MessageTypes.BadEncrypted:
          // #Pangea
          // case EventTypes.Encrypted:
          //   return _ButtonContent(
          //     textColor: buttonTextColor,
          //     onPressed: () => _verifyOrRequestKey(context),
          //     icon: '🔒',
          //     label: L10n.of(context).encrypted,
          //     fontSize: fontSize,
          //   );
          // Pangea#
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
            if (event.redacted) {
              return FutureBuilder<User?>(
                future: event.redactedBecause?.fetchSenderUser(),
                builder: (context, snapshot) {
                  final reason =
                      event.redactedBecause?.content.tryGet<String>('reason');
                  final redactedBy = snapshot.data?.calcDisplayname() ??
                      event.redactedBecause?.senderId.localpart ??
                      L10n.of(context).user;
                  return _ButtonContent(
                    label: reason == null
                        ? L10n.of(context).redactedBy(redactedBy)
                        : L10n.of(context).redactedByBecause(
                            redactedBy,
                            reason,
                          ),
                    icon: '🗑️',
                    textColor: buttonTextColor.withAlpha(128),
                    onPressed: () => onInfoTab!(event),
                    fontSize: fontSize,
                  );
                },
              );
            }
            // #Pangea
            // final bigEmotes = event.onlyEmotes &&
            //     event.numberEmotes > 0 &&
            //     event.numberEmotes <= 3;
            // Pangea#

            // #Pangea
            final messageTextStyle =
                AppConfig.messageTextStyle(event, textColor);

            if (immersionMode && pangeaMessageEvent != null) {
              return Flexible(
                child: PangeaRichText(
                  style: messageTextStyle,
                  pangeaMessageEvent: pangeaMessageEvent!,
                  immersionMode: immersionMode,
                  isOverlay: overlayController != null,
                  controller: controller,
                ),
              );
            }

            if (pangeaMessageEvent != null &&
                pangeaMessageEvent!.shouldShowToolbar) {
              return MessageTokenText(
                pangeaMessageEvent: pangeaMessageEvent!,
                tokens:
                    pangeaMessageEvent!.messageDisplayRepresentation?.tokens,
                style: messageTextStyle,
                onClick: onClick,
                isSelected: overlayController != null ? isSelected : null,
                messageMode: overlayController?.toolbarMode,
                isHighlighted: (PangeaToken token) =>
                    overlayController?.toolbarMode.associatedActivityType !=
                        null &&
                    overlayController?.messageAnalyticsEntry?.hasActivity(
                          overlayController!
                              .toolbarMode.associatedActivityType!,
                          token,
                        ) ==
                        true,
                overlayController: overlayController,
                isTransitionAnimation: isTransitionAnimation,
              );
            }

            // Pangea#

            return
                // #Pangea
                ToolbarSelectionArea(
              event: event,
              controller: controller,
              pangeaMessageEvent: pangeaMessageEvent,
              isOverlay: overlayController != null,
              nextEvent: nextEvent,
              prevEvent: prevEvent,
              child:
                  // Pangea#
                  Linkify(
                text: event.calcLocalizedBodyFallback(
                  MatrixLocals(L10n.of(context)),
                  hideReply: true,
                ),
                // #Pangea
                // style: TextStyle(
                //   color: textColor,
                //   fontSize: bigEmotes ? fontSize * 5 : fontSize,
                //   decoration: event.redacted ? TextDecoration.lineThrough : null,
                // ),
                style: messageTextStyle,
                // Pangea#
                options: const LinkifyOptions(humanize: false),
                linkStyle: TextStyle(
                  color: linkColor,
                  fontSize: fontSize,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                ),
                onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
              ),
            );
        }
      case EventTypes.CallInvite:
        return FutureBuilder<User?>(
          future: event.fetchSenderUser(),
          builder: (context, snapshot) {
            return _ButtonContent(
              label: L10n.of(context).startedACall(
                snapshot.data?.calcDisplayname() ??
                    event.senderFromMemoryOrFallback.calcDisplayname(),
              ),
              icon: '📞',
              textColor: buttonTextColor,
              onPressed: () => onInfoTab!(event),
              fontSize: fontSize,
            );
          },
        );
      default:
        return FutureBuilder<User?>(
          future: event.fetchSenderUser(),
          builder: (context, snapshot) {
            return _ButtonContent(
              label: L10n.of(context).userSentUnknownEvent(
                snapshot.data?.calcDisplayname() ??
                    event.senderFromMemoryOrFallback.calcDisplayname(),
                event.type,
              ),
              icon: 'ℹ️',
              textColor: buttonTextColor,
              onPressed: () => onInfoTab!(event),
              fontSize: fontSize,
            );
          },
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final String icon;
  final Color? textColor;
  final double fontSize;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.onPressed,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        '$icon  $label',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
