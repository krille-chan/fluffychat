import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_text_adventure_game_master_instruction_input.dart';

// TODO check how this looks
class ConversationBotTextAdventureZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents

  final void Function(BotOptionsModel) onChanged;
  const ConversationBotTextAdventureZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotGameMasterInstructionsInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
