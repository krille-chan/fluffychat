import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum VocabProficiencyEnum { low, medium, high, unk }

extension Copy on VocabProficiencyEnum {
  String toolTipString(BuildContext context) {
    switch (this) {
      case VocabProficiencyEnum.low:
        return L10n.of(context).low;
      case VocabProficiencyEnum.medium:
        return L10n.of(context).medium;
      case VocabProficiencyEnum.high:
        return L10n.of(context).high;
      case VocabProficiencyEnum.unk:
        return L10n.of(context).unknownProficiency;
    }
  }

  IconData get iconData {
    switch (this) {
      case VocabProficiencyEnum.low:
        return Icons.sentiment_dissatisfied_outlined;
      case VocabProficiencyEnum.medium:
        return Icons.sentiment_neutral_outlined;
      case VocabProficiencyEnum.high:
        return Icons.sentiment_satisfied_outlined;
      case VocabProficiencyEnum.unk:
        return Icons.question_mark_outlined;
    }
  }
}

class VocabProficiencyUtil {
  static VocabProficiencyEnum proficiency(num numeric) {
    if (numeric > 1) {
      return VocabProficiencyEnum.high;
    }
    if (numeric < -1) {
      return VocabProficiencyEnum.low;
    }
    return VocabProficiencyEnum.medium;
  }
}
