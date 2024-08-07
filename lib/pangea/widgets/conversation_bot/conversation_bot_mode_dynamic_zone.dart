import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_custom_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_text_adventure_zone.dart';
import 'package:flutter/material.dart';

import 'conversation_bot_discussion_zone.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotModeDynamicZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final zoneMap = {
      'discussion': ConversationBotDiscussionZone(
        initialBotOptions: initialBotOptions,
        onChanged: onChanged,
      ),
      "custom": ConversationBotCustomZone(
        initialBotOptions: initialBotOptions,
        onChanged: onChanged,
      ),
      // "conversation": const ConversationBotConversationZone(),
      "text_adventure": ConversationBotTextAdventureZone(
        initialBotOptions: initialBotOptions,
        onChanged: onChanged,
      ),
    };
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: zoneMap[initialBotOptions.mode],
    );
  }
}
