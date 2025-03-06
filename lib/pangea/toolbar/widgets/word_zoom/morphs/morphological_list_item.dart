import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_categories_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';

class MorphologicalListItem extends StatelessWidget {
  final Function(String) onPressed;
  final String morphFeature;
  final String morphTag;

  final bool isUnlocked;
  final bool isSelected;

  const MorphologicalListItem({
    required this.onPressed,
    required this.morphFeature,
    required this.morphTag,
    this.isUnlocked = true,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: WordZoomActivityButton(
        icon: isUnlocked
            // if unlocked, we show the specific icon for the morphological feature/tag
            ? MorphIcon(morphFeature: morphFeature, morphTag: morphTag)
            // we show general feature icon if the morph is locked
            // : MorphIcon(morphFeature: morphFeature, morphTag: null),
            // or maybe we should the general grammar icon to show the
            // connection between these and the grammar icon in the progress header
            : const Icon(Symbols.toys_and_games),
        isSelected: isSelected,
        onPressed: () => onPressed(morphFeature),
        tooltip: isUnlocked
            ? getGrammarCopy(
                category: morphFeature,
                lemma: morphTag,
                context: context,
              )
            : getMorphologicalCategoryCopy(
                morphFeature,
                context,
              ),
        opacity: isSelected
            ? 1
            : !isUnlocked
                ? 0.2
                : 1,
      ),
    );
  }
}
