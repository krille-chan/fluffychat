import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum BarChartViewSelection {
  messages,
  // vocab,
  grammar,
}

extension BarChartViewSelectionExtension on BarChartViewSelection {
  String string(BuildContext context) {
    switch (this) {
      case BarChartViewSelection.messages:
        return L10n.of(context).messages;
      // case BarChartViewSelection.vocab:
      //   return L10n.of(context).vocab;
      case BarChartViewSelection.grammar:
        return L10n.of(context).grammarAnalytics;
    }
  }

  IconData get icon {
    switch (this) {
      case BarChartViewSelection.messages:
        return Icons.chat_bubble;
      // case BarChartViewSelection.vocab:
      //   return Icons.abc;
      case BarChartViewSelection.grammar:
        return Icons.spellcheck_outlined;
    }
  }
}
