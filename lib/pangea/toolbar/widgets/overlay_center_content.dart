import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_toolbar.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_message.dart';

class OverlayCenterContent extends StatelessWidget {
  final double messageHeight;
  final double messageWidth;
  final double maxWidth;

  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;

  final bool hasReactions;
  final bool shouldShowToolbarButtons;

  final PangeaMessageEvent? pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final ChatController chatController;

  const OverlayCenterContent({
    super.key,
    required this.messageHeight,
    required this.messageWidth,
    required this.maxWidth,
    required this.event,
    required this.overlayController,
    required this.chatController,
    required this.hasReactions,
    required this.shouldShowToolbarButtons,
    this.pangeaMessageEvent,
    this.nextEvent,
    this.prevEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: event.senderId == event.room.client.userID
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (pangeaMessageEvent != null &&
                pangeaMessageEvent!.shouldShowToolbar)
              ReadingAssistanceContentCard(
                pangeaMessageEvent: pangeaMessageEvent!,
                overlayController: overlayController,
              ),
            const SizedBox(height: AppConfig.toolbarSpacing),
            SizedBox(
              height: messageHeight,
              child: OverlayMessage(
                event,
                pangeaMessageEvent: pangeaMessageEvent,
                immersionMode: chatController.choreographer.immersionMode,
                controller: chatController,
                overlayController: overlayController,
                nextEvent: nextEvent,
                prevEvent: prevEvent,
                timeline: chatController.timeline!,
                messageWidth: messageWidth,
                messageHeight: messageHeight,
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
    );
  }
}
