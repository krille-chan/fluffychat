import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final BotOptionsModel botOptions;
  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  final bool enabled;

  const ConversationBotModeDynamicZone({
    super.key,
    required this.botOptions,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final discussionChildren = [
      TextFormField(
        decoration: InputDecoration(
          hintText: L10n.of(context)!
              .conversationBotDiscussionZone_discussionTopicPlaceholder,
        ),
        controller: discussionTopicController,
        validator: (value) => enabled &&
                botOptions.mode == BotMode.discussion &&
                (value == null || value.isEmpty)
            ? L10n.of(context)!.enterDiscussionTopic
            : null,
        enabled: enabled,
        minLines: 1, // Minimum number of lines
        maxLines: null, // Allow the field to expand based on content
        keyboardType: TextInputType.multiline,
      ),
      const SizedBox(height: 12),
      TextFormField(
        decoration: InputDecoration(
          hintText: L10n.of(context)!
              .conversationBotDiscussionZone_discussionKeywordsPlaceholder,
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
        decoration: InputDecoration(
          hintText: L10n.of(context)!
              .conversationBotCustomZone_customSystemPromptPlaceholder,
        ),
        validator: (value) => enabled &&
                botOptions.mode == BotMode.custom &&
                (value == null || value.isEmpty)
            ? L10n.of(context)!.enterPrompt
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
        if (botOptions.mode == BotMode.discussion) ...discussionChildren,
        if (botOptions.mode == BotMode.custom) ...customChildren,
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)!
                .conversationBotCustomZone_customTriggerReactionEnabledLabel,
          ),
          enabled: false,
          value: botOptions.customTriggerReactionEnabled ?? true,
          onChanged: null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
