import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';

// includes feedback text and the bad activity model
class ActivityQualityFeedback {
  final String feedbackText;
  final PracticeActivityModel badActivity;

  ActivityQualityFeedback({
    required this.feedbackText,
    required this.badActivity,
  });

  factory ActivityQualityFeedback.fromJson(Map<String, dynamic> json) {
    return ActivityQualityFeedback(
      feedbackText: json['feedback_text'] as String,
      badActivity: PracticeActivityModel.fromJson(
        json['bad_activity'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_text': feedbackText,
      'bad_activity': badActivity.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityQualityFeedback &&
        other.feedbackText == feedbackText &&
        other.badActivity == badActivity;
  }

  @override
  int get hashCode {
    return feedbackText.hashCode ^ badActivity.hashCode;
  }
}

class MessageActivityRequest {
  final String userL1;
  final String userL2;

  final String messageText;
  final List<PangeaToken> messageTokens;

  final List<PangeaToken> targetTokens;
  final ActivityTypeEnum targetType;
  final MorphFeaturesEnum? targetMorphFeature;

  final ActivityQualityFeedback? activityQualityFeedback;

  MessageActivityRequest({
    required this.userL1,
    required this.userL2,
    required this.messageText,
    required this.messageTokens,
    required this.activityQualityFeedback,
    required this.targetTokens,
    required this.targetType,
    required this.targetMorphFeature,
  }) {
    if (targetTokens.isEmpty) {
      throw Exception('Target tokens must not be empty');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_l1': userL1,
      'user_l2': userL2,
      'message_text': messageText,
      'message_tokens': messageTokens.map((e) => e.toJson()).toList(),
      'activity_quality_feedback': activityQualityFeedback?.toJson(),
      'target_tokens': targetTokens.map((e) => e.toJson()).toList(),
      'target_type': targetType.string,
      'target_morph_feature': targetMorphFeature,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageActivityRequest &&
        other.messageText == messageText &&
        other.targetType == targetType &&
        other.activityQualityFeedback?.feedbackText ==
            activityQualityFeedback?.feedbackText &&
        const ListEquality().equals(other.targetTokens, targetTokens) &&
        other.targetMorphFeature == targetMorphFeature;
  }

  @override
  int get hashCode {
    return messageText.hashCode ^
        targetType.hashCode ^
        activityQualityFeedback.hashCode ^
        targetTokens.hashCode ^
        targetMorphFeature.hashCode;
  }
}

class MessageActivityResponse {
  final PracticeActivityModel activity;

  MessageActivityResponse({
    required this.activity,
  });

  factory MessageActivityResponse.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('activity')) {
      Sentry.addBreadcrumb(Breadcrumb(data: {"json": json}));
      throw Exception('Activity not found in message activity response');
    }

    if (json['activity'] is! Map<String, dynamic>) {
      Sentry.addBreadcrumb(Breadcrumb(data: {"json": json}));
      throw Exception('Activity is not a map in message activity response');
    }

    return MessageActivityResponse(
      activity: PracticeActivityModel.fromJson(
        json['activity'] as Map<String, dynamic>,
      ),
    );
  }
}
