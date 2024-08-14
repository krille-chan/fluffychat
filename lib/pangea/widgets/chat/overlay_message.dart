import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pangea/enum/use_type.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../config/app_config.dart';

class OverlayMessage extends StatelessWidget {
  final Event event;
  final bool selected;
  final Timeline timeline;
  // final LanguageModel? selectedDisplayLang;
  final bool immersionMode;
  // final bool definitions;
  final bool ownMessage;
  final ToolbarDisplayController toolbarController;
  final double? width;
  final bool showDown;

  const OverlayMessage(
    this.event, {
    this.selected = false,
    required this.timeline,
    required this.immersionMode,
    required this.ownMessage,
    required this.toolbarController,
    required this.showDown,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (event.type != EventTypes.Message ||
        event.messageType == EventTypes.KeyVerificationRequest) {
      return const SizedBox.shrink();
    }

    var color = Theme.of(context).colorScheme.surfaceContainer;
    final isLight = Theme.of(context).brightness == Brightness.light;
    var lightness = isLight ? .05 : .2;
    final textColor = ownMessage
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    const hardCorner = Radius.circular(4);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    final borderRadius = BorderRadius.only(
      topLeft: !showDown && !ownMessage ? hardCorner : roundedCorner,
      topRight: !showDown && ownMessage ? hardCorner : roundedCorner,
      bottomLeft: showDown && !ownMessage ? hardCorner : roundedCorner,
      bottomRight: showDown && ownMessage ? hardCorner : roundedCorner,
    );

    final noBubble = {
          MessageTypes.Video,
          MessageTypes.Image,
          MessageTypes.Sticker,
        }.contains(event.messageType) &&
        !event.redacted;
    final noPadding = {
      MessageTypes.File,
      MessageTypes.Audio,
    }.contains(event.messageType);

    if (ownMessage) {
      color = Theme.of(context).colorScheme.primary;
      lightness = isLight ? .15 : .85;
    }
    // Make overlay a little darker/lighter than the message
    color = Color.fromARGB(
      color.alpha,
      isLight || !ownMessage
          ? (color.red + lightness * (255 - color.red)).round()
          : (color.red * lightness).round(),
      isLight || !ownMessage
          ? (color.green + lightness * (255 - color.green)).round()
          : (color.green * lightness).round(),
      isLight || !ownMessage
          ? (color.blue + lightness * (255 - color.blue)).round()
          : (color.blue * lightness).round(),
    );

    final double maxHeight = (MediaQuery.of(context).size.height -
                (PlatformInfos.isWeb
                    ? 228
                    : PlatformInfos.isIOS
                        ? 258
                        : 198)) /
            2 -
        30;

    final pangeaMessageEvent = PangeaMessageEvent(
      event: event,
      timeline: timeline,
      ownMessage: ownMessage,
    );

    return Material(
      color: noBubble ? Colors.transparent : color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppConfig.borderRadius,
          ),
        ),
        padding: noBubble || noPadding
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
        constraints: BoxConstraints(
          maxWidth: width ?? FluffyThemes.columnWidth * 1.25,
          maxHeight: maxHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: MessageContent(
                  event.getDisplayEvent(timeline),
                  textColor: textColor,
                  borderRadius: borderRadius,
                  selected: selected,
                  pangeaMessageEvent: pangeaMessageEvent,
                  immersionMode: immersionMode,
                  toolbarController: toolbarController,
                  isOverlay: true,
                ),
              ),
              if (event.hasAggregatedEvents(
                    timeline,
                    RelationshipTypes.edit,
                  ) ||
                  (pangeaMessageEvent.showUseType))
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pangeaMessageEvent.showUseType) ...[
                        pangeaMessageEvent.msgUseType.iconView(
                          context,
                          textColor.withAlpha(164),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (event.hasAggregatedEvents(
                        timeline,
                        RelationshipTypes.edit,
                      )) ...[
                        Icon(
                          Icons.edit_outlined,
                          color: textColor.withAlpha(164),
                          size: 14,
                        ),
                        Text(
                          ' - ${event.getDisplayEvent(timeline).originServerTs.localizedTimeShort(context)}',
                          style: TextStyle(
                            color: textColor.withAlpha(164),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
