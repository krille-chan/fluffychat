import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum AnalyticsSummaryEnum {
  lemma,
  morphFeature,
  morphTag,
  xp,
  forms,
  exampleMessages,
  independentUseOccurrences,
  assistedUseOccurrences;

  String header(BuildContext context) {
    final l10n = L10n.of(context);
    switch (this) {
      case lemma:
        return l10n.lemma;
      case morphFeature:
        return l10n.grammarFeature;
      case morphTag:
        return l10n.grammarTag;
      case xp:
        return l10n.totalXP;
      case forms:
        return l10n.forms;
      case exampleMessages:
        return l10n.exampleMessages;
      case independentUseOccurrences:
        return l10n.timesUsedIndependently;
      case assistedUseOccurrences:
        return l10n.timesUsedWithAssistance;
    }
  }

  const AnalyticsSummaryEnum();

  static List<AnalyticsSummaryEnum> get vocabValues => [
        lemma,
        xp,
        forms,
        exampleMessages,
        independentUseOccurrences,
        assistedUseOccurrences,
      ];

  static List<AnalyticsSummaryEnum> get morphValues => [
        morphFeature,
        morphTag,
        xp,
        forms,
        exampleMessages,
        independentUseOccurrences,
        assistedUseOccurrences,
      ];
}
