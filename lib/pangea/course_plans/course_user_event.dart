class CourseUserState {
  final String userID;
  final Map<String, List<String>> _completedActivities;

  CourseUserState({
    required this.userID,
    required Map<String, List<String>> completedActivities,
  }) : _completedActivities = completedActivities;

  void completeActivity(
    String activityID,
    String topicID,
  ) {
    _completedActivities[topicID] ??= [];
    if (!_completedActivities[topicID]!.contains(activityID)) {
      _completedActivities[topicID]!.add(activityID);
    }
  }

  List<String> completedActivities(String topicID) {
    return _completedActivities[topicID] ?? [];
  }

  bool hasCompletedActivity(
    String activityID,
  ) {
    return _completedActivities.values.any(
      (activities) => activities.contains(activityID),
    );
  }

  factory CourseUserState.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> activities = {};
    final activityEntry =
        (json['comp_act_by_topic'] as Map<String, dynamic>?) ?? {};

    for (final entry in activityEntry.entries) {
      activities[entry.key] = List<String>.from(entry.value);
    }

    return CourseUserState(
      userID: json['user_id'],
      completedActivities: activities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userID,
      'comp_act_by_topic': _completedActivities,
    };
  }
}
