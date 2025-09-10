class CourseUserState {
  final String userID;

  // Map of activityIds to list of roomIds
  final Map<String, List<String>> _completedActivities;
  final Map<String, List<String>> _joinedActivities;

  CourseUserState({
    required this.userID,
    required Map<String, List<String>> completedActivities,
    required Map<String, List<String>> joinActivities,
  })  : _completedActivities = completedActivities,
        _joinedActivities = joinActivities;

  void joinActivity(
    String activityID,
    String roomID,
  ) {
    _joinedActivities[activityID] ??= [];
    _joinedActivities[activityID]!.add(roomID);
  }

  void completeActivity(
    String activityID,
    String roomID,
  ) {
    _completedActivities[activityID] ??= [];
    _completedActivities[activityID]!.add(roomID);
  }

  Map<String, List<String>> get joinedActivities => _joinedActivities;

  List<String> get completedActivities => _completedActivities.keys.toList();
  List<String> get joinedActivityRooms =>
      _joinedActivities.values.expand((e) => e).toList();

  bool hasCompletedActivity(
    String activityID,
  ) {
    return _completedActivities.containsKey(activityID);
  }

  factory CourseUserState.fromJson(Map<String, dynamic> json) {
    final activityEntry = json['comp_act_by_topic'];
    final joinEntry = json['join_act_by_topic'];

    final Map<String, List<String>> activityMap = {};
    if (activityEntry != null) {
      activityEntry.forEach((key, value) {
        activityMap[key] = List<String>.from(value);
      });
    }

    final Map<String, List<String>> joinMap = {};
    if (joinEntry != null) {
      joinEntry.forEach((key, value) {
        joinMap[key] = List<String>.from(value);
      });
    }

    return CourseUserState(
      userID: json['user_id'],
      completedActivities: activityMap,
      joinActivities: joinMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userID,
      'comp_act_by_topic': _completedActivities,
      'join_act_by_topic': _joinedActivities,
    };
  }
}
