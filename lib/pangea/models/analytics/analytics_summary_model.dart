import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/enum/analytics/analytics_summary_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';

class AnalyticsSummaryModel {
  String username;
  int level;
  int totalXP;

  int numLemmas;
  int numLemmasUsedCorrectly;
  int numLemmasUsedIncorrectly;

  /// 0 - 30 XP
  int numLemmasSmallXP;

  /// 31 - 200 XP
  int numLemmasMediumXP;

  /// > 200 XP
  int numLemmasLargeXP;

  int numMorphConstructs;
  List<String> listMorphConstructs;
  List<String> listMorphConstructsUsedCorrectly;
  List<String> listMorphConstructsUsedIncorrectly;

  // list morph 0 - 30 XP
  List<String> listMorphSmallXP;

  // list morph 31 - 200 XP
  List<String> listMorphMediumXP;

  // list morph 200 - 500 XP
  List<String> listMorphLargeXP;

  // list morph > 500 XP
  List<String> listMorphHugeXP;

  int numMessagesSent;
  int numWordsTyped;
  int numChoicesCorrect;
  int numChoicesIncorrect;

  AnalyticsSummaryModel({
    required this.username,
    required this.level,
    required this.totalXP,
    required this.numLemmas,
    required this.numLemmasUsedCorrectly,
    required this.numLemmasUsedIncorrectly,
    required this.numLemmasSmallXP,
    required this.numLemmasMediumXP,
    required this.numLemmasLargeXP,
    required this.numMorphConstructs,
    required this.listMorphConstructs,
    required this.listMorphConstructsUsedCorrectly,
    required this.listMorphConstructsUsedIncorrectly,
    required this.listMorphSmallXP,
    required this.listMorphMediumXP,
    required this.listMorphLargeXP,
    required this.listMorphHugeXP,
    required this.numMessagesSent,
    required this.numWordsTyped,
    required this.numChoicesCorrect,
    required this.numChoicesIncorrect,
  });

  static AnalyticsSummaryModel fromConstructListModel(
    ConstructListModel model,
    String userID,
    String Function(ConstructUses) getCopy,
    BuildContext context,
  ) {
    final vocabLemmas = LemmasToUsesWrapper(
      model.lemmasToUses(type: ConstructTypeEnum.vocab),
    );
    final morphLemmas = LemmasToUsesWrapper(
      model.lemmasToUses(type: ConstructTypeEnum.morph),
    );

    final morphLemmasPercentCorrect = morphLemmas.lemmasByPercent(
      percent: 0.8,
      getCopy: getCopy,
    );

    final vocabLemmasCorrect = vocabLemmas.lemmasByCorrectUse(getCopy: getCopy);

    int numWordsTyped = 0;
    int numChoicesCorrect = 0;
    int numChoicesIncorrect = 0;
    for (final use in model.uses) {
      if (use.useType.summaryEnumType == AnalyticsSummaryEnum.numWordsTyped) {
        numWordsTyped++;
      } else if (use.useType.summaryEnumType ==
          AnalyticsSummaryEnum.numChoicesCorrect) {
        numChoicesCorrect++;
      } else if (use.useType.summaryEnumType ==
          AnalyticsSummaryEnum.numChoicesIncorrect) {
        numChoicesIncorrect++;
      }
    }

    final numMessageSent = model.uses
        .where((use) => use.useType.sentByUser)
        .map((use) => use.metadata.eventId)
        .toSet()
        .length;

    return AnalyticsSummaryModel(
      username: userID,
      level: model.level,
      totalXP: model.totalXP,
      numLemmas: model.vocabLemmas,
      numLemmasUsedCorrectly: vocabLemmasCorrect.over.length,
      numLemmasUsedIncorrectly: vocabLemmasCorrect.under.length,
      numLemmasSmallXP: vocabLemmas.thresholdedLemmas(start: 0, end: 30).length,
      numLemmasMediumXP:
          vocabLemmas.thresholdedLemmas(start: 31, end: 200).length,
      numLemmasLargeXP: vocabLemmas.thresholdedLemmas(start: 201).length,
      numMorphConstructs: model.grammarLemmas,
      listMorphConstructs: morphLemmas.lemmasToUses.entries
          .map((entry) => getCopy(entry.value.first))
          .toList(),
      listMorphConstructsUsedCorrectly: morphLemmasPercentCorrect.over,
      listMorphConstructsUsedIncorrectly: morphLemmasPercentCorrect.under,
      listMorphSmallXP: morphLemmas.thresholdedLemmas(
        start: 0,
        end: 30,
        getCopy: getCopy,
      ),
      listMorphMediumXP: morphLemmas.thresholdedLemmas(
        start: 31,
        end: 200,
        getCopy: getCopy,
      ),
      listMorphLargeXP: morphLemmas.thresholdedLemmas(
        start: 201,
        end: 500,
        getCopy: getCopy,
      ),
      listMorphHugeXP: morphLemmas.thresholdedLemmas(
        start: 501,
        getCopy: getCopy,
      ),
      numMessagesSent: numMessageSent,
      numWordsTyped: numWordsTyped,
      numChoicesCorrect: numChoicesCorrect,
      numChoicesIncorrect: numChoicesIncorrect,
    );
  }

  dynamic getValue(AnalyticsSummaryEnum key) {
    switch (key) {
      case AnalyticsSummaryEnum.username:
        return username;
      case AnalyticsSummaryEnum.level:
        return level;
      case AnalyticsSummaryEnum.totalXP:
        return totalXP;
      case AnalyticsSummaryEnum.numLemmas:
        return numLemmas;
      case AnalyticsSummaryEnum.numLemmasUsedCorrectly:
        return numLemmasUsedCorrectly;
      case AnalyticsSummaryEnum.numLemmasUsedIncorrectly:
        return numLemmasUsedIncorrectly;
      case AnalyticsSummaryEnum.numLemmasSmallXP:
        return numLemmasSmallXP;
      case AnalyticsSummaryEnum.numLemmasMediumXP:
        return numLemmasMediumXP;
      case AnalyticsSummaryEnum.numLemmasLargeXP:
        return numLemmasLargeXP;
      case AnalyticsSummaryEnum.numMorphConstructs:
        return numMorphConstructs;
      case AnalyticsSummaryEnum.listMorphConstructs:
        return listMorphConstructs;
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectly:
        return listMorphConstructsUsedCorrectly;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectly:
        return listMorphConstructsUsedIncorrectly;
      case AnalyticsSummaryEnum.listMorphSmallXP:
        return listMorphSmallXP;
      case AnalyticsSummaryEnum.listMorphMediumXP:
        return listMorphMediumXP;
      case AnalyticsSummaryEnum.listMorphLargeXP:
        return listMorphLargeXP;
      case AnalyticsSummaryEnum.listMorphHugeXP:
        return listMorphHugeXP;
      case AnalyticsSummaryEnum.numMessagesSent:
        return numMessagesSent;
      case AnalyticsSummaryEnum.numWordsTyped:
        return numWordsTyped;
      case AnalyticsSummaryEnum.numChoicesCorrect:
        return numChoicesCorrect;
      case AnalyticsSummaryEnum.numChoicesIncorrect:
        return numChoicesIncorrect;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'level': level,
      'totalXP': totalXP,
      'numLemmas': numLemmas,
      'numLemmasUsedCorrectly': numLemmasUsedCorrectly,
      'numLemmasUsedIncorrectly': numLemmasUsedIncorrectly,
      'numLemmasSmallXP': numLemmasSmallXP,
      'numLemmasMediumXP': numLemmasMediumXP,
      'numLemmasLargeXP': numLemmasLargeXP,
      'numMorphConstructs': numMorphConstructs,
      'listMorphConstructs': listMorphConstructs,
      'listMorphConstructsUsedCorrectly': listMorphConstructsUsedCorrectly,
      'listMorphConstructsUsedIncorrectly': listMorphConstructsUsedIncorrectly,
      'listMorphSmallXP': listMorphSmallXP,
      'listMorphMediumXP': listMorphMediumXP,
      'listMorphLargeXP': listMorphLargeXP,
      'listMorphHugeXP': listMorphHugeXP,
      'numMessagesSent': numMessagesSent,
      'numWordsWithoutAssistance': numWordsTyped,
      'numChoicesCorrect': numChoicesCorrect,
      'numChoicesIncorrect': numChoicesIncorrect,
    };
  }
}
