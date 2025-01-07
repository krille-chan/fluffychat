import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/utils/bot_style.dart';

class MessageDisplayCard extends StatelessWidget {
  final String displayText;

  const MessageDisplayCard({
    super.key,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Text(
        displayText,
        style: BotStyle.text(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
