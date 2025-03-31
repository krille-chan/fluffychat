import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record_repo.dart';

/// Picks which tokens to do activities on and what types of activities to do
/// Caches result so that we don't have to recompute it
/// Most importantly, we can't do this in the state of a message widget because the state is disposed of and recreated
/// If we decided that the first token should have a hidden word listening, we need to remember that
/// Otherwise, the user might leave the chat, return, and see a different word hidden

class PracticeTarget {
  /// this is the tokens involved in the activity
  /// for most, this will be a single token
  final List<PangeaToken> tokens;

  /// this is the type of activity to do on the tokens
  final ActivityTypeEnum activityType;

  /// this is only defined for morphId activities
  final MorphFeaturesEnum? morphFeature;

  final String userL2;

  PracticeTarget({
    required this.tokens,
    required this.activityType,
    required this.userL2,
    this.morphFeature,
  }) {
    if (ActivityTypeEnum.morphId == activityType && morphFeature == null) {
      throw Exception("morphFeature must be defined for morphId activities");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeTarget &&
        listEquals(other.tokens, tokens) &&
        other.activityType == activityType &&
        other.morphFeature == morphFeature &&
        other.userL2 == userL2;
  }

  @override
  int get hashCode =>
      tokens.hashCode ^
      activityType.hashCode ^
      morphFeature.hashCode ^
      userL2.hashCode;

  static PracticeTarget fromJson(Map<String, dynamic> json) {
    return PracticeTarget(
      tokens:
          (json['tokens'] as List).map((e) => PangeaToken.fromJson(e)).toList(),
      activityType: ActivityTypeEnum.values[json['activityType']],
      morphFeature: json['morphFeature'] == null
          ? null
          : MorphFeaturesEnum.values[json['morphFeature']],
      userL2: json['userL2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': tokens.map((e) => e.toJson()).toList(),
      'activityType': activityType.index,
      'morphFeature': morphFeature?.index,
      'userL2': userL2,
    };
  }

  //unique condensed deterministic key for local storage
  String get storageKey {
    return tokens.map((e) => e.text.content).join() +
        activityType.string +
        (morphFeature?.name ?? "");
  }

  PracticeRecord get record => PracticeRecordRepo.get(this);

  bool get isComplete {
    if (activityType == ActivityTypeEnum.morphId) {
      return record.completeResponses > 0;
    }

    return tokens.every(
      (t) => record.responses.any((res) => res.cId == t.vocabConstructID),
    );
  }
}
