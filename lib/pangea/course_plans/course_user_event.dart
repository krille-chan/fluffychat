class CourseUserState {
  final String userID;

  // Map of activityIds to list of roomIds
  final Map<String, List<String>> _completedActivities;

  CourseUserState({
    required this.userID,
    required Map<String, List<String>> completedActivities,
  }) : _completedActivities = completedActivities;

  void completeActivity(
    String activityID,
    String roomID,
  ) {
    _completedActivities[activityID] ??= [];
    _completedActivities[activityID]!.add(roomID);
  }

  Set<String> get completedActivities => _completedActivities.keys.toSet();

  bool hasCompletedActivity(
    String activityID,
  ) {
    return _completedActivities.containsKey(activityID);
  }

  factory CourseUserState.fromJson(Map<String, dynamic> json) {
    final activityEntry = json['comp_act_by_topic'];

    final Map<String, List<String>> activityMap = {};
    if (activityEntry != null) {
      activityEntry.forEach((key, value) {
        activityMap[key] = List<String>.from(value);
      });
    }

    return CourseUserState(
      userID: json['user_id'],
      completedActivities: activityMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userID,
      'comp_act_by_topic': _completedActivities,
    };
  }
}
