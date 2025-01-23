import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics/enums/morph_categories_enum.dart';
import 'package:fluffychat/pangea/analytics/utils/get_grammar_copy.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';
import 'package:fluffychat/utils/color_value.dart';

class MorphologicalListItem extends StatelessWidget {
  final Function(String) onPressed;
  final String morphFeature;
  final String morphTag;
  final IconData icon;
  final String? svgLink;

  final bool isUnlocked;
  final bool isSelected;

  const MorphologicalListItem({
    required this.onPressed,
    required this.morphFeature,
    required this.morphTag,
    required this.icon,
    this.svgLink,
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
        icon: svgLink != null
            ? CustomizedSvg(
                svgUrl: svgLink!,
                colorReplacements:
                    Theme.of(context).brightness == Brightness.dark
                        ? {
                            "white":
                                Theme.of(context).cardColor.hexValue.toString(),
                            "black": "white",
                          }
                        : {},
                errorIcon: Icon(icon),
              )
            : Icon(icon),
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
