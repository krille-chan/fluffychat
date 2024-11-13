import 'dart:math';

import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';

/// A wrapper around a list of [OneConstructUse]s, used to simplify
/// the process of filtering / sorting / displaying the events.
class ConstructListModel {
  void dispose() {
    _constructMap = {};
    _constructList = [];
    prevXP = 0;
    totalXP = 0;
    level = 0;
    vocabLemmas = 0;
    grammarLemmas = 0;
  }

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  Map<String, ConstructUses> _constructMap = {};

  /// Storing this to avoid re-running the sort operation each time this needs to
  /// be accessed. It contains the same information as _constructMap, but sorted.
  List<ConstructUses> _constructList = [];

  /// A map of categories to lists of ConstructUses
  Map<String, List<ConstructUses>> _categoriesToUses = {};

  /// Analytics data consumed by widgets. Updated each time new analytics come in.
  int prevXP = 0;
  int totalXP = 0;
  int level = 0;
  int vocabLemmas = 0;
  int grammarLemmas = 0;

  ConstructListModel({
    required List<OneConstructUse> uses,
  }) {
    updateConstructs(uses);
  }

  /// Given a list of new construct uses, update the map of construct
  /// IDs to ConstructUses and re-sort the list of ConstructUses
  void updateConstructs(List<OneConstructUse> newUses) {
    _updateConstructMap(newUses);
    _updateConstructList();
    _updateCategoriesToUses();
    _updateMetrics();
  }

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  void _updateConstructMap(final List<OneConstructUse> newUses) {
    for (final use in newUses) {
      if (use.lemma == null) continue;
      final currentUses = _constructMap[use.identifier.string] ??
          ConstructUses(
            uses: [],
            constructType: use.constructType,
            lemma: use.lemma!,
            category: use.category,
          );
      currentUses.uses.add(use);
      currentUses.setLastUsed(use.timeStamp);
      _constructMap[use.identifier.string] = currentUses;
    }
  }

  /// A list of ConstructUses, each of which contains a lemma and
  /// a list of uses, sorted by the number of uses
  void _updateConstructList() {
    // TODO check how expensive this is
    _constructList = _constructMap.values.toList();
    _constructList.sort((a, b) {
      final comp = b.uses.length.compareTo(a.uses.length);
      if (comp != 0) return comp;
      return a.lemma.compareTo(b.lemma);
    });
  }

  void _updateCategoriesToUses() {
    _categoriesToUses = {};
    for (final use in constructList()) {
      _categoriesToUses[use.category] ??= [];
      _categoriesToUses[use.category]!.add(use);
    }
  }

  void _updateMetrics() {
    vocabLemmas = constructList(type: ConstructTypeEnum.vocab)
        .map((e) => e.lemma)
        .toSet()
        .length;

    grammarLemmas = constructList(type: ConstructTypeEnum.morph)
        .map((e) => e.lemma)
        .toSet()
        .length;

    prevXP = totalXP;
    totalXP = _constructList.fold<int>(
      0,
      (total, construct) => total + construct.points,
    );

    // Don't call .floor() if NaN or Infinity
    // https://pangea-chat.sentry.io/issues/6052871310
    final double levelCalculation = 1 + sqrt((1 + 8 * totalXP / 100) / 2);
    if (!levelCalculation.isNaN && levelCalculation.isFinite) {
      level = levelCalculation.floor();
    } else {
      level = 0;
      ErrorHandler.logError(
        e: "Calculated level in Nan or Infinity",
        data: {
          "totalXP": totalXP,
          "prevXP": prevXP,
          "level": levelCalculation,
        },
      );
    }
  }

  ConstructUses? getConstructUses(ConstructIdentifier identifier) {
    return _constructMap[identifier.string];
  }

  List<ConstructUses> constructList({ConstructTypeEnum? type}) => _constructList
      .where(
        (constructUse) =>
            constructUse.points > 0 &&
            (type == null || constructUse.constructType == type),
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
}
