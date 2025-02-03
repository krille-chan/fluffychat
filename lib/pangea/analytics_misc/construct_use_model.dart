import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';

/// One lemma and a list of construct uses for that lemma
class ConstructUses {
  final List<OneConstructUse> uses;
  final ConstructTypeEnum constructType;
  final String lemma;
  final String? _category;
  DateTime? _lastUsed;

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

  DateTime? get lastUsed {
    if (_lastUsed != null) return _lastUsed;
    final lastUse = uses.fold<DateTime?>(null, (DateTime? last, use) {
      if (last == null) return use.timeStamp;
      return use.timeStamp.isAfter(last) ? use.timeStamp : last;
    });
    return _lastUsed = lastUse;
  }

  void setLastUsed(DateTime time) {
    _lastUsed = time;
  }

  String get category {
    if (_category == null || _category!.isEmpty) return "other";
    return _category!.toLowerCase();
  }

  bool get hasCorrectUse => uses.any((use) => use.pointValue > 0);
  bool get hasIncorrectUse => uses.any((use) => use.pointValue < 0);

  ConstructIdentifier get id => ConstructIdentifier(
        lemma: lemma,
        type: constructType,
        category: category,
      );

  Map<String, dynamic> toJson() {
    final json = {
      'construct_id': id.toJson(),
      'xp': points,
      'last_used': lastUsed?.toIso8601String(),

      /// NOTE - sent to server as just the useTypes
      'uses': uses.map((e) => e.useType.string).toList(),
    };
    return json;
  }

  /// Get the lemma category, based on points
  ConstructLevelEnum get lemmaCategory {
    if (points < AnalyticsConstants.xpForGreens) {
      return ConstructLevelEnum.seeds;
    } else if (points >= AnalyticsConstants.xpForFlower) {
      return ConstructLevelEnum.flowers;
    }
    return ConstructLevelEnum.greens;
  }
}
