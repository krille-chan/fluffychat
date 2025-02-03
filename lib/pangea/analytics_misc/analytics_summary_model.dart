import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_downloads/analytics_summary_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';

class AnalyticsSummaryModel {
  String username;
  bool dataAvailable;
  int? level;
  int? totalXP;

  int? numLemmas;
  int? numLemmasUsedCorrectly;
  int? numLemmasUsedIncorrectly;

  /// 0 - 30 XP
  int? numLemmasSmallXP;

  /// 31 - 200 XP
  int? numLemmasMediumXP;

  /// > 200 XP
  int? numLemmasLargeXP;

  int? numMorphConstructs;
  List<String>? listMorphConstructs;
  List<String>? listMorphConstructsUsedCorrectlyOriginal;
  List<String>? listMorphConstructsUsedIncorrectlyOriginal;
  List<String>? listMorphConstructsUsedCorrectlySystem;
  List<String>? listMorphConstructsUsedIncorrectlySystem;

  // list morph 0 - 30 XP
  List<String>? listMorphSmallXP;

  // list morph 31 - 200 XP
  List<String>? listMorphMediumXP;

  // list morph 200 - 500 XP
  List<String>? listMorphLargeXP;

  // list morph > 500 XP
  List<String>? listMorphHugeXP;

  int? numMessagesSent;
  int? numWordsTyped;
  int? numChoicesCorrect;
  int? numChoicesIncorrect;

  AnalyticsSummaryModel({
    required this.username,
    required this.dataAvailable,
    this.level,
    this.totalXP,
    this.numLemmas,
    this.numLemmasUsedCorrectly,
    this.numLemmasUsedIncorrectly,
    this.numLemmasSmallXP,
    this.numLemmasMediumXP,
    this.numLemmasLargeXP,
    this.numMorphConstructs,
    this.listMorphConstructs,
    this.listMorphConstructsUsedCorrectlyOriginal,
    this.listMorphConstructsUsedIncorrectlyOriginal,
    this.listMorphConstructsUsedCorrectlySystem,
    this.listMorphConstructsUsedIncorrectlySystem,
    this.listMorphSmallXP,
    this.listMorphMediumXP,
    this.listMorphLargeXP,
    this.listMorphHugeXP,
    this.numMessagesSent,
    this.numWordsTyped,
    this.numChoicesCorrect,
    this.numChoicesIncorrect,
  });

  static AnalyticsSummaryModel emptyModel(String userID) {
    return AnalyticsSummaryModel(
      username: userID,
      dataAvailable: false,
    );
  }

  static AnalyticsSummaryModel fromConstructListModel(
    String userID,
    ConstructListModel? model,
    String Function(ConstructUses) getCopy,
    BuildContext context,
  ) {
    final vocabLemmas = model != null
        ? LemmasToUsesWrapper(
            model.lemmasToUses(type: ConstructTypeEnum.vocab),
          )
        : null;
    final morphLemmas = model != null
        ? LemmasToUsesWrapper(
            model.lemmasToUses(type: ConstructTypeEnum.morph),
          )
        : null;

    final List<String> correctOriginalUseLemmas = [];
    final List<String> correctSystemUseLemmas = [];
    final List<String> incorrectOriginalUseLemmas = [];
    final List<String> incorrectSystemUseLemmas = [];

    if (morphLemmas != null) {
      final originalWrittenUses = morphLemmas.lemmasByPercent(
        filter: (use) =>
            use.useType == ConstructUseTypeEnum.wa ||
            use.useType == ConstructUseTypeEnum.ga,
        percent: 0.8,
        context: context,
      );

      correctOriginalUseLemmas.addAll(originalWrittenUses.over);
      incorrectOriginalUseLemmas.addAll(originalWrittenUses.under);

      final systemGeneratedUses = morphLemmas.lemmasByPercent(
        filter: (use) =>
            use.useType != ConstructUseTypeEnum.wa &&
            use.useType != ConstructUseTypeEnum.ga &&
            use.useType != ConstructUseTypeEnum.unk &&
            use.pointValue != 0,
        percent: 0.8,
        context: context,
      );

      correctSystemUseLemmas.addAll(systemGeneratedUses.over);
      incorrectSystemUseLemmas.addAll(systemGeneratedUses.under);
    }

    final vocabLemmasCorrect = vocabLemmas?.lemmasByCorrectUse();

    int? numWordsTyped;
    int? numChoicesCorrect;
    int? numChoicesIncorrect;
    if (model != null) {
      numWordsTyped = 0;
      numChoicesCorrect = 0;
      numChoicesIncorrect = 0;
      for (final use in model.uses) {
        if (use.useType.summaryEnumType == AnalyticsSummaryEnum.numWordsTyped) {
          numWordsTyped = numWordsTyped! + 1;
        } else if (use.useType.summaryEnumType ==
            AnalyticsSummaryEnum.numChoicesCorrect) {
          numChoicesCorrect = numChoicesCorrect! + 1;
        } else if (use.useType.summaryEnumType ==
            AnalyticsSummaryEnum.numChoicesIncorrect) {
          numChoicesIncorrect = numChoicesIncorrect! + 1;
        }
      }
    }

    final numMessageSent = model?.uses
        .where((use) => use.useType.sentByUser)
        .map((use) => use.metadata.eventId)
        .toSet()
        .length;

    return AnalyticsSummaryModel(
      username: userID,
      dataAvailable: model != null,
      level: model?.level,
      totalXP: model?.totalXP,
      numLemmas: model?.vocabLemmas,
      numLemmasUsedCorrectly: vocabLemmasCorrect?.over.length,
      numLemmasUsedIncorrectly: vocabLemmasCorrect?.under.length,
      numLemmasSmallXP:
          vocabLemmas?.thresholdedLemmas(start: 0, end: 30).length,
      numLemmasMediumXP:
          vocabLemmas?.thresholdedLemmas(start: 31, end: 200).length,
      numLemmasLargeXP: vocabLemmas?.thresholdedLemmas(start: 201).length,
      numMorphConstructs: model?.grammarLemmas,
      listMorphConstructs: morphLemmas?.lemmasToUses.entries
          .map((entry) => getCopy(entry.value.first))
          .toList(),
      listMorphConstructsUsedCorrectlyOriginal: correctOriginalUseLemmas,
      listMorphConstructsUsedIncorrectlyOriginal: incorrectOriginalUseLemmas,
      listMorphConstructsUsedCorrectlySystem: correctSystemUseLemmas,
      listMorphConstructsUsedIncorrectlySystem: incorrectSystemUseLemmas,
      listMorphSmallXP: morphLemmas?.thresholdedLemmas(
        start: 0,
        end: 50,
        getCopy: getCopy,
      ),
      listMorphMediumXP: morphLemmas?.thresholdedLemmas(
        start: 51,
        end: 200,
        getCopy: getCopy,
      ),
      listMorphLargeXP: morphLemmas?.thresholdedLemmas(
        start: 201,
        end: 500,
        getCopy: getCopy,
      ),
      listMorphHugeXP: morphLemmas?.thresholdedLemmas(
        start: 501,
        getCopy: getCopy,
      ),
      numMessagesSent: numMessageSent,
      numWordsTyped: numWordsTyped,
      numChoicesCorrect: numChoicesCorrect,
      numChoicesIncorrect: numChoicesIncorrect,
    );
  }

  dynamic getValue(AnalyticsSummaryEnum key, BuildContext context) {
    switch (key) {
      case AnalyticsSummaryEnum.username:
        return username;
      case AnalyticsSummaryEnum.dataAvailable:
        return dataAvailable
            ? L10n.of(context).available
            : L10n.of(context).unavailable;
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
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectlyOriginal:
        return listMorphConstructsUsedCorrectlyOriginal;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlyOriginal:
        return listMorphConstructsUsedIncorrectlyOriginal;
      case AnalyticsSummaryEnum.listMorphConstructsUsedCorrectlySystem:
        return listMorphConstructsUsedCorrectlySystem;
      case AnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlySystem:
        return listMorphConstructsUsedIncorrectlySystem;
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
      'listMorphConstructsUsedCorrectly':
          listMorphConstructsUsedCorrectlyOriginal,
      'listMorphConstructsUsedIncorrectly':
          listMorphConstructsUsedIncorrectlyOriginal,
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
