import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';

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

  final ActivityQualityFeedback? activityQualityFeedback;

  MessageActivityRequest({
    required this.userL1,
    required this.userL2,
    required this.messageText,
    required this.messageTokens,
    required this.activityQualityFeedback,
    required this.targetTokens,
    required this.targetType,
  }) {
    if (targetTokens.isEmpty) {
      throw Exception('Target tokens must not be empty');
    }
    if ([ActivityTypeEnum.wordFocusListening, ActivityTypeEnum.wordMeaning]
            .contains(targetType) &&
        targetTokens.length > 1) {
      throw Exception(
        'Target tokens must be a single token for this activity type',
      );
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
        const ListEquality().equals(other.targetTokens, targetTokens);
  }

  @override
  int get hashCode {
    return messageText.hashCode ^
        targetType.hashCode ^
        activityQualityFeedback.hashCode ^
        targetTokens.hashCode;
  }
}

class MessageActivityResponse {
  final PracticeActivityModel activity;

  MessageActivityResponse({
    required this.activity,
  });

  factory MessageActivityResponse.fromJson(Map<String, dynamic> json) {
    return MessageActivityResponse(
      activity: PracticeActivityModel.fromJson(
        json['activity'] as Map<String, dynamic>,
      ),
    );
  }
}
