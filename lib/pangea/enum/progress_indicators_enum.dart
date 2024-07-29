import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum ProgressIndicatorEnum {
  level,
  wordsUsed,
  errorTypes,
}

extension ProgressIndicatorsExtension on ProgressIndicatorEnum {
  IconData get icon {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return Icons.text_fields_outlined;
      case ProgressIndicatorEnum.errorTypes:
        return Icons.error_outline;
      case ProgressIndicatorEnum.level:
        return Icons.star;
    }
  }

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color color(BuildContext context) {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 169, 183, 237)
            : const Color.fromARGB(255, 38, 59, 141);
      case ProgressIndicatorEnum.errorTypes:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 212, 144, 216)
            : const Color.fromARGB(255, 163, 39, 169);
      case ProgressIndicatorEnum.level:
        return Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 250, 220, 129)
            : const Color.fromARGB(255, 255, 208, 67);
      default:
        return Theme.of(context).textTheme.bodyLarge!.color ?? Colors.blueGrey;
    }
  }

  String tooltip(BuildContext context) {
    switch (this) {
      case ProgressIndicatorEnum.wordsUsed:
        return L10n.of(context)!.wordsUsed;
      case ProgressIndicatorEnum.errorTypes:
        return L10n.of(context)!.errorTypes;
      case ProgressIndicatorEnum.level:
        return L10n.of(context)!.level;
    }
  }
}
