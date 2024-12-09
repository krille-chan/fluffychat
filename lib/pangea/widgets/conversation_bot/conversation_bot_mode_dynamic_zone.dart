import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final String? mode;
  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  final bool enabled;

  const ConversationBotModeDynamicZone({
    super.key,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
    this.enabled = true,
    this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final discussionChildren = [
      TextFormField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          hintText: L10n.of(context)
              .conversationBotDiscussionZone_discussionTopicPlaceholder,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        ),
        controller: discussionTopicController,
        validator: (value) => enabled &&
                mode == BotMode.discussion &&
                (value == null || value.isEmpty)
            ? L10n.of(context).enterDiscussionTopic
            : null,
        enabled: enabled,
        minLines: 1, // Minimum number of lines
        maxLines: null, // Allow the field to expand based on content
        keyboardType: TextInputType.multiline,
      ),
      const SizedBox(height: 12),
      TextFormField(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          hintText: L10n.of(context)
              .conversationBotDiscussionZone_discussionKeywordsPlaceholder,
          contentPadding: const EdgeInsets.symmetric(horizontal: 28.0),
        ),
        controller: discussionKeywordsController,
        enabled: enabled,
        minLines: 1, // Minimum number of lines
        maxLines: null, // Allow the field to expand based on content
        keyboardType: TextInputType.multiline,
      ),
    ];

    final customChildren = [
      TextFormField(
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
        enabled: enabled,
        minLines: 1, // Minimum number of lines
        maxLines: null, // Allow the field to expand based on content
        keyboardType: TextInputType.multiline,
      ),
    ];

    return Column(
      children: [
        if (mode == BotMode.discussion) ...discussionChildren,
        if (mode == BotMode.custom) ...customChildren,
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)
                .conversationBotCustomZone_customTriggerReactionEnabledLabel,
          ),
          enabled: false,
          value: true,
          onChanged: null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
