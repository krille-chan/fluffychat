import 'package:fluffychat/l10n/l10n.dart';

enum SpaceAnalyticsSummaryEnum {
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

  /// Number of completed activities
  numCompletedActivities,
}

extension AnalyticsSummaryEnumExtension on SpaceAnalyticsSummaryEnum {
  String header(L10n l10n) {
    switch (this) {
      case SpaceAnalyticsSummaryEnum.username:
        return l10n.username;
      case SpaceAnalyticsSummaryEnum.dataAvailable:
        return l10n.dataAvailable;
      case SpaceAnalyticsSummaryEnum.level:
        return l10n.level;
      case SpaceAnalyticsSummaryEnum.totalXP:
        return l10n.totalXP;
      case SpaceAnalyticsSummaryEnum.numLemmas:
        return l10n.numLemmas;
      case SpaceAnalyticsSummaryEnum.numLemmasUsedCorrectly:
        return l10n.numLemmasUsedCorrectly;
      case SpaceAnalyticsSummaryEnum.numLemmasUsedIncorrectly:
        return l10n.numLemmasUsedIncorrectly;
      case SpaceAnalyticsSummaryEnum.numLemmasSmallXP:
        return l10n.numLemmasSmallXP;
      case SpaceAnalyticsSummaryEnum.numLemmasMediumXP:
        return l10n.numLemmasMediumXP;
      case SpaceAnalyticsSummaryEnum.numLemmasLargeXP:
        return l10n.numLemmasLargeXP;
      case SpaceAnalyticsSummaryEnum.numMorphConstructs:
        return l10n.numGrammarConcepts;
      case SpaceAnalyticsSummaryEnum.listMorphConstructs:
        return l10n.listGrammarConcepts;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedCorrectlyOriginal:
        return l10n.listGrammarConceptsUsedCorrectly;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlyOriginal:
        return l10n.listGrammarConceptsUsedIncorrectly;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedCorrectlySystem:
        return l10n.listGrammarConceptsUseCorrectlySystemGenerated;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlySystem:
        return l10n.listGrammarConceptsUseIncorrectlySystemGenerated;
      case SpaceAnalyticsSummaryEnum.listMorphSmallXP:
        return l10n.listGrammarConceptsSmallXP;
      case SpaceAnalyticsSummaryEnum.listMorphMediumXP:
        return l10n.listGrammarConceptsMediumXP;
      case SpaceAnalyticsSummaryEnum.listMorphLargeXP:
        return l10n.listGrammarConceptsLargeXP;
      case SpaceAnalyticsSummaryEnum.listMorphHugeXP:
        return l10n.listGrammarConceptsHugeXP;
      case SpaceAnalyticsSummaryEnum.numMessagesSent:
        return l10n.numMessagesSent;
      case SpaceAnalyticsSummaryEnum.numWordsTyped:
        return l10n.numWordsTyped;
      case SpaceAnalyticsSummaryEnum.numChoicesCorrect:
        return l10n.numCorrectChoices;
      case SpaceAnalyticsSummaryEnum.numChoicesIncorrect:
        return l10n.numIncorrectChoices;
      case SpaceAnalyticsSummaryEnum.numCompletedActivities:
        return l10n.numSavedActivities;
    }
  }
}
