import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../bot/utils/bot_style.dart';

enum UseType { wa, ta, ga, un }

extension UseTypeMethods on UseType {
  String get string => toString().split(".").last;

  String tooltipString(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case UseType.ga:
        return l10n.gaTooltip;
      case UseType.ta:
        return l10n.taTooltip;
      case UseType.wa:
        return l10n.waTooltip;
      default:
        return l10n.unTooltip;
    }
  }

  IconData get iconData {
    switch (this) {
      case UseType.ga:
        return Icons.spellcheck_outlined;
      case UseType.ta:
        return Icons.translate;
      case UseType.wa:
        return Icons.thumb_up;
      default:
        return Icons.question_mark_outlined;
    }
  }

  Widget iconView(BuildContext context, Color color, [int size = 14]) =>
      Tooltip(
        message: tooltipString(context),
        child: Icon(
          iconData,
          color: color,
          size: size.toDouble(),
        ),
      );

  Widget iconButtonView(BuildContext context, Color color, [int size = 14]) =>
      Tooltip(
        message: tooltipString(context),
        child: Icon(
          iconData,
          color: color,
          size: size.toDouble(),
        ),
      );

  Widget textView(BuildContext context, [TextStyle? existingStyle]) => Tooltip(
        message: tooltipString(context),
        child: Text(
          string,
          style: BotStyle.text(
            context,
            existingStyle: existingStyle,
            italics: true,
          ),
          textAlign: TextAlign.end,
        ),
      );

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color color(BuildContext context) {
    switch (this) {
      case UseType.ga:
        return isDarkMode(context)
            ? const Color.fromARGB(255, 157, 234, 172)
            : const Color.fromARGB(255, 31, 146, 54);
      case UseType.ta:
        return isDarkMode(context)
            ? const Color.fromARGB(255, 169, 183, 237)
            : const Color.fromARGB(255, 38, 59, 141);
      case UseType.wa:
        return isDarkMode(context)
            ? const Color.fromARGB(255, 212, 144, 216)
            : const Color.fromARGB(255, 163, 39, 169);
      default:
        return Theme.of(context).textTheme.bodyLarge!.color ?? Colors.blueGrey;
    }
  }
}
