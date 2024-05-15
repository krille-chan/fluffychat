import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_conversation_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_custom_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_text_adventure_zone.dart';
import 'package:flutter/material.dart';

import 'conversation_bot_discussion_zone.dart';

class ConversationBotModeDynamicZone extends StatelessWidget {
  final String? mode;

  const ConversationBotModeDynamicZone({
    super.key,
    this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final zoneMap = {
      'discussion': const ConversationBotDiscussionZone(),
      "custom": const ConversationBotCustomZone(),
      "conversation": const ConversationBotConversationZone(),
      "text_adventure": const ConversationBotTextAdventureZone(),
    };
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: zoneMap[mode ?? 'discussion'],
    );
  }
}
