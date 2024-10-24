import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:flutter/material.dart';

class MessageDisplayCard extends StatelessWidget {
  final PangeaMessageEvent messageEvent;
  final String? displayText;

  const MessageDisplayCard({
    super.key,
    required this.messageEvent,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    // If no display text is provided, show a message indicating no content
    if (displayText == null || displayText!.isEmpty) {
      return const Center(
        child: Text(
          'No content available.',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              children: [
                // Display the provided text
                Text(
                  displayText!,
                  style: BotStyle.text(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
