import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

// @ggurdin be great to explain the need/function of a widget like this
class OverlayMessage extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final ChatController controller;
  final Event? nextEvent;
  final Event? prevEvent;
  final Timeline timeline;
  final bool immersionMode;
  final double messageWidth;
  final double messageHeight;

  const OverlayMessage(
    this.pangeaMessageEvent, {
    this.immersionMode = false,
    required this.overlayController,
    required this.controller,
    required this.timeline,
    required this.messageWidth,
    required this.messageHeight,
    this.nextEvent,
    this.prevEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool ownMessage =
        pangeaMessageEvent.event.senderId == Matrix.of(context).client.userID;

    final displayTime =
        pangeaMessageEvent.event.type == EventTypes.RoomCreate ||
            nextEvent == null ||
            !pangeaMessageEvent.event.originServerTs
                .sameEnvironment(nextEvent!.originServerTs);

    final nextEventSameSender = nextEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(nextEvent!.type) &&
        nextEvent!.senderId == pangeaMessageEvent.event.senderId &&
        !displayTime;

    final previousEventSameSender = prevEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(prevEvent!.type) &&
        prevEvent!.senderId == pangeaMessageEvent.event.senderId &&
        prevEvent!.originServerTs
            .sameEnvironment(pangeaMessageEvent.event.originServerTs);

    const hardCorner = Radius.circular(4);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      topRight: ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      bottomLeft:
          !ownMessage && previousEventSameSender ? hardCorner : roundedCorner,
      bottomRight:
          ownMessage && previousEventSameSender ? hardCorner : roundedCorner,
    );

    final displayEvent = pangeaMessageEvent.event.getDisplayEvent(timeline);
    // ignore: deprecated_member_use
    var color = theme.colorScheme.surfaceVariant;
    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : theme.colorScheme.primary;
    }

    final noBubble = {
          MessageTypes.Video,
          MessageTypes.Image,
          MessageTypes.Sticker,
        }.contains(pangeaMessageEvent.event.messageType) &&
        !pangeaMessageEvent.event.redacted;
    final noPadding = {
      MessageTypes.File,
      MessageTypes.Audio,
    }.contains(pangeaMessageEvent.event.messageType);

    return Material(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: SingleChildScrollView(
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
          width: messageWidth,
          child: MessageContent(
            pangeaMessageEvent.event,
            textColor: ownMessage
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            pangeaMessageEvent: pangeaMessageEvent,
            immersionMode: immersionMode,
            overlayController: overlayController,
            controller: controller,
            nextEvent: nextEvent,
            prevEvent: prevEvent,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
