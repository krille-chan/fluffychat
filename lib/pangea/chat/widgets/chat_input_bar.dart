import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_emoji_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pangea/chat/widgets/pangea_chat_input_row.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_bar.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController controller;
  final double padding;

  const ChatInputBar({
    required this.controller,
    required this.padding,
    super.key,
  });

  @override
  State<ChatInputBar> createState() => ChatInputBarState();
}

class ChatInputBarState extends State<ChatInputBar> {
  void updateHeight() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    widget.controller.updateInputBarHeight(renderBox.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => updateHeight());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          padding: EdgeInsets.only(
            bottom: widget.padding,
            left: widget.padding,
            right: widget.padding,
          ),
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.columnWidth * 2.5,
          ),
          alignment: Alignment.center,
          child: Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
            child: Column(
              children: [
                ITBar(choreographer: widget.controller.choreographer),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    children: [
                      ReplyDisplay(widget.controller),
                      PangeaChatInputRow(
                        controller: widget.controller,
                      ),
                      ChatEmojiPicker(widget.controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
