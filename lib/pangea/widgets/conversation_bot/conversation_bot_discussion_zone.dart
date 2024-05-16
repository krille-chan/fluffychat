import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotDiscussionZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel?)? onChanged;

  const ConversationBotDiscussionZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String discussionTopic = initialBotOptions.discussionTopic ?? "";
    String discussionKeywords = initialBotOptions.discussionKeywords ?? "";
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          L10n.of(context)!.conversationBotDiscussionZone_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: TextEditingController(text: discussionTopic),
            onChanged: (value) {
              discussionTopic = value;
            },
            decoration: InputDecoration(
              labelText: L10n.of(context)!
                  .conversationBotDiscussionZone_discussionTopicLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (discussionTopic != initialBotOptions.discussionTopic) {
                    initialBotOptions.discussionTopic = discussionTopic;
                    onChanged?.call(
                      initialBotOptions,
                    );
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: TextEditingController(text: discussionKeywords),
            onChanged: (value) {
              discussionKeywords = value;
            },
            decoration: InputDecoration(
              labelText: L10n.of(context)!
                  .conversationBotDiscussionZone_discussionKeywordsLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: L10n.of(context)!
                  .conversationBotDiscussionZone_discussionKeywordsHintText,
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (discussionTopic != initialBotOptions.discussionKeywords) {
                    initialBotOptions.discussionKeywords = discussionKeywords;
                    onChanged?.call(
                      initialBotOptions,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
