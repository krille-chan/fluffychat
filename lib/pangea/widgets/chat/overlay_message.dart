import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../config/app_config.dart';

class OverlayMessage extends StatelessWidget {
  final Event event;
  final bool selected;
  final Timeline timeline;
  // #Pangea
  // final LanguageModel? selectedDisplayLang;
  final bool immersionMode;
  // final bool definitions;
  final bool ownMessage;
  final ToolbarDisplayController toolbarController;
  final double? width;
  // Pangea#

  const OverlayMessage(
    this.event, {
    this.selected = false,
    required this.timeline,
    // #Pangea
    // required this.selectedDisplayLang,
    required this.immersionMode,
    // required this.definitions,
    required this.ownMessage,
    required this.toolbarController,
    this.width,
    // Pangea#
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (event.type != EventTypes.Message ||
        event.messageType == EventTypes.KeyVerificationRequest) {
      return const SizedBox.shrink();
    }

    var color = Theme.of(context).colorScheme.surfaceVariant;
    final textColor = ownMessage
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onBackground;

    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage
          ? const Radius.circular(4)
          : const Radius.circular(AppConfig.borderRadius),
      topRight: const Radius.circular(AppConfig.borderRadius),
      bottomLeft: const Radius.circular(AppConfig.borderRadius),
      bottomRight: ownMessage
          ? const Radius.circular(4)
          : const Radius.circular(AppConfig.borderRadius),
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
      color = Theme.of(context).colorScheme.primaryContainer;
    }

    // #Pangea
    final pangeaMessageEvent = PangeaMessageEvent(
      event: event,
      timeline: timeline,
      ownMessage: ownMessage,
    );
    // Pangea#

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
        ),
        child: MessageContent(
          event,
          textColor: textColor,
          borderRadius: borderRadius,
          selected: selected,
          pangeaMessageEvent: pangeaMessageEvent,
          // selectedDisplayLang: selectedDisplayLang,
          immersionMode: immersionMode,
          // definitions: definitions,
          toolbarController: toolbarController,
        ),
      ),
    );
  }
}
