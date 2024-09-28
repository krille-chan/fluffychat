import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_custom_zone.dart';
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
      BotMode.discussion: ConversationBotDiscussionZone(
        initialBotOptions: initialBotOptions,
        onChanged: onChanged,
      ),
      BotMode.custom: ConversationBotCustomZone(
        initialBotOptions: initialBotOptions,
        onChanged: onChanged,
      ),
    };
    if (!zoneMap.containsKey(initialBotOptions.mode)) {
      return Container();
    }
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
