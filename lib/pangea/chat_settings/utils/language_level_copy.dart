import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class LanguageLevelTextPicker {
  static String languageLevelText(
    BuildContext context,
    LanguageLevelTypeEnum languageLevel,
  ) {
    final L10n copy = L10n.of(context);
    switch (languageLevel) {
      case LanguageLevelTypeEnum.preA1:
        return copy.languageLevelPreA1;
      case LanguageLevelTypeEnum.a1:
        return copy.languageLevelA1;
      case LanguageLevelTypeEnum.a2:
        return copy.languageLevelA2;
      case LanguageLevelTypeEnum.b1:
        return copy.languageLevelB1;
      case LanguageLevelTypeEnum.b2:
        return copy.languageLevelB2;
      case LanguageLevelTypeEnum.c1:
        return copy.languageLevelC1;
      case LanguageLevelTypeEnum.c2:
        return copy.languageLevelC2;
    }
  }
}
