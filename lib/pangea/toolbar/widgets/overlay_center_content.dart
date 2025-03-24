import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/widgets/measure_render_box.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_message.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button_column.dart';

class OverlayCenterContent extends StatelessWidget {
  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;
  final PangeaMessageEvent? pangeaMessageEvent;

  final MessageOverlayController overlayController;
  final ChatController chatController;

  final Animation<Size>? sizeAnimation;
  final void Function(RenderBox)? onChangeMessageSize;
  final void Function(RenderBox)? onChangeContentSize;
  final void Function(RenderBox)? onChangeButtonsSize;

  final double messageHeight;
  final double messageWidth;
  final double toolbarMaxWidth;

  final bool showToolbarButtons;
  final bool hasReactions;
  final bool isTransitionAnimation;

  const OverlayCenterContent({
    required this.event,
    required this.messageHeight,
    required this.messageWidth,
    required this.toolbarMaxWidth,
    required this.overlayController,
    required this.chatController,
    required this.pangeaMessageEvent,
    required this.nextEvent,
    required this.prevEvent,
    required this.showToolbarButtons,
    required this.hasReactions,
    this.onChangeMessageSize,
    this.onChangeContentSize,
    this.onChangeButtonsSize,
    this.sizeAnimation,
    this.isTransitionAnimation = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: toolbarMaxWidth),
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
                    event,
                    pangeaMessageEvent: pangeaMessageEvent,
                    immersionMode: chatController.choreographer.immersionMode,
                    controller: chatController,
                    overlayController: overlayController,
                    nextEvent: nextEvent,
                    prevEvent: prevEvent,
                    timeline: chatController.timeline!,
                    sizeAnimation: sizeAnimation,
                    // there's a split seconds between when the transition animation starts and
                    // when the sizeAnimation is set when the original dimensions need to be enforced
                    messageWidth: sizeAnimation == null && isTransitionAnimation
                        ? messageWidth
                        : null,
                    messageHeight:
                        sizeAnimation == null && isTransitionAnimation
                            ? messageHeight
                            : null,
                    isTransitionAnimation: isTransitionAnimation,
                  ),
                ),
                if (hasReactions)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 20,
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
        if (!isTransitionAnimation)
          MeasureRenderBox(
            onChange: onChangeButtonsSize,
            child: ToolbarButtonRow(
              event: event,
              overlayController: overlayController,
              shouldShowToolbarButtons: showToolbarButtons,
            ),
          ),
      ],
    );
  }
}
