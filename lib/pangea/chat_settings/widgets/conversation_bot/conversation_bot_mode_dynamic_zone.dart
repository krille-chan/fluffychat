import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/conversation_bot/conversation_bot_no_permission_dialog.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final String? mode;
  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  final bool enabled;
  final bool hasPermission;

  const ConversationBotModeDynamicZone({
    super.key,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
    required this.hasPermission,
    this.enabled = true,
    this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final discussionChildren = [
      InkWell(
        onTap: hasPermission ? null : () => showNoPermissionDialog(context),
        child: TextFormField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: L10n.of(context)
                .conversationBotDiscussionZone_discussionTopicPlaceholder,
          ),
          controller: discussionTopicController,
          validator: (value) => enabled &&
                  mode == BotMode.discussion &&
                  (value == null || value.isEmpty)
              ? L10n.of(context).enterDiscussionTopic
              : null,
          enabled: hasPermission && enabled,
          minLines: 1, // Minimum number of lines
          maxLines: null, // Allow the field to expand based on content
          keyboardType: TextInputType.multiline,
        ),
      ),
      const SizedBox(height: 12),
      InkWell(
        onTap: hasPermission ? null : () => showNoPermissionDialog(context),
        child: TextFormField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: L10n.of(context)
                .conversationBotDiscussionZone_discussionKeywordsPlaceholder,
          ),
          controller: discussionKeywordsController,
          enabled: hasPermission && enabled,
          minLines: 1, // Minimum number of lines
          maxLines: null, // Allow the field to expand based on content
          keyboardType: TextInputType.multiline,
        ),
      ),
    ];

    final customChildren = [
      InkWell(
        onTap: hasPermission ? null : () => showNoPermissionDialog(context),
        child: TextFormField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: L10n.of(context)
                .conversationBotCustomZone_customSystemPromptPlaceholder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 28.0),
          ),
          validator: (value) => enabled &&
                  mode == BotMode.custom &&
                  (value == null || value.isEmpty)
              ? L10n.of(context).enterPrompt
              : null,
          controller: customSystemPromptController,
          enabled: hasPermission && enabled,
          minLines: 1, // Minimum number of lines
          maxLines: null, // Allow the field to expand based on content
          keyboardType: TextInputType.multiline,
        ),
      ),
    ];

    return Column(
      children: [
        if (mode == BotMode.discussion) ...discussionChildren,
        if (mode == BotMode.custom) ...customChildren,
        const SizedBox(height: 12),
      ],
    );
  }
}
