import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';

/// A wrapper around a list of [OneConstructUse]s, used to simplify
/// the process of filtering / sorting / displaying the events.
class ConstructListModel {
  final List<OneConstructUse> _uses = [];
  List<OneConstructUse> get uses => _uses;
  List<OneConstructUse> get truncatedUses => _uses.take(100).toList();

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemma + constructType.string, value = ConstructUses
  final Map<String, ConstructUses> _constructMap = {};

  /// Storing this to avoid re-running the sort operation each time this needs to
  /// be accessed. It contains the same information as _constructMap, but sorted.
  List<ConstructUses> _constructList = [];

  /// A map of categories to lists of ConstructUses
  Map<String, List<ConstructUses>> _categoriesToUses = {};

  /// A list of unique vocab lemmas
  List<String> vocabLemmasList = [];

  /// A list of unique grammar lemmas
  List<String> grammarLemmasList = [];

  /// [D] is the "compression factor". It determines how quickly
  /// or slowly the level grows relative to XP
  final double D = 1500;

  List<ConstructIdentifier> unlockedLemmas(
    ConstructTypeEnum type, {
    int threshold = 0,
  }) {
    final constructs = constructList(type: type);
    final List<ConstructIdentifier> unlocked = [];
    final constructsList =
        type == ConstructTypeEnum.vocab ? vocabLemmasList : grammarLemmasList;

    for (final lemma in constructsList) {
      final matches = constructs.where((m) => m.lemma == lemma);
      final totalPoints = matches.fold<int>(
        0,
        (total, match) => total + match.points,
      );
      if (totalPoints > threshold) {
        unlocked.add(matches.first.id);
      }
    }
    return unlocked;
  }

  /// Analytics data consumed by widgets. Updated each time new analytics come in.
  int prevXP = 0;
  int totalXP = 0;
  int level = 0;

  ConstructListModel({
    required List<OneConstructUse> uses,
    int offset = 0,
  }) {
    updateConstructs(uses, offset);
  }

  int get totalLemmas => vocabLemmasList.length + grammarLemmasList.length;
  int get vocabLemmas => vocabLemmasList.length;
  int get grammarLemmas => grammarLemmasList.length;
  List<String> get lemmasList => vocabLemmasList + grammarLemmasList;

  /// Given a list of new construct uses, update the map of construct
  /// IDs to ConstructUses and re-sort the list of ConstructUses
  void updateConstructs(List<OneConstructUse> newUses, int offset) {
    try {
      _updateUsesList(newUses);
      _updateConstructMap(newUses);
      _updateConstructList();
      _updateCategoriesToUses();
      _updateMetrics(offset);
    } catch (err, s) {
      ErrorHandler.logError(
        e: "Failed to update analytics: $err",
        s: s,
        data: {
          "newUses": newUses.map((e) => e.toJson()),
        },
      );
    }
  }

  int _sortConstructs(ConstructUses a, ConstructUses b) {
    final comp = b.points.compareTo(a.points);
    if (comp != 0) return comp;
    return a.lemma.compareTo(b.lemma);
  }

  void _updateUsesList(List<OneConstructUse> newUses) {
    newUses.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    _uses.insertAll(0, newUses);
  }

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  void _updateConstructMap(final List<OneConstructUse> newUses) {
    for (final use in newUses) {
      final currentUses = _constructMap[use.identifier.string] ??
          ConstructUses(
            uses: [],
            constructType: use.constructType,
            lemma: use.lemma,
            category: use.category,
          );
      currentUses.uses.add(use);
      currentUses.setLastUsed(use.timeStamp);
      _constructMap[use.identifier.string] = currentUses;
    }

    final broadKeys = _constructMap.keys.where((key) => key.endsWith('other'));
    final replacedKeys = [];
    for (final broadKey in broadKeys) {
      final specificKeyPrefix = broadKey.split("-").first;
      final specificKey = _constructMap.keys.firstWhereOrNull(
        (key) =>
            key != broadKey &&
            key.startsWith(specificKeyPrefix) &&
            !key.endsWith('other'),
      );
      if (specificKey == null) continue;
      final broadConstructEntry = _constructMap[broadKey];
      final specificConstructEntry = _constructMap[specificKey];
      specificConstructEntry!.uses.addAll(broadConstructEntry!.uses);
      _constructMap[specificKey] = specificConstructEntry;
      replacedKeys.add(broadKey);
    }

    for (final key in replacedKeys) {
      _constructMap.remove(key);
    }
  }

  /// A list of ConstructUses, each of which contains a lemma and
  /// a list of uses, sorted by the number of uses
  void _updateConstructList() {
    // TODO check how expensive this is
    _constructList = _constructMap.values.toList();
    _constructList.sort(_sortConstructs);
  }

  void _updateCategoriesToUses() {
    _categoriesToUses = {};
    for (final ConstructUses use in constructList()) {
      final category = use.category;
      _categoriesToUses.putIfAbsent(category, () => []);
      _categoriesToUses[category]!.add(use);
    }
  }

  void _updateMetrics(int offset) {
    vocabLemmasList = constructList(type: ConstructTypeEnum.vocab)
        .map((e) => e.lemma)
        .toSet()
        .toList();

    grammarLemmasList = constructList(type: ConstructTypeEnum.morph)
        .map((e) => e.lemma)
        .toSet()
        .toList();

    prevXP = totalXP;
    totalXP = (_constructList.fold<int>(
          0,
          (total, construct) => total + construct.points,
        )) +
        offset;

    if (totalXP < 0) {
      totalXP = 0;
    }
    level = calculateLevelWithXp(totalXP);
  }

  int calculateLevelWithXp(int totalXP) {
    final doubleScore = (1 + sqrt((1 + (8.0 * totalXP / D)) / 2.0));
    if (!doubleScore.isNaN && doubleScore.isFinite) {
      return doubleScore.floor();
    } else {
      ErrorHandler.logError(
        e: "Calculated level in Nan or Infinity",
        data: {
          "totalXP": totalXP,
          "prevXP": prevXP,
          "level": doubleScore,
        },
      );
      return 1;
    }
  }

  int calculateXpWithLevel(int level) {
    // If level <= 1, XP should be 0 or negative by this math.
    // In practice, you might clamp it to 0:
    if (level <= 1) {
      return 0;
    }

    // Convert level to double for the math
    final double lc = level.toDouble();

    // XP from the inverse formula:
    final double xpDouble = (D / 8.0) * (2.0 * pow(lc - 1.0, 2.0) - 1.0);

    // Floor or clamp to ensure non-negative.
    final int xp = xpDouble.floor();
    return (xp < 0) ? 0 : xp;
  }

  // TODO; make this non-nullable, returning empty if not found
  ConstructUses? getConstructUses(ConstructIdentifier identifier) {
    final partialKey = "${identifier.lemma}-${identifier.type.string}";

    if (_constructMap.containsKey(identifier.string)) {
      // try to get construct use entry with full ID key
      return _constructMap[identifier.string];
    } else if (identifier.category == "other") {
      // if the category passed to this function is "other", return the first
      // construct use entry that starts with the partial key
      return _constructMap.entries
          .firstWhereOrNull((entry) => entry.key.startsWith(partialKey))
          ?.value;
    } else {
      // if the category passed to this function is not "other", return the first
      // construct use entry that starts with the partial key and ends with "other"
      return _constructMap.entries
          .firstWhereOrNull(
            (entry) =>
                entry.key.startsWith(partialKey) && entry.key.endsWith("other"),
          )
          ?.value;
    }
  }

  List<ConstructUses> getConstructUsesByLemma(String lemma) {
    return _constructList.where((constructUse) {
      return constructUse.lemma == lemma;
    }).toList();
  }

  List<ConstructUses> constructList({ConstructTypeEnum? type}) => _constructList
      .where(
        (constructUse) => type == null || constructUse.constructType == type,
      )
      .toList();

  Map<String, List<ConstructUses>> categoriesToUses({ConstructTypeEnum? type}) {
    if (type == null) return _categoriesToUses;
    final entries = _categoriesToUses.entries.toList();
    return Map.fromEntries(
      entries.map((entry) {
        return MapEntry(
          entry.key,
          entry.value.where((use) => use.constructType == type).toList(),
        );
      }).where((entry) => entry.value.isNotEmpty),
    );
  }

  // uses where points < AnalyticConstants.xpForGreens
  List<ConstructUses> get seeds => _constructList
      .where(
        (use) => use.points < AnalyticsConstants.xpForGreens,
      )
      .toList();

  List<ConstructUses> get greens => _constructList
      .where(
        (use) =>
            use.points >= AnalyticsConstants.xpForGreens &&
            use.points < AnalyticsConstants.xpForFlower,
      )
      .toList();

  List<ConstructUses> get flowers => _constructList
      .where(
        (use) => use.points >= AnalyticsConstants.xpForFlower,
      )
      .toList();
  // Not storing this for now to reduce memory load
  // It's only used by downloads, so doesn't need to be accessible on the fly
  Map<String, List<ConstructUses>> lemmasToUses({
    ConstructTypeEnum? type,
  }) {
    final Map<String, List<ConstructUses>> lemmasToUses = {};
    final constructs = constructList(type: type);
    for (final ConstructUses use in constructs) {
      final lemma = use.lemma;
      lemmasToUses.putIfAbsent(lemma, () => []);
      lemmasToUses[lemma]!.add(use);
    }
    return lemmasToUses;
  }
}

class LemmasToUsesWrapper {
  final Map<String, List<ConstructUses>> lemmasToUses;

  LemmasToUsesWrapper(this.lemmasToUses);

  Map<String, List<OneConstructUse>> lemmasToFilteredUses(
    bool Function(OneConstructUse) filter,
  ) {
    final Map<String, List<OneConstructUse>> lemmasToOneConstructUses = {};
    for (final entry in lemmasToUses.entries) {
      final lemma = entry.key;
      final uses = entry.value;
      lemmasToOneConstructUses[lemma] =
          uses.expand((use) => use.uses).toList().where(filter).toList();
    }
    return lemmasToOneConstructUses;
  }

  LemmasOverUnderList lemmasByPercent({
    required bool Function(OneConstructUse) filter,
    required double percent,
    required BuildContext context,
  }) {
    final List<String> correctUseLemmas = [];
    final List<String> incorrectUseLemmas = [];

    final uses = lemmasToFilteredUses(filter);
    for (final entry in uses.entries) {
      if (entry.value.isEmpty) continue;
      final List<OneConstructUse> correctUses = [];
      final List<OneConstructUse> incorrectUses = [];

      final lemma = getGrammarCopy(
            category: entry.value.first.category,
            lemma: entry.key,
            context: context,
          ) ??
          entry.key;
      final uses = entry.value.toList();

      for (final use in uses) {
        use.xp > 0 ? correctUses.add(use) : incorrectUses.add(use);
      }

      final totalUses = correctUses.length + incorrectUses.length;
      final percent = totalUses == 0 ? 0 : correctUses.length / totalUses;

      percent > 0.8
          ? correctUseLemmas.add(lemma)
          : incorrectUseLemmas.add(lemma);
    }

    return LemmasOverUnderList(
      over: correctUseLemmas,
      under: incorrectUseLemmas,
    );
  }

  /// Return an object containing two lists, one of lemmas with
  /// any correct uses and one of lemmas no correct uses
  LemmasOverUnderList lemmasByCorrectUse({
    String Function(ConstructUses)? getCopy,
  }) {
    final List<String> correctLemmas = [];
    final List<String> incorrectLemmas = [];
    for (final entry in lemmasToUses.entries) {
      final lemma = entry.key;
      final constructUses = entry.value;
      final copy = getCopy?.call(constructUses.first) ?? lemma;
      if (constructUses.any((use) => use.hasCorrectUse)) {
        correctLemmas.add(copy);
      } else {
        incorrectLemmas.add(copy);
      }
    }
    return LemmasOverUnderList(over: correctLemmas, under: incorrectLemmas);
  }

  int totalXP(String lemma) {
    final uses = lemmasToUses[lemma];
    if (uses == null) return 0;
    if (uses.length == 1) return uses.first.points;
    return lemmasToUses[lemma]!.fold<int>(
      0,
      (total, use) => total + use.points,
    );
  }

  List<String> thresholdedLemmas({
    required int start,
    int? end,
    String Function(ConstructUses)? getCopy,
  }) {
    final filteredList = lemmasToUses.entries.where((entry) {
      final xp = totalXP(entry.key);
      return xp >= start && (end == null || xp <= end);
    });
    return filteredList
        .map((entry) => getCopy?.call(entry.value.first) ?? entry.key)
        .toList();
  }
}

class LemmasOverUnderList {
  final List<String> over;
  final List<String> under;

  LemmasOverUnderList({
    required this.over,
    required this.under,
  });
}
