class ActivityFeedbackRequest {
  final String activityId;
  final String feedbackText;
  final String userId;
  final String userL1;
  final String userL2;

  ActivityFeedbackRequest({
    required this.activityId,
    required this.feedbackText,
    required this.userId,
    required this.userL1,
    required this.userL2,
  });

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'feedback_text': feedbackText,
      'user_id': userId,
      'user_l1': userL1,
      'user_l2': userL2,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityFeedbackRequest &&
          runtimeType == other.runtimeType &&
          activityId == other.activityId &&
          feedbackText == other.feedbackText &&
          userId == other.userId &&
          userL1 == other.userL1 &&
          userL2 == other.userL2;

  @override
  int get hashCode =>
      activityId.hashCode ^
      feedbackText.hashCode ^
      userId.hashCode ^
      userL1.hashCode ^
      userL2.hashCode;
}
