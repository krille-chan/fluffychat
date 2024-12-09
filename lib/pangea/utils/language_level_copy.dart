import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LanguageLevelTextPicker {
  static String languageLevelText(BuildContext context, int languageLevel) {
    final L10n copy = L10n.of(context);
    switch (languageLevel) {
      case 0:
        return copy.languageLevelPreA1;
      case 1:
        return copy.languageLevelA1;
      case 2:
        return copy.languageLevelA2;
      case 3:
        return copy.languageLevelB1;
      case 4:
        return copy.languageLevelB2;
      case 5:
        return copy.languageLevelC1;
      case 6:
        return copy.languageLevelC2;
      default:
        return "undefined level";
    }
  }
}
