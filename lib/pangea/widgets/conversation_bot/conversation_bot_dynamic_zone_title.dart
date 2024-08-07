import 'package:flutter/material.dart';

class ConversationBotDynamicZoneTitle extends StatelessWidget {
  final String title;

  const ConversationBotDynamicZoneTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
