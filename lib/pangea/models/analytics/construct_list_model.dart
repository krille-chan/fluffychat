import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';

/// A wrapper around a list of [OneConstructUse]s, used to simplify
/// the process of filtering / sorting / displaying the events.
/// Takes a construct type and a list of events
class ConstructListModel {
  final ConstructTypeEnum? type;

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  final Map<String, ConstructUses> _constructMap = {};

  /// Storing this to avoid re-running the sort operation each time this needs to
  /// be accessed. It contains the same information as _constructMap, but sorted.
  List<ConstructUses> constructList = [];

  ConstructListModel({
    required this.type,
    required List<OneConstructUse> uses,
  }) {
    updateConstructs(uses);
  }

  /// Given a list of new construct uses, update the map of construct
  /// IDs to ConstructUses and re-sort the list of ConstructUses
  void updateConstructs(List<OneConstructUse> newUses) {
    final List<OneConstructUse> filteredUses = newUses
        .where((use) => use.constructType == type || type == null)
        .toList();
    _updateConstructMap(filteredUses);
    _updateConstructList();
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
    constructList = _constructMap.values.toList();
    constructList.sort((a, b) {
      final comp = b.uses.length.compareTo(a.uses.length);
      if (comp != 0) return comp;
      return a.lemma.compareTo(b.lemma);
    });
  }

  ConstructUses? getConstructUses(ConstructIdentifier identifier) {
    return _constructMap[identifier.string];
  }

  List<ConstructUses> get constructListWithPoints =>
      constructList.where((constructUse) => constructUse.points > 0).toList();

  /// All unique lemmas used in the construct events with non-zero points
  List<String> get lemmasWithPoints =>
      constructListWithPoints.map((e) => e.lemma).toSet().toList();

  Map<String, List<ConstructUses>> get categoriesToUses {
    final Map<String, List<ConstructUses>> categoriesMap = {};
    for (final use in constructListWithPoints) {
      categoriesMap[use.category] ??= [];
      categoriesMap[use.category]!.add(use);
    }
    return categoriesMap;
  }

  int get maxXPPerLemma =>
      type?.maxXPPerLemma ?? ConstructTypeEnum.vocab.maxXPPerLemma;

  /// The total number of points for all uses of this construct type
  int get points {
    int totalPoints = 0;
    for (final constructUse in _constructMap.values.toList()) {
      totalPoints += constructUse.points;
    }
    return totalPoints;
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
