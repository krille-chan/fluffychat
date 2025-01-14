import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics/enums/morph_categories_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';

class MorphologicalListItem extends StatelessWidget {
  final Function(String) onPressed;
  final String morphCategory;
  final IconData icon;

  final bool isUnlocked;
  final bool isSelected;

  const MorphologicalListItem({
    required this.onPressed,
    required this.morphCategory,
    required this.icon,
    this.isUnlocked = true,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WordZoomActivityButton(
      icon: Icon(icon),
      isSelected: isSelected,
      onPressed: () => onPressed(morphCategory),
      tooltip: getMorphologicalCategoryCopy(
        morphCategory,
        context,
      ),
      opacity: (isSelected || !isUnlocked) ? 1 : 0.5,
    );
  }
}
