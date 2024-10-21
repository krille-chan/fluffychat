import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  final GlobalKey<FormState> formKey;

  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  const ConversationBotModeDynamicZone({
    super.key,
    required this.initialBotOptions,
    required this.formKey,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
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
      ),
      const SizedBox(height: 12),
      TextFormField(
        decoration: InputDecoration(
          hintText: L10n.of(context)!
              .conversationBotDiscussionZone_discussionKeywordsPlaceholder,
        ),
        controller: discussionKeywordsController,
      ),
    ];

    final customChildren = [
      TextFormField(
        decoration: InputDecoration(
          hintText: L10n.of(context)!
              .conversationBotCustomZone_customSystemPromptPlaceholder,
        ),
        validator: (value) => value == null || value.isEmpty
            ? L10n.of(context)!.enterPrompt
            : null,
        controller: customSystemPromptController,
      ),
    ];

    return Column(
      children: [
        if (initialBotOptions.mode == BotMode.discussion) ...discussionChildren,
        if (initialBotOptions.mode == BotMode.custom) ...customChildren,
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)!
                .conversationBotCustomZone_customTriggerReactionEnabledLabel,
          ),
          enabled: false,
          value: initialBotOptions.customTriggerReactionEnabled ?? true,
          onChanged: null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
