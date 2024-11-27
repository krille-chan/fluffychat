import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MessageButtons extends StatelessWidget {
  final ChatController controller;
  final Event event;
  final PangeaMessageEvent pangeaMessageEvent;
  final Event? nextEvent;
  final Event? prevEvent;

  const MessageButtons({
    super.key,
    required this.controller,
    required this.event,
    required this.pangeaMessageEvent,
    this.nextEvent,
    this.prevEvent,
  });

  void showActivity(BuildContext context) {
    controller.showToolbar(
      event,
      pangeaMessageEvent: pangeaMessageEvent,
      mode: MessageMode.practiceActivity,
      nextEvent: nextEvent,
      prevEvent: prevEvent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          HoverIconButton(
            icon: MessageMode.practiceActivity.icon,
            onTap: () => showActivity(context),
            primaryColor: Theme.of(context).colorScheme.primary,
            tooltip: MessageMode.practiceActivity.tooltip(context),
          ),

          // Additional buttons can be added here in the future
        ],
      ),
    );
  }
}

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color primaryColor;
  final String tooltip;

  const HoverIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.primaryColor,
    required this.tooltip,
  });

  @override
  _HoverIconButtonState createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          setState(() => _isHovered = hovering);
        },
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? widget.primaryColor : null,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              width: 1,
              color: widget.primaryColor,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: Icon(
            widget.icon,
            size: 18,
            // when hovered, use themeData to get background color, otherwise use primary
            color: _isHovered
                ? Theme.of(context).scaffoldBackgroundColor
                : widget.primaryColor,
          ),
        ),
      ),
    );
  }
}
