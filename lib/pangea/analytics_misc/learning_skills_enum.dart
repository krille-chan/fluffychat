import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

enum LearningSkillsEnum {
  writing(isVisible: true, icon: Symbols.edit_square),
  reading(isVisible: true, icon: Symbols.two_pager),
  speaking(isVisible: false),
  hearing(isVisible: true, icon: Icons.volume_up),
  other(isVisible: false);

  final bool isVisible;
  final IconData icon;

  const LearningSkillsEnum({
    required this.isVisible,
    this.icon = Icons.question_mark,
  });

  String tooltip(BuildContext context) {
    switch (this) {
      case LearningSkillsEnum.writing:
        return L10n.of(context).writingExercisesTooltip;
      case LearningSkillsEnum.reading:
        return L10n.of(context).readingExercisesTooltip;
      case LearningSkillsEnum.hearing:
        return L10n.of(context).listeningExercisesTooltip;
      default:
        return "";
    }
  }
}
