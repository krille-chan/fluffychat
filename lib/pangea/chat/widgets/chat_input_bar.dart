import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_emoji_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_role_tooltip.dart';
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
  Timer? _debounceTimer;

  void _updateHeight() {
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;
      widget.controller.updateInputBarHeight(renderBox.size.height);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: FluffyThemes.maxTimelineWidth,
              ),
              child: ActivityRoleTooltip(
                choreographer: widget.controller.choreographer,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: widget.padding,
                left: widget.padding,
                right: widget.padding,
              ),
              constraints: const BoxConstraints(
                maxWidth: FluffyThemes.maxTimelineWidth,
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
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                      child: Column(
                        children: [
                          if (!widget.controller.obscureText)
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
          ],
        ),
      ),
    );
  }
}
