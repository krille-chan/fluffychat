import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';

/// A wrapper around a list of [OneConstructUse]s, used to simplify
/// the process of filtering / sorting / displaying the events.
/// Takes a construct type and a list of events
class ConstructListModel {
  final ConstructTypeEnum? type;
  final List<OneConstructUse> _uses;
  List<ConstructUses>? _constructList;
  List<ConstructUseTypeUses>? _typedConstructs;

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  Map<String, ConstructUses>? _constructMap;

  ConstructListModel({
    required this.type,
    required List<OneConstructUse> uses,
  }) : _uses = uses;

  List<OneConstructUse> get uses =>
      _uses.where((use) => use.constructType == type || type == null).toList();

  /// All unique lemmas used in the construct events
  List<String> get lemmas => constructList.map((e) => e.lemma).toSet().toList();

  /// All unique lemmas used in the construct events with non-zero points
  List<String> get lemmasWithPoints =>
      constructListWithPoints.map((e) => e.lemma).toSet().toList();

  /// A map of lemmas to ConstructUses, each of which contains a lemma
  /// key = lemmma + constructType.string, value = ConstructUses
  void _buildConstructMap() {
    final Map<String, List<OneConstructUse>> lemmaToUses = {};
    for (final use in uses) {
      if (use.lemma == null) continue;
      lemmaToUses[use.lemma! + use.constructType.string] ??= [];
      lemmaToUses[use.lemma! + use.constructType.string]!.add(use);
    }

    _constructMap = lemmaToUses.map(
      (key, value) => MapEntry(
        key,
        ConstructUses(
          uses: value,
          constructType: value.first.constructType,
          lemma: value.first.lemma!,
        ),
      ),
    );
  }

  ConstructUses? getConstructUses(String lemma, ConstructTypeEnum type) {
    if (_constructMap == null) _buildConstructMap();
    return _constructMap![lemma + type.string];
  }

  /// A list of ConstructUses, each of which contains a lemma and
  /// a list of uses, sorted by the number of uses
  List<ConstructUses> get constructList {
    // the list of uses doesn't change so we don't have to re-calculate this
    if (_constructList != null) return _constructList!;

    if (_constructMap == null) _buildConstructMap();

    _constructList = _constructMap!.values.toList();

    _constructList!.sort((a, b) {
      final comp = b.uses.length.compareTo(a.uses.length);
      if (comp != 0) return comp;
      return a.lemma.compareTo(b.lemma);
    });

    return _constructList!;
  }

  List<ConstructUses> get constructListWithPoints =>
      constructList.where((constructUse) => constructUse.points > 0).toList();

  get maxXPPerLemma {
    return type != null
        ? type!.maxXPPerLemma
        : ConstructTypeEnum.vocab.maxXPPerLemma;
  }

  /// A list of ConstructUseTypeUses, each of which
  /// contains a lemma, a use type, and a list of uses
  List<ConstructUseTypeUses> get typedConstructs {
    if (_typedConstructs != null) return _typedConstructs!;
    final List<ConstructUseTypeUses> typedConstructs = [];
    for (final construct in constructList) {
      final typeToUses = <ConstructUseTypeEnum, List<OneConstructUse>>{};
      for (final use in construct.uses) {
        typeToUses[use.useType] ??= [];
        typeToUses[use.useType]!.add(use);
      }
      for (final typeEntry in typeToUses.entries) {
        typedConstructs.add(
          ConstructUseTypeUses(
            lemma: construct.lemma,
            constructType: typeEntry.value.first.constructType,
            useType: typeEntry.key,
            uses: typeEntry.value,
          ),
        );
      }
    }
    return typedConstructs;
  }

  /// The total number of points for all uses of this construct type
  int get points {
    // double totalPoints = 0;
    return typedConstructs.fold<int>(
      0,
      (total, typedConstruct) =>
          total +
          typedConstruct.useType.pointValue * typedConstruct.uses.length,
    );
    // Commenting this out for now
    // Minimize the amount of points given for repeated uses of the same lemma.
    // i.e., if a lemma is used 4 times without assistance, the point value for
    // a use without assistance is 3. So the points would be
    // 3/1 + 3/2 + 3/3 + 3/4 = 3 + 1.5 + 1 + 0.75 = 5.25 (instead of 12)
    // for (final typedConstruct in typedConstructs) {
    //   final pointValue = typedConstruct.useType.pointValue;
    //   double calc = 0.0;
    //   for (int k = 1; k <= typedConstruct.uses.length; k++) {
    //     calc += pointValue / k;
    //   }
    //   totalPoints += calc;
    // }
    // return totalPoints.round();
  }
}

/// One lemma and a list of construct uses for that lemma
class ConstructUses {
  final List<OneConstructUse> uses;
  final ConstructTypeEnum constructType;
  final String lemma;

  ConstructUses({
    required this.uses,
    required this.constructType,
    required this.lemma,
  });

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
}

/// One lemma, a use type, and a list of uses
/// for that lemma and use type
class ConstructUseTypeUses {
  final ConstructUseTypeEnum useType;
  final ConstructTypeEnum constructType;
  final String lemma;
  final List<OneConstructUse> uses;

  ConstructUseTypeUses({
    required this.useType,
    required this.constructType,
    required this.lemma,
    required this.uses,
  });
}
