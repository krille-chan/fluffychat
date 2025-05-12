import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_downloads/space_analytics_summary_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';

class SpaceAnalyticsSummaryModel {
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

  SpaceAnalyticsSummaryModel({
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

  static SpaceAnalyticsSummaryModel emptyModel(String userID) {
    return SpaceAnalyticsSummaryModel(
      username: userID,
      dataAvailable: false,
    );
  }

  static SpaceAnalyticsSummaryModel fromConstructListModel(
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
            use.useType == ConstructUseTypeEnum.ga ||
            use.useType == ConstructUseTypeEnum.ta,
        percent: 0.8,
        context: context,
      );

      correctOriginalUseLemmas.addAll(originalWrittenUses.over);
      incorrectOriginalUseLemmas.addAll(originalWrittenUses.under);

      final systemGeneratedUses = morphLemmas.lemmasByPercent(
        filter: (use) =>
            use.useType != ConstructUseTypeEnum.wa &&
            use.useType != ConstructUseTypeEnum.ga &&
            use.useType != ConstructUseTypeEnum.ta &&
            use.useType != ConstructUseTypeEnum.unk &&
            use.xp != 0,
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
        if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numWordsTyped) {
          numWordsTyped = numWordsTyped! + 1;
        } else if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numChoicesCorrect) {
          numChoicesCorrect = numChoicesCorrect! + 1;
        } else if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numChoicesIncorrect) {
          numChoicesIncorrect = numChoicesIncorrect! + 1;
        }
      }
    }

    final numMessageSent = model?.uses
        .where((use) => use.useType.sentByUser)
        .map((use) => use.metadata.eventId)
        .toSet()
        .length;

    return SpaceAnalyticsSummaryModel(
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

  dynamic getValue(SpaceAnalyticsSummaryEnum key, BuildContext context) {
    switch (key) {
      case SpaceAnalyticsSummaryEnum.username:
        return username;
      case SpaceAnalyticsSummaryEnum.dataAvailable:
        return dataAvailable
            ? L10n.of(context).available
            : L10n.of(context).unavailable;
      case SpaceAnalyticsSummaryEnum.level:
        return level;
      case SpaceAnalyticsSummaryEnum.totalXP:
        return totalXP;
      case SpaceAnalyticsSummaryEnum.numLemmas:
        return numLemmas;
      case SpaceAnalyticsSummaryEnum.numLemmasUsedCorrectly:
        return numLemmasUsedCorrectly;
      case SpaceAnalyticsSummaryEnum.numLemmasUsedIncorrectly:
        return numLemmasUsedIncorrectly;
      case SpaceAnalyticsSummaryEnum.numLemmasSmallXP:
        return numLemmasSmallXP;
      case SpaceAnalyticsSummaryEnum.numLemmasMediumXP:
        return numLemmasMediumXP;
      case SpaceAnalyticsSummaryEnum.numLemmasLargeXP:
        return numLemmasLargeXP;
      case SpaceAnalyticsSummaryEnum.numMorphConstructs:
        return numMorphConstructs;
      case SpaceAnalyticsSummaryEnum.listMorphConstructs:
        return listMorphConstructs;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedCorrectlyOriginal:
        return listMorphConstructsUsedCorrectlyOriginal;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlyOriginal:
        return listMorphConstructsUsedIncorrectlyOriginal;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedCorrectlySystem:
        return listMorphConstructsUsedCorrectlySystem;
      case SpaceAnalyticsSummaryEnum.listMorphConstructsUsedIncorrectlySystem:
        return listMorphConstructsUsedIncorrectlySystem;
      case SpaceAnalyticsSummaryEnum.listMorphSmallXP:
        return listMorphSmallXP;
      case SpaceAnalyticsSummaryEnum.listMorphMediumXP:
        return listMorphMediumXP;
      case SpaceAnalyticsSummaryEnum.listMorphLargeXP:
        return listMorphLargeXP;
      case SpaceAnalyticsSummaryEnum.listMorphHugeXP:
        return listMorphHugeXP;
      case SpaceAnalyticsSummaryEnum.numMessagesSent:
        return numMessagesSent;
      case SpaceAnalyticsSummaryEnum.numWordsTyped:
        return numWordsTyped;
      case SpaceAnalyticsSummaryEnum.numChoicesCorrect:
        return numChoicesCorrect;
      case SpaceAnalyticsSummaryEnum.numChoicesIncorrect:
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
