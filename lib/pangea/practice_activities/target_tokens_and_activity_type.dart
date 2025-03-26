import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';

/// Picks which tokens to do activities on and what types of activities to do
/// Caches result so that we don't have to recompute it
/// Most importantly, we can't do this in the state of a message widget because the state is disposed of and recreated
/// If we decided that the first token should have a hidden word listening, we need to remember that
/// Otherwise, the user might leave the chat, return, and see a different word hidden

class TargetTokensAndActivityType {
  /// this is the tokens involved in the activity
  /// for most, this will be a single token
  final List<PangeaToken> tokens;
  final ActivityTypeEnum activityType;

  // this is only defined for morphId activities
  final MorphFeaturesEnum? morphFeature;

  TargetTokensAndActivityType({
    required this.tokens,
    required this.activityType,
    this.morphFeature,
  }) {
    if (ActivityTypeEnum.hiddenWordListening != activityType &&
        tokens.length != 1) {
      throw Exception("Only hiddenWordListening can have multiple tokens");
    }
    if (ActivityTypeEnum.morphId == activityType && morphFeature == null) {
      throw Exception("morphFeature must be defined for morphId activities");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TargetTokensAndActivityType &&
        listEquals(other.tokens, tokens) &&
        other.activityType == activityType &&
        other.morphFeature == morphFeature;
  }

  @override
  int get hashCode =>
      tokens.hashCode ^ activityType.hashCode ^ morphFeature.hashCode;

  static TargetTokensAndActivityType fromJson(Map<String, dynamic> json) {
    return TargetTokensAndActivityType(
      tokens:
          (json['tokens'] as List).map((e) => PangeaToken.fromJson(e)).toList(),
      activityType: ActivityTypeEnum.values[json['activityType']],
      morphFeature: json['morphFeature'] == null
          ? null
          : MorphFeaturesEnum.values[json['morphFeature']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': tokens.map((e) => e.toJson()).toList(),
      'activityType': activityType.index,
      'morphFeature': morphFeature?.index,
    };
  }
}
