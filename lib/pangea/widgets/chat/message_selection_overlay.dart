import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_footer.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_header.dart';
import 'package:flutter/material.dart';

class MessageSelectionOverlay extends StatelessWidget {
  final ChatController controller;
  final Function closeToolbar;
  final Widget toolbar;
  final Widget overlayMessage;
  final bool ownMessage;

  const MessageSelectionOverlay({
    required this.controller,
    required this.closeToolbar,
    required this.toolbar,
    required this.overlayMessage,
    required this.ownMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment:
          ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        OverlayHeader(
          controller: controller,
          closeToolbar: closeToolbar,
        ),
        const SizedBox(
          height: 7,
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              toolbar,
              const SizedBox(height: 9),
              overlayMessage,
            ],
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        OverlayFooter(controller: controller),
      ],
    );
  }
}
