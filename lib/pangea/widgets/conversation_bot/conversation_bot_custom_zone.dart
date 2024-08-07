import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_custom_system_prompt_input.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_dynamic_zone_label.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_dynamic_zone_title.dart';
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
        ConversationBotDynamicZoneTitle(
          title: L10n.of(context)!.conversationBotCustomZone_title,
        ),
        ConversationBotDynamicZoneLabel(
          label: L10n.of(context)!
              .conversationBotCustomZone_customSystemPromptLabel,
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
