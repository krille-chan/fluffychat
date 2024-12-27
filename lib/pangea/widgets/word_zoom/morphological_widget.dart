import 'dart:developer';

import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/analytics/morph_categories_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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

class MorphologicalListWidget extends StatefulWidget {
  final PangeaToken token;
  final String? selectedMorphFeature;
  final Function(String?) setMorphFeature;
  final int completedActivities;

  const MorphologicalListWidget({
    super.key,
    required this.selectedMorphFeature,
    required this.token,
    required this.setMorphFeature,
    required this.completedActivities,
  });

  @override
  MorphologicalListWidgetState createState() => MorphologicalListWidgetState();
}

class MorphologicalListWidgetState extends State<MorphologicalListWidget> {
  // TODO: make this is a list of morphological features icons based on MorphActivityGenerator.getSequence
  // For each item in the sequence,
  //    if shouldDoActivity is true, show the template icon then stop
  //    if shouldDoActivity is false, show the actual icon and value then go to the next item

  final List<ActivityMorph> _morphs = [];

  @override
  void initState() {
    super.initState();
    _setMorphs();
  }

  @override
  void didUpdateWidget(covariant MorphologicalListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token) {
      _setMorphs();
    }

    if (widget.completedActivities != oldWidget.completedActivities &&
        oldWidget.selectedMorphFeature != null) {
      final oldSelectedMorphIndex = _morphs.indexWhere(
        (morph) => morph.morphFeature == oldWidget.selectedMorphFeature,
      );
      if (oldSelectedMorphIndex != -1 &&
          oldSelectedMorphIndex < _morphs.length) {
        setState(
          () => _morphs[oldSelectedMorphIndex].revealed = true,
        );

        final nextIndex = oldSelectedMorphIndex + 1;
        if (nextIndex < _morphs.length) {
          widget.setMorphFeature(_morphs[nextIndex].morphFeature);
        } else {
          widget.setMorphFeature(null);
        }
      }
    }
  }

  Future<void> _setMorphs() async {
    _morphs.clear();
    final morphEntries = widget.token.morph.entries.toList();
    for (final morphEntry in morphEntries) {
      final morphFeature = morphEntry.key;
      final morphTag = morphEntry.value;
      final shouldDoActivity = widget.token.shouldDoMorphActivity(morphFeature);
      final canGenerateDistractors = await widget.token.canGenerateDistractors(
        ActivityTypeEnum.morphId,
        morphFeature: morphFeature,
        morphTag: morphTag,
      );
      _morphs.add(
        ActivityMorph(
          morphFeature: morphFeature,
          morphTag: morphTag,
          revealed: !shouldDoActivity || !canGenerateDistractors,
        ),
      );
    }

    _morphs.sort((a, b) {
      if (a.revealed && !b.revealed) {
        return -1;
      } else if (!a.revealed && b.revealed) {
        return 1;
      }

      if (a.morphFeature.toLowerCase() == "pos") {
        return -1;
      } else if (b.morphFeature.toLowerCase() == "pos") {
        return 1;
      }

      return a.morphFeature.compareTo(b.morphFeature);
    });
  }

  List<ActivityMorph> get _visibleMorphs {
    final lastRevealedIndex = _morphs.lastIndexWhere((morph) => morph.revealed);

    // if none of the morphs are revealed, show only the first one
    if (lastRevealedIndex == -1) {
      return _morphs.take(1).toList();
    }

    // show all the revealed morphs + the first one with an activity
    return _morphs.take(lastRevealedIndex + 2).toList();
  }

  // TODO Use the icons that Khue is creating
  IconData _getIconForMorphFeature(String feature) {
    // Define a function to get the icon based on the universal dependency morphological feature (key)
    switch (feature.toLowerCase()) {
      case 'number':
        // google material 123 icon
        return Icons.format_list_numbered;
      case 'gender':
        return Icons.wc;
      case 'tense':
        return Icons.access_time;
      case 'mood':
        return Icons.mood;
      case 'person':
        return Icons.person;
      case 'case':
        return Icons.format_list_bulleted;
      case 'degree':
        return Icons.trending_up;
      case 'verbform':
        return Icons.text_format;
      case 'voice':
        return Icons.record_voice_over;
      case 'aspect':
        return Icons.aspect_ratio;
      case 'prontype':
        return Icons.text_fields;
      case 'numtype':
        return Icons.format_list_numbered;
      case 'poss':
        return Icons.account_balance;
      case 'reflex':
        return Icons.refresh;
      case 'foreign':
        return Icons.language;
      case 'abbr':
        return Icons.text_format;
      case 'nountype':
        return Symbols.abc;
      case 'pos':
        return Symbols.toys_and_games;
      default:
        debugger(when: kDebugMode);
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _visibleMorphs.map((morph) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: MorphologicalActivityButton(
            onPressed: widget.setMorphFeature,
            morphCategory: morph.morphFeature,
            icon: _getIconForMorphFeature(morph.morphFeature),
            isUnlocked: morph.revealed,
            isSelected: widget.selectedMorphFeature == morph.morphFeature,
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
    return Column(
      children: [
        Tooltip(
          message: getMorphologicalCategoryCopy(
            morphCategory,
            context,
          ),
          child: Opacity(
            opacity: (isUnlocked && !isSelected) ? 0.75 : 1,
            child: IconButton(
              onPressed: () => onPressed(morphCategory),
              icon: Icon(icon),
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ],
    );
  }
}
