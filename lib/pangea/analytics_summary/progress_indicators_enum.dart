import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';

enum ProgressIndicatorEnum {
  level,
  wordsUsed,
  morphsUsed,
}

extension ProgressIndicatorsExtension on ProgressIndicatorEnum {
  IconData get icon {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return Symbols.dictionary;
      case ProgressIndicatorEnum.morphsUsed:
        return Symbols.toys_and_games;
      case ProgressIndicatorEnum.level:
        return Icons.star;
    }
  }

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color color(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  String tooltip(BuildContext context) {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return L10n.of(context).vocab;
      case ProgressIndicatorEnum.level:
        return L10n.of(context).level;
      case ProgressIndicatorEnum.morphsUsed:
        return L10n.of(context).grammar;
    }
  }

  ConstructTypeEnum get constructType {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return ConstructTypeEnum.vocab;
      case ProgressIndicatorEnum.morphsUsed:
        return ConstructTypeEnum.morph;
      default:
        return ConstructTypeEnum.vocab;
    }
  }
}
