import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeSelect extends StatelessWidget {
  final String? initialMode;
  final void Function(String?) onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  const ConversationBotModeSelect({
    super.key,
    this.initialMode,
    required this.onChanged,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> options = {
      BotMode.discussion:
          L10n.of(context).conversationBotModeSelectOption_discussion,
      BotMode.custom: L10n.of(context).conversationBotModeSelectOption_custom,
      // BotMode.textAdventure:
      //     L10n.of(context).conversationBotModeSelectOption_textAdventure,
      // BotMode.storyGame:
      //     L10n.of(context).conversationBotModeSelectOption_storyGame,
    };

    return DropdownButtonFormField2(
      hint: Text(L10n.of(context).selectBotChatMode),
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
      validator: validator,
      value: initialMode,
    );
  }
}
