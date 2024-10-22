import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeSelect extends StatelessWidget {
  final String? initialMode;
  final void Function(String?) onChanged;
  final bool enabled;

  const ConversationBotModeSelect({
    super.key,
    this.initialMode,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> options = {
      BotMode.discussion:
          L10n.of(context)!.conversationBotModeSelectOption_discussion,
      BotMode.custom: L10n.of(context)!.conversationBotModeSelectOption_custom,
      // BotMode.textAdventure:
      //     L10n.of(context)!.conversationBotModeSelectOption_textAdventure,
      // BotMode.storyGame:
      //     L10n.of(context)!.conversationBotModeSelectOption_storyGame,
    };

    String? mode = initialMode;
    if (!options.containsKey(initialMode)) {
      mode = null;
    }

    return DropdownButtonFormField(
      // Initial Value
      hint: Text(
        options[mode ?? BotMode.discussion]!,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      // ),
      isExpanded: true,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),
      // Array list of items
      items: [
        for (final entry in options.entries)
          DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
