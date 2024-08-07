import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_discussion_keywords_input.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_discussion_topic_input.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_dynamic_zone_label.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_dynamic_zone_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotDiscussionZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotDiscussionZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConversationBotDynamicZoneTitle(
          title: L10n.of(context)!.conversationBotDiscussionZone_title,
        ),
        ConversationBotDynamicZoneLabel(
          label: L10n.of(context)!
              .conversationBotDiscussionZone_discussionTopicLabel,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotDiscussionTopicInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
        ConversationBotDynamicZoneLabel(
          label: L10n.of(context)!
              .conversationBotDiscussionZone_discussionKeywordsLabel,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotDiscussionKeywordsInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionTriggerReactionEnabledLabel,
          ),
          enabled: false,
          value: initialBotOptions.discussionTriggerReactionEnabled ?? true,
          onChanged: (value) {
            initialBotOptions.discussionTriggerReactionEnabled = value ?? true;
            initialBotOptions.discussionTriggerReactionKey =
                "⏩"; // hard code this for now
            onChanged.call(initialBotOptions);
          },
          // make this input disabled always
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
