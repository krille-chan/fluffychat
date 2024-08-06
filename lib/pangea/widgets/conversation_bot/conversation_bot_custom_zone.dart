import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_custom_system_prompt_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotCustomZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotCustomZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          L10n.of(context)!.conversationBotCustomZone_title,
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(
              L10n.of(context)!
                  .conversationBotCustomZone_customSystemPromptLabel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotCustomSystemPromptInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)!
                .conversationBotCustomZone_customTriggerReactionEnabledLabel,
          ),
          enabled: false,
          value: initialBotOptions.customTriggerReactionEnabled ?? true,
          onChanged: (value) {
            initialBotOptions.customTriggerReactionEnabled = value ?? true;
            initialBotOptions.customTriggerReactionKey =
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
