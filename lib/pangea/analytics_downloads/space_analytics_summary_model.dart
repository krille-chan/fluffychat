// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_data/construct_merge_table.dart';
import 'package:fluffychat/pangea/analytics_data/derived_analytics_data_model.dart';
import 'package:fluffychat/pangea/analytics_downloads/space_analytics_summary_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_event.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';

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

  int numCompletedActivities;

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
    this.numCompletedActivities = 0,
  });

  static SpaceAnalyticsSummaryModel emptyModel(String userID) {
    return SpaceAnalyticsSummaryModel(username: userID, dataAvailable: false);
  }

  static SpaceAnalyticsSummaryModel fromEvents(
    String username,
    List<ConstructAnalyticsEvent> events,
    Set<ConstructIdentifier> blockedConstructs,
    int numCompletedActivities,
  ) {
    int numWordsTyped = 0;
    int numChoicesCorrect = 0;
    int numChoicesIncorrect = 0;

    final Set<String> sentEventIds = {};
    final List<OneConstructUse> allUses = [];

    final Map<ConstructIdentifier, List<OneConstructUse>> aggregatedVocab = {};
    final Map<ConstructIdentifier, List<OneConstructUse>> aggregatedMorph = {};

    final ConstructMergeTable mergeTable = ConstructMergeTable();

    for (final e in events) {
      mergeTable.addConstructsByUses(e.content.uses, blockedConstructs);

      for (final use in e.content.uses) {
        final id = use.identifier;
        if (blockedConstructs.contains(id)) continue;

        allUses.add(use);

        if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numWordsTyped) {
          numWordsTyped = numWordsTyped + 1;
        } else if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numChoicesCorrect) {
          numChoicesCorrect = numChoicesCorrect + 1;
        } else if (use.useType.summaryEnumType ==
            SpaceAnalyticsSummaryEnum.numChoicesIncorrect) {
          numChoicesIncorrect = numChoicesIncorrect + 1;
        }

        if (use.useType.sentByUser && use.metadata.eventId != null) {
          sentEventIds.add(use.metadata.eventId!);
        }

        final existing = use.identifier.type == ConstructTypeEnum.vocab
            ? aggregatedVocab[id]
            : aggregatedMorph[id];

        if (existing != null) {
          existing.add(use);
        } else {
          id.type == ConstructTypeEnum.vocab
              ? aggregatedVocab[id] = [use]
              : aggregatedMorph[id] = [use];
        }
      }
    }

    final Map<ConstructIdentifier, ConstructUses> aggregatedVocabUses = {};
    for (final entry in aggregatedVocab.entries) {
      aggregatedVocabUses[entry.key] = ConstructUses(
        lemma: entry.value.first.lemma,
        constructType: entry.value.first.constructType,
        category: entry.value.first.category,
        uses: entry.value,
      );
    }

    final Map<ConstructIdentifier, ConstructUses> aggregatedMorphUses = {};
    for (final entry in aggregatedMorph.entries) {
      aggregatedMorphUses[entry.key] = ConstructUses(
        lemma: entry.value.first.lemma,
        constructType: entry.value.first.constructType,
        category: entry.value.first.category,
        uses: entry.value,
      );
    }

    final cleanedVocab = <ConstructIdentifier, ConstructUses>{};
    for (final entry in aggregatedVocabUses.values) {
      final canonical = mergeTable.resolve(entry.id);
      final existing = cleanedVocab[canonical];
      if (existing != null) {
        existing.merge(entry);
      } else {
        cleanedVocab[canonical] = entry;
      }
    }

    final cleanedMorph = <ConstructIdentifier, ConstructUses>{};
    for (final entry in aggregatedMorphUses.values) {
      final canonical = mergeTable.resolve(entry.id);
      final existing = cleanedMorph[canonical];
      if (existing != null) {
        existing.merge(entry);
      } else {
        cleanedMorph[canonical] = entry;
      }
    }

    final totalXP =
        cleanedVocab.values.fold<int>(0, (sum, entry) => sum + entry.points) +
        cleanedMorph.values.fold<int>(0, (sum, entry) => sum + entry.points);

    final level = DerivedAnalyticsDataModel.calculateLevelWithXp(totalXP);
    final uniqueVocabCount = cleanedVocab.length;
    final uniqueMorphCount = cleanedMorph.length;

    int vocabUsedCorrectly = 0;
    int vocabUsedIncorrectly = 0;
    int vocabSmallXP = 0;
    int vocabMediumXP = 0;
    int vocabLargeXP = 0;

    for (final entry in cleanedVocab.values) {
      final xp = entry.points;

      if (xp >= 0 && xp <= 29) {
        vocabSmallXP += 1;
      } else if (xp >= 30 && xp < 200) {
        vocabMediumXP += 1;
      } else if (xp >= 200) {
        vocabLargeXP += 1;
      }

      if (entry.hasCorrectUse) {
        vocabUsedCorrectly += 1;
      } else {
        vocabUsedIncorrectly += 1;
      }
    }

    final originalUseTypes = {
      ConstructUseTypeEnum.wa,
      ConstructUseTypeEnum.ga,
      ConstructUseTypeEnum.ta,
      ConstructUseTypeEnum.corIt,
      ConstructUseTypeEnum.incIt,
      ConstructUseTypeEnum.ignIt,
      ConstructUseTypeEnum.corIGC,
      ConstructUseTypeEnum.incIGC,
      ConstructUseTypeEnum.ignIGC,
    };

    final List<String> morphConstructs = [];
    final List<String> morphSmallXP = [];
    final List<String> morphMediumXP = [];
    final List<String> morphLargeXP = [];
    final List<String> morphHugeXP = [];
    final List<String> morphCorrectOriginal = [];
    final List<String> morphIncorrectOriginal = [];
    final List<String> morphCorrectSystem = [];
    final List<String> morphIncorrectSystem = [];

    for (final entry in cleanedMorph.values) {
      morphConstructs.add(entry.lemma);
      final xp = entry.points;

      if (xp >= 0 && xp <= 50) {
        morphSmallXP.add(entry.lemma);
      } else if (xp >= 51 && xp <= 200) {
        morphMediumXP.add(entry.lemma);
      } else if (xp >= 201 && xp <= 500) {
        morphLargeXP.add(entry.lemma);
      } else if (xp >= 501) {
        morphHugeXP.add(entry.lemma);
      }

      final originalUsesCorrect = [];
      final originalUsesIncorrect = [];
      final systemUsesCorrect = [];
      final systemUsesIncorrect = [];

      for (final use in entry.cappedUses) {
        if (originalUseTypes.contains(use.useType)) {
          use.xp > 0
              ? originalUsesCorrect.add(use)
              : originalUsesIncorrect.add(use);
        } else {
          use.xp > 0
              ? systemUsesCorrect.add(use)
              : systemUsesIncorrect.add(use);
        }
      }

      // if >= 80% correct original uses
      if (originalUsesCorrect.length + originalUsesIncorrect.length > 0) {
        final percentCorrect =
            originalUsesCorrect.length /
            (originalUsesCorrect.length + originalUsesIncorrect.length);
        if (percentCorrect >= 0.8) {
          morphCorrectOriginal.add(entry.lemma);
        } else {
          morphIncorrectOriginal.add(entry.lemma);
        }

        if (systemUsesCorrect.length + systemUsesIncorrect.length > 0) {
          final percentCorrectSystem =
              systemUsesCorrect.length /
              (systemUsesCorrect.length + systemUsesIncorrect.length);
          if (percentCorrectSystem >= 0.8) {
            morphCorrectSystem.add(entry.lemma);
          } else {
            morphIncorrectSystem.add(entry.lemma);
          }
        }
      }
    }

    return SpaceAnalyticsSummaryModel(
      username: username,
      dataAvailable: true,
      level: level,
      totalXP: totalXP,
      numLemmas: uniqueVocabCount,
      numLemmasUsedCorrectly: vocabUsedCorrectly,
      numLemmasUsedIncorrectly: vocabUsedIncorrectly,
      numLemmasSmallXP: vocabSmallXP,
      numLemmasMediumXP: vocabMediumXP,
      numLemmasLargeXP: vocabLargeXP,
      numMorphConstructs: uniqueMorphCount,
      listMorphConstructs: morphConstructs,
      listMorphSmallXP: morphSmallXP,
      listMorphMediumXP: morphMediumXP,
      listMorphLargeXP: morphLargeXP,
      listMorphHugeXP: morphHugeXP,
      listMorphConstructsUsedCorrectlyOriginal: morphCorrectOriginal,
      listMorphConstructsUsedIncorrectlyOriginal: morphIncorrectOriginal,
      listMorphConstructsUsedCorrectlySystem: morphCorrectSystem,
      listMorphConstructsUsedIncorrectlySystem: morphIncorrectSystem,
      numMessagesSent: sentEventIds.length,
      numWordsTyped: numWordsTyped,
      numChoicesCorrect: numChoicesCorrect,
      numChoicesIncorrect: numChoicesIncorrect,
      numCompletedActivities: numCompletedActivities,
    );
  }

  // static SpaceAnalyticsSummaryModel fromConstructListModel(
  //   String userID,
  //   ConstructListModel? model,
  //   int numCompletedActivities,
  //   String Function(ConstructUses) getCopy,
  //   BuildContext context,
  // ) {
  //   final vocabLemmas = model != null
  //       ? LemmasToUsesWrapper(
  //           model.lemmasToUses(type: ConstructTypeEnum.vocab),
  //         )
  //       : null;
  //   final morphLemmas = model != null
  //       ? LemmasToUsesWrapper(
  //           model.lemmasToUses(type: ConstructTypeEnum.morph),
  //         )
  //       : null;

  //   final List<String> correctOriginalUseLemmas = [];
  //   final List<String> correctSystemUseLemmas = [];
  //   final List<String> incorrectOriginalUseLemmas = [];
  //   final List<String> incorrectSystemUseLemmas = [];

  //   if (morphLemmas != null) {
  //     final originalWrittenUses = morphLemmas.lemmasByPercent(
  //       filter: (use) =>
  //           use.useType == ConstructUseTypeEnum.wa ||
  //           use.useType == ConstructUseTypeEnum.ga ||
  //           use.useType == ConstructUseTypeEnum.ta,
  //       percent: 0.8,
  //       context: context,
  //     );

  //     correctOriginalUseLemmas.addAll(originalWrittenUses.over);
  //     incorrectOriginalUseLemmas.addAll(originalWrittenUses.under);

  //     final systemGeneratedUses = morphLemmas.lemmasByPercent(
  //       filter: (use) =>
  //           use.useType != ConstructUseTypeEnum.wa &&
  //           use.useType != ConstructUseTypeEnum.ga &&
  //           use.useType != ConstructUseTypeEnum.ta &&
  //           use.useType != ConstructUseTypeEnum.unk &&
  //           use.xp != 0,
  //       percent: 0.8,
  //       context: context,
  //     );

  //     correctSystemUseLemmas.addAll(systemGeneratedUses.over);
  //     incorrectSystemUseLemmas.addAll(systemGeneratedUses.under);
  //   }

  //   final vocabLemmasCorrect = vocabLemmas?.lemmasByCorrectUse();

  //   int? numWordsTyped;
  //   int? numChoicesCorrect;
  //   int? numChoicesIncorrect;
  //   if (model != null) {
  //     numWordsTyped = 0;
  //     numChoicesCorrect = 0;
  //     numChoicesIncorrect = 0;
  //     for (final use in model.uses) {
  //       if (use.useType.summaryEnumType ==
  //           SpaceAnalyticsSummaryEnum.numWordsTyped) {
  //         numWordsTyped = numWordsTyped! + 1;
  //       } else if (use.useType.summaryEnumType ==
  //           SpaceAnalyticsSummaryEnum.numChoicesCorrect) {
  //         numChoicesCorrect = numChoicesCorrect! + 1;
  //       } else if (use.useType.summaryEnumType ==
  //           SpaceAnalyticsSummaryEnum.numChoicesIncorrect) {
  //         numChoicesIncorrect = numChoicesIncorrect! + 1;
  //       }
  //     }
  //   }

  //   final numMessageSent = model?.uses
  //       .where((use) => use.useType.sentByUser)
  //       .map((use) => use.metadata.eventId)
  //       .toSet()
  //       .length;

  //   return SpaceAnalyticsSummaryModel(
  //     username: userID,
  //     dataAvailable: model != null,
  //     level: model?.level,
  //     totalXP: model?.totalXP,
  //     numLemmas: model?.numConstructs(ConstructTypeEnum.vocab),
  //     numLemmasUsedCorrectly: vocabLemmasCorrect?.over.length,
  //     numLemmasUsedIncorrectly: vocabLemmasCorrect?.under.length,
  //     numLemmasSmallXP:
  //         vocabLemmas?.thresholdedLemmas(start: 0, end: 30).length,
  //     numLemmasMediumXP:
  //         vocabLemmas?.thresholdedLemmas(start: 31, end: 200).length,
  //     numLemmasLargeXP: vocabLemmas?.thresholdedLemmas(start: 201).length,
  //     numMorphConstructs: model?.numConstructs(ConstructTypeEnum.morph),
  //     listMorphConstructs: morphLemmas?.lemmasToUses.entries
  //         .map((entry) => getCopy(entry.value.first))
  //         .toList(),
  //     listMorphConstructsUsedCorrectlyOriginal: correctOriginalUseLemmas,
  //     listMorphConstructsUsedIncorrectlyOriginal: incorrectOriginalUseLemmas,
  //     listMorphConstructsUsedCorrectlySystem: correctSystemUseLemmas,
  //     listMorphConstructsUsedIncorrectlySystem: incorrectSystemUseLemmas,
  //     listMorphSmallXP: morphLemmas?.thresholdedLemmas(
  //       start: 0,
  //       end: 50,
  //       getCopy: getCopy,
  //     ),
  //     listMorphMediumXP: morphLemmas?.thresholdedLemmas(
  //       start: 51,
  //       end: 200,
  //       getCopy: getCopy,
  //     ),
  //     listMorphLargeXP: morphLemmas?.thresholdedLemmas(
  //       start: 201,
  //       end: 500,
  //       getCopy: getCopy,
  //     ),
  //     listMorphHugeXP: morphLemmas?.thresholdedLemmas(
  //       start: 501,
  //       getCopy: getCopy,
  //     ),
  //     numMessagesSent: numMessageSent,
  //     numWordsTyped: numWordsTyped,
  //     numChoicesCorrect: numChoicesCorrect,
  //     numChoicesIncorrect: numChoicesIncorrect,
  //     numCompletedActivities: numCompletedActivities,
  //   );
  // }

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
      case SpaceAnalyticsSummaryEnum.numCompletedActivities:
        return numCompletedActivities;
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
      'numCompletedActivities': numCompletedActivities,
    };
  }
}
