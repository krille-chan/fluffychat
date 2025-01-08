import 'package:flutter_gen/gen_l10n/l10n.dart';

enum AnalyticsSummaryEnum {
  username,
  level,
  totalXP,
  numLemmas,
  numLemmasUsedCorrectly,
  numLemmasUsedIncorrectly,
  // listLemmas,
  // listLemmasUsedCorrectly,
  // listLemmasUsedIncorrectly,

  /// 0 - 30 XP
  numLemmasSmallXP,
  // listLemmasSmallXP,

  /// 31 - 200 XP
  numLemmasMediumXP,
  // listLemmasMediumXP,

  /// > 200 XP
  numLemmasLargeXP,
  // listLemmasLargeXP,

  numMorphConstructs,
  listMorphConstructs,
  listMorphConstructsUsedCorrectly,
  listMorphConstructsUsedIncorrectly,

  // list morph 0 - 30 XP
  listMorphSmallXP,

  // list morph 31 - 200 XP
  listMorphMediumXP,

  // list morph 200 - 500 XP
  listMorphLargeXP,

  // list morph > 500 XP
  listMorphHugeXP,

  numMessagesSent,
  numWordsTyped,
  numChoicesCorrect,
  numChoicesIncorrect,
}

extension AnalyticsSummaryEnumExtension on AnalyticsSummaryEnum {
  String header(L10n l10n) {
    switch (this) {
      case AnalyticsSummaryEnum.username:
        return l10n.username;
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
      // case AnalyticsSummaryEnum.listLemmas:
      //   return l10n.listOfLemmas;
      // case AnalyticsSummaryEnum.listLemmasUsedCorrectly:
      //   return l10n.listLemmasUsedCorrectly;
      // case AnalyticsSummaryEnum.listLemmasUsedIncorrectly:
      //   return l10n.listLemmasUsedIncorrectly;
      case AnalyticsSummaryEnum.numLemmasSmallXP:
        return l10n.numLemmasSmallXP;
      case AnalyticsSummaryEnum.numLemmasMediumXP:
        return l10n.numLemmasMediumXP;
      case AnalyticsSummaryEnum.numLemmasLargeXP:
        return l10n.numLemmasLargeXP;
      // case AnalyticsSummaryEnum.listLemmasSmallXP:
      //   return l10n.listLemmasSmallXP;
      // case AnalyticsSummaryEnum.listLemmasMediumXP:
      //   return l10n.listLemmasMediumXP;
      // case AnalyticsSummaryEnum.listLemmasLargeXP:
      //   return l10n.listLemmasLargeXP;
      case AnalyticsSummaryEnum.numMorphConstructs:
        return l10n.numGrammarConcepts;
      case AnalyticsSummaryEnum.listMorphConstructs:
        return l10n.listGrammarConcepts;
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectly:
        return l10n.listGrammarConceptsUsedCorrectly;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectly:
        return l10n.listGrammarConceptsUsedIncorrectly;
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
