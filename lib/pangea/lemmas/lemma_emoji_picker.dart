import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/lemma_emoji_choice_item.dart';

class LemmaEmojiPicker extends StatelessWidget {
  final List<String> emojis;
  final Function(String)? onSelect;

  final bool loading;
  final Function(String)? disabled;

  const LemmaEmojiPicker({
    super.key,
    required this.emojis,
    required this.onSelect,
    this.disabled,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      width: (40 * 5) + (4 * 5) + 16, // 5 items max + padding
      child: Row(
        spacing: 4.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: loading
            ? List.generate(5, (_) => const LemmaEmojiChoicePlaceholder())
            : emojis.take(5).map((emoji) {
                final isDisabled = disabled?.call(emoji) == true;
                return Opacity(
                  opacity: isDisabled ? 0.33 : 1,
                  child: LemmaEmojiChoiceItem(
                    content: emoji,
                    onTap: isDisabled || onSelect == null
                        ? null
                        : () => onSelect!(emoji),
                  ),
                );
              }).toList(),
      ),
    );
  }
}
