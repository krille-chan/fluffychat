import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/measure_render_box.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_message.dart';

class OverlayCenterContent extends StatelessWidget {
  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;

  final MessageOverlayController overlayController;
  final ChatController chatController;

  final Animation<Size>? sizeAnimation;
  final void Function(RenderBox)? onChangeMessageSize;

  final double? messageHeight;
  final double? messageWidth;

  final bool hasReactions;

  final bool isTransitionAnimation;
  final ReadingAssistanceMode? readingAssistanceMode;

  final LabeledGlobalKey? overlayKey;

  const OverlayCenterContent({
    required this.event,
    this.messageHeight,
    this.messageWidth,
    required this.overlayController,
    required this.chatController,
    required this.nextEvent,
    required this.prevEvent,
    required this.hasReactions,
    this.onChangeMessageSize,
    this.sizeAnimation,
    this.isTransitionAnimation = false,
    this.readingAssistanceMode,
    this.overlayKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ownMessage = event.senderId == event.room.client.userID;
    return IgnorePointer(
      ignoring: !isTransitionAnimation &&
          readingAssistanceMode != ReadingAssistanceMode.practiceMode,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.maxTimelineWidth,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: event.senderId == event.room.client.userID
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              MeasureRenderBox(
                onChange: onChangeMessageSize,
                child: OverlayMessage(
                  key: overlayKey,
                  event,
                  immersionMode: chatController.choreographer.immersionMode,
                  controller: chatController,
                  overlayController: overlayController,
                  nextEvent: nextEvent,
                  previousEvent: prevEvent,
                  timeline: chatController.timeline!,
                  sizeAnimation: sizeAnimation,
                  // there's a split seconds between when the transition animation starts and
                  // when the sizeAnimation is set when the original dimensions need to be enforced
                  messageWidth: messageWidth,
                  messageHeight: messageHeight,
                  isTransitionAnimation: isTransitionAnimation,
                  readingAssistanceMode: readingAssistanceMode,
                ),
              ),
              if (hasReactions)
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  curve: FluffyThemes.animationCurve,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      left: 4.0,
                      right: ownMessage ? 0 : 12.0,
                    ),
                    child: MessageReactions(
                      event,
                      chatController.timeline!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
