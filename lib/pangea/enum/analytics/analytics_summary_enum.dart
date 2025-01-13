import 'package:flutter_gen/gen_l10n/l10n.dart';

enum AnalyticsSummaryEnum {
  username,
  dataAvailable,
  level,
  totalXP,

  numMessagesSent,
  numWordsTyped,
  numChoicesCorrect,
  numChoicesIncorrect,

  numLemmas,
  numLemmasUsedCorrectly,
  numLemmasUsedIncorrectly,

  /// 0 - 30 XP
  numLemmasSmallXP,

  /// 31 - 200 XP
  numLemmasMediumXP,

  /// > 200 XP
  numLemmasLargeXP,

  numMorphConstructs,
  listMorphConstructs,
  listMorphConstructsUsedCorrectlyOriginal,
  listMorphConstructsUsedIncorrectlyOriginal,
  listMorphConstructsUsedCorrectlySystem,
  listMorphConstructsUsedIncorrectlySystem,

  // list morph 0 - 30 XP
  listMorphSmallXP,

  // list morph 31 - 200 XP
  listMorphMediumXP,

  // list morph 200 - 500 XP
  listMorphLargeXP,

  // list morph > 500 XP
  listMorphHugeXP,
}

extension AnalyticsSummaryEnumExtension on AnalyticsSummaryEnum {
  String header(L10n l10n) {
    switch (this) {
      case AnalyticsSummaryEnum.username:
        return l10n.username;
      case AnalyticsSummaryEnum.dataAvailable:
        return l10n.dataAvailable;
      case AnalyticsSummaryEnum.level:
        return l10n.level;
      case AnalyticsSummaryEnum.totalXP:
        return l10n.totalXP;
      case AnalyticsSummaryEnum.numLemmas:
        return l10n.numLemmas;
      case AnalyticsSummaryEnum.numLemmasUsedCorrectly:
        return l10n.numLemmasUsedCorrectly;
      case AnalyticsSummaryEnum.numLemmasUsedIncorrectly:
        return l10n.numLemmasUsedIncorrectly;
      case AnalyticsSummaryEnum.numLemmasSmallXP:
        return l10n.numLemmasSmallXP;
      case AnalyticsSummaryEnum.numLemmasMediumXP:
        return l10n.numLemmasMediumXP;
      case AnalyticsSummaryEnum.numLemmasLargeXP:
        return l10n.numLemmasLargeXP;
      case AnalyticsSummaryEnum.numMorphConstructs:
        return l10n.numGrammarConcepts;
      case AnalyticsSummaryEnum.listMorphConstructs:
        return l10n.listGrammarConcepts;
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectlyOriginal:
        return l10n.listGrammarConceptsUsedCorrectly;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlyOriginal:
        return l10n.listGrammarConceptsUsedIncorrectly;
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectlySystem:
        return l10n.listGrammarConceptsUseCorrectlySystemGenerated;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlySystem:
        return l10n.listGrammarConceptsUseIncorrectlySystemGenerated;
      case AnalyticsSummaryEnum.listMorphSmallXP:
        return l10n.listGrammarConceptsSmallXP;
      case AnalyticsSummaryEnum.listMorphMediumXP:
        return l10n.listGrammarConceptsMediumXP;
      case AnalyticsSummaryEnum.listMorphLargeXP:
        return l10n.listGrammarConceptsLargeXP;
      case AnalyticsSummaryEnum.listMorphHugeXP:
        return l10n.listGrammarConceptsHugeXP;
      case AnalyticsSummaryEnum.numMessagesSent:
        return l10n.numMessagesSent;
      case AnalyticsSummaryEnum.numWordsTyped:
        return l10n.numWordsTyped;
      case AnalyticsSummaryEnum.numChoicesCorrect:
        return l10n.numCorrectChoices;
      case AnalyticsSummaryEnum.numChoicesIncorrect:
        return l10n.numIncorrectChoices;
    }
  }
}
