import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ToolbarSelectionArea extends StatelessWidget {
  final Event event;
  final ChatController controller;
  final PangeaMessageEvent? pangeaMessageEvent;
  final bool isOverlay;
  final Widget child;
  final Event? nextEvent;
  final Event? prevEvent;

  const ToolbarSelectionArea({
    required this.event,
    required this.controller,
    this.pangeaMessageEvent,
    this.isOverlay = false,
    required this.child,
    this.nextEvent,
    this.prevEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pangeaMessageEvent != null && !isOverlay) {
          controller.showToolbar(
            event,
            pangeaMessageEvent: pangeaMessageEvent,
            nextEvent: nextEvent,
            prevEvent: prevEvent,
          );
        }
      },
      onLongPress: () {
        if (pangeaMessageEvent != null && !isOverlay) {
          controller.showToolbar(
            event,
            pangeaMessageEvent: pangeaMessageEvent,
            nextEvent: nextEvent,
            prevEvent: prevEvent,
          );
        }
      },
      child: child,
    );
  }
}
