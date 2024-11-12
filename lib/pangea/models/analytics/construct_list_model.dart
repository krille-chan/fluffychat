import 'dart:math';

import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';

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
    level = 1 + sqrt((1 + 8 * totalXP / 100) / 2).floor();
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

/// One lemma and a list of construct uses for that lemma
class ConstructUses {
  final List<OneConstructUse> uses;
  final ConstructTypeEnum constructType;
  final String lemma;
  final String? _category;

  ConstructUses({
    required this.uses,
    required this.constructType,
    required this.lemma,
    required category,
  }) : _category = category;

  // Total points for all uses of this lemma
  int get points {
    return uses.fold<int>(
      0,
      (total, use) => total + use.useType.pointValue,
    );
  }

  DateTime? _lastUsed;
  DateTime? get lastUsed {
    if (_lastUsed != null) return _lastUsed;
    final lastUse = uses.fold<DateTime?>(null, (DateTime? last, use) {
      if (last == null) return use.timeStamp;
      return use.timeStamp.isAfter(last) ? use.timeStamp : last;
    });
    return _lastUsed = lastUse;
  }

  String get category => _category ?? "Other";
}
