import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';

class MatchStyleUtil {
  static TextStyle underlineStyle(Color color) => TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: color,
        decorationThickness: 5,
      );

  static Color _underlineColor(PangeaMatch match) {
    if (match.status == PangeaMatchStatus.automatic) {
      return const Color.fromARGB(187, 132, 96, 224);
    }

    switch (match.match.rule?.id ?? "unknown") {
      case MatchRuleIds.interactiveTranslation:
        return const Color.fromARGB(187, 132, 96, 224);
      case MatchRuleIds.tokenNeedsTranslation:
      case MatchRuleIds.tokenSpanNeedsTranslation:
        return const Color.fromARGB(186, 255, 132, 0);
      default:
        return const Color.fromARGB(149, 255, 17, 0);
    }
  }

  static TextStyle textStyle(
    PangeaMatch match,
    TextStyle? existingStyle,
    bool isOpenMatch,
  ) {
    double opacityFactor = 1.0;
    if (!isOpenMatch) {
      opacityFactor = 0.2;
    }

    final alpha = (255 * opacityFactor).round();
    final style = underlineStyle(_underlineColor(match).withAlpha(alpha));
    return existingStyle?.merge(style) ?? style;
  }
}
