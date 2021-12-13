//@dart=2.12

import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'chat.dart';

class ChatEmojiPicker extends StatelessWidget {
  final ChatController controller;
  const ChatEmojiPicker(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: controller.showEmojiPicker
          ? MediaQuery.of(context).size.height / 2
          : 0,
      child: controller.showEmojiPicker
          ? EmojiPicker(
              onEmojiSelected: controller.onEmojiSelected,
              onBackspacePressed: controller.cancelEmojiPicker,
            )
          : null,
    );
  }
}
