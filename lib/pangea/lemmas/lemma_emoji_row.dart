import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/message_token_text/message_token_button.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';

class LemmaEmojiRow extends StatelessWidget {
  final ConstructIdentifier cId;
  final VoidCallback onTap;
  final bool isSelected;

  /// if a setState is defined then we're in a context where
  /// we allow removing an emoji
  /// later we'll probably want to allow this everywhere
  final void Function()? removeCallback;

  const LemmaEmojiRow({
    required this.cId,
    required this.onTap,
    required this.removeCallback,
    this.isSelected = false,
    super.key,
  });

  List<String> get emojis => cId.userSetEmoji;

  Future<void> onEmojiTap(String toRemove) async {
    await cId.setUserLemmaInfo(
      UserSetLemmaInfo(
        emojis: emojis.where((e) => e != toRemove).toList(),
      ),
    );
    removeCallback!();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < maxEmojisPerLemma; i++)
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            child: i < emojis.length
                ? GestureDetector(
                    onTap: removeCallback == null
                        ? null
                        : () => onEmojiTap(emojis[i]),
                    child: Text(
                      emojis[i],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : WordZoomActivityButton(
                    icon: Icon(
                      Icons.add_reaction_outlined,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    isSelected: isSelected,
                    onPressed: onTap,
                    opacity: isSelected ? 1 : 0.4,
                    tooltip: MessageMode.wordEmoji.title(context),
                  ),
          ),
      ],
    );
  }
}
