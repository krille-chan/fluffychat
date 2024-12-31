import 'package:fluffychat/pangea/constants/morph_categories_and_labels.dart';
import 'package:fluffychat/pangea/enum/analytics/morph_categories_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/word_zoom_activity_button.dart';
import 'package:flutter/material.dart';

class ActivityMorph {
  final String morphFeature;
  final String morphTag;
  bool revealed;

  ActivityMorph({
    required this.morphFeature,
    required this.morphTag,
    required this.revealed,
  });
}

class MorphologicalListWidget extends StatelessWidget {
  final PangeaToken token;
  final String? selectedMorphFeature;
  final Function(String?) setMorphFeature;

  const MorphologicalListWidget({
    super.key,
    required this.selectedMorphFeature,
    required this.token,
    required this.setMorphFeature,
  });

  List<ActivityMorph> get _visibleMorphs {
    final activityMorphs = token.morph.entries.map((entry) {
      return ActivityMorph(
        morphFeature: entry.key,
        morphTag: entry.value,
        revealed: !token.shouldDoMorphActivity(entry.key),
      );
    }).toList();

    activityMorphs.sort((a, b) {
      if (a.morphFeature.toLowerCase() == "pos") {
        return -1;
      } else if (b.morphFeature.toLowerCase() == "pos") {
        return 1;
      }

      if (a.revealed && !b.revealed) {
        return -1;
      } else if (!a.revealed && b.revealed) {
        return 1;
      }

      return a.morphFeature.compareTo(b.morphFeature);
    });

    final lastRevealedIndex =
        activityMorphs.lastIndexWhere((morph) => morph.revealed);

    if (lastRevealedIndex == -1) {
      return activityMorphs;
    } else if (lastRevealedIndex >= (activityMorphs.length - 1)) {
      return activityMorphs;
    } else {
      return activityMorphs.take(lastRevealedIndex + 2).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _visibleMorphs.map((morph) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: MorphologicalActivityButton(
            onPressed: setMorphFeature,
            morphCategory: morph.morphFeature,
            icon: getIconForMorphFeature(morph.morphFeature),
            isUnlocked: morph.revealed,
            isSelected: selectedMorphFeature == morph.morphFeature,
          ),
        );
      }).toList(),
    );
  }
}

class MorphologicalActivityButton extends StatelessWidget {
  final Function(String) onPressed;
  final String morphCategory;
  final IconData icon;

  final bool isUnlocked;
  final bool isSelected;

  const MorphologicalActivityButton({
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
