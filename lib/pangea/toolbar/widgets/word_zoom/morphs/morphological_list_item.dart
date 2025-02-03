import 'package:flutter/material.dart';

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
        icon: MorphIcon(morphFeature: morphFeature, morphTag: morphTag),
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
        opacity: (isSelected || !isUnlocked) ? 1 : 0.5,
      ),
    );
  }
}
