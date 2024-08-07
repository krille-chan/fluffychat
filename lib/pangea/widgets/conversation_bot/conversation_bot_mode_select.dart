import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotModeSelect extends StatelessWidget {
  final String? initialMode;
  final void Function(String?)? onChanged;

  const ConversationBotModeSelect({
    super.key,
    this.initialMode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> options = {
      "discussion":
          L10n.of(context)!.conversationBotModeSelectOption_discussion,
      "custom": L10n.of(context)!.conversationBotModeSelectOption_custom,
      // "conversation":
      //     L10n.of(context)!.conversationBotModeSelectOption_conversation,
      "text_adventure":
          L10n.of(context)!.conversationBotModeSelectOption_textAdventure,
    };

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: DropdownButton(
          // Initial Value
          hint: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              options[initialMode ?? "discussion"]!,
              style: const TextStyle().copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 14,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
          isExpanded: true,
          underline: Container(),
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          // Array list of items
          items: [
            for (final entry in options.entries)
              DropdownMenuItem(
                value: entry.key,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    entry.value,
                    style: const TextStyle().copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
