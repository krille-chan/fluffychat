import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_emoji_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat/widgets/pangea_chat_input_row.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';

class ChatInputBar extends StatelessWidget {
  final ChatController controller;
  final double padding;

  const ChatInputBar({
    required this.controller,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.maxTimelineWidth,
          ),
          alignment: Alignment.center,
          child:
              controller.room.showActivityChatUI &&
                  controller.room.ownRole?.goal != null
              ? InlineTooltip(
                  message: controller.room.ownRole!.goal!,
                  isClosed: controller.room.hasDismissedGoalTooltip,
                  onClose: () async {
                    await controller.room.dismissGoalTooltip();
                  },
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: FluffyThemes.isColumnMode(context) ? 16.0 : 8.0,
                  ),
                )
              : SizedBox(),
        ),
        Container(
          margin: EdgeInsets.all(
            FluffyThemes.isColumnMode(context) ? 16.0 : 8.0,
          ),
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.maxTimelineWidth,
          ),
          alignment: Alignment.center,
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: controller.room.isAbandonedDMRoom == true
                ? _AbandonedDMContent(controller: controller)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReplyDisplay(controller),
                      PangeaChatInputRow(controller: controller),
                      ChatEmojiPicker(controller),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _AbandonedDMContent extends StatelessWidget {
  final ChatController controller;

  const _AbandonedDMContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16),
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          icon: const Icon(Icons.archive_outlined),
          onPressed: controller.leaveChat,
          label: Text(L10n.of(context).leave),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
          icon: const Icon(Icons.forum_outlined),
          onPressed: controller.recreateChat,
          label: Text(L10n.of(context).reopenChat),
        ),
      ],
    );
  }
}
