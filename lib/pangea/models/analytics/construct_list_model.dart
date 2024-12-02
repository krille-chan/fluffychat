import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    try {
      _updateConstructMap(newUses);
      _updateConstructList();
      _updateCategoriesToUses();
      _updateMetrics();
    } catch (err, s) {
      ErrorHandler.logError(e: "Failed to update analytics: $err", s: s);
    }
  }

  int _sortConstructs(ConstructUses a, ConstructUses b) {
    final comp = b.points.compareTo(a.points);
    if (comp != 0) return comp;
    return a.lemma.compareTo(b.lemma);
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

    final Map<String, List<ConstructUses>> groupedMap = {};
    for (final use in constructList()) {
      // Step 1: Create a key based on type, lemma, and category
      String key = use.id.string;

      // If category is "other", find a more specific group if it exists
      if (use.category.toLowerCase() == 'other') {
        final String specificKeyPrefix = use.id.partialKey;
        final String existingSpecificKey = groupedMap.keys.firstWhere(
          (k) => k.startsWith(specificKeyPrefix) && !k.endsWith('other'),
          orElse: () => '',
        );

        if (existingSpecificKey.isNotEmpty) {
          key = existingSpecificKey;
        }
      }

      // Add the object to the grouped map
      groupedMap.putIfAbsent(key, () => []).add(use);
    }

    // Step 2: Reorganize by category only
    final Map<String, List<ConstructUses>> groupedByCategory = {};
    for (final entry in groupedMap.entries) {
      // Extract the category part from the key (assuming it's at the end)
      final category = entry.key.split('-').last;

      // Add each item in this entry to the groupedByCategory map under the single category key
      groupedByCategory.putIfAbsent(category, () => []).addAll(entry.value);
    }
    final others = groupedByCategory.entries
        .where((entry) => entry.key.toLowerCase() == 'other')
        .toList();
    if (others.length > 1) {
      ErrorHandler.logError(
        e: "More than one 'other' category in groupedByCategory",
        data: {
          "others": others.map((entry) {
            List<String> useKeys =
                entry.value.map((uses) => uses.id.string).toList();
            if (useKeys.length > 10) {
              useKeys = useKeys.sublist(0, 10);
            }
            ("${entry.key}: $useKeys");
          }).toList(),
        },
      );
    }
    _categoriesToUses = groupedByCategory;
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

    if (totalXP < 0) {
      totalXP = 0;
    }

    // Don't call .floor() if NaN or Infinity
    // https://pangea-chat.sentry.io/issues/6052871310
    final double levelCalculation = 1 + sqrt((1 + 8 * totalXP / 100) / 2);
    if (!levelCalculation.isNaN && levelCalculation.isFinite) {
      level = levelCalculation.floor();
    } else {
      level = 1;
      Sentry.addBreadcrumb(
        Breadcrumb(
          data: {
            "totalXP": totalXP,
            "prevXP": prevXP,
            "level": levelCalculation,
          },
        ),
      );
      ErrorHandler.logError(e: "Calculated level in Nan or Infinity");
    }
  }

  ConstructUses? getConstructUses(ConstructIdentifier identifier) {
    final partialKey = "${identifier.lemma}-${identifier.type.string}";

    if (_constructMap.containsKey(identifier.string)) {
      // try to get construct use entry with full ID key
      return _constructMap[identifier.string];
    } else if (identifier.category.toLowerCase() == "other") {
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
                entry.key.startsWith(partialKey) &&
                entry.key.toLowerCase().endsWith("other"),
          )
          ?.value;
    }
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
