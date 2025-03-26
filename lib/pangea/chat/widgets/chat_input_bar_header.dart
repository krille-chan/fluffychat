import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/chat/widgets/chat_floating_action_button.dart';

class ChatInputBarHeader extends StatelessWidget {
  final ChatController controller;
  final double padding;

  const ChatInputBarHeader({
    required this.controller,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.selectMode) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        left: padding,
        right: padding,
      ),
      constraints: const BoxConstraints(
        maxWidth: FluffyThemes.columnWidth * 2.4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ChatFloatingActionButton(
            controller: controller,
          ),
        ],
      ),
    );
  }
}
