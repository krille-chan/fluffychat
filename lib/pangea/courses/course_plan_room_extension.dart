import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/courses/course_plan_event.dart';
import 'package:fluffychat/pangea/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/courses/course_user_event.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

extension CoursePlanRoomExtension on Room {
  CoursePlanEvent? get coursePlan {
    final event = getState(PangeaEventTypes.coursePlan);
    if (event == null) return null;
    return CoursePlanEvent.fromJson(event.content);
  }

  CourseUserState? _courseUserState(String userID) {
    final event = getState(
      PangeaEventTypes.courseUser,
      userID,
    );
    if (event == null) return null;
    return CourseUserState.fromJson(event.content);
  }

  CourseUserState? get _ownCourseState => _courseUserState(client.userID!);

  bool _hasCompletedTopic(
    String userID,
    String topicID,
    CoursePlanModel course,
  ) {
    final state = _courseUserState(userID);
    if (state == null) return false;

    final topicIndex = course.topics.indexWhere(
      (t) => t.uuid == topicID,
    );

    if (topicIndex == -1) {
      throw Exception('Topic not found');
    }

    final activityIds =
        course.topics[topicIndex].activities.map((a) => a.bookmarkId).toList();
    return state.completedActivities(topicID).toSet().containsAll(activityIds);
  }

  Topic? currentTopic(
    String userID,
    CoursePlanModel course,
  ) {
    if (coursePlan == null) return null;
    final topicIDs = course.topics.map((t) => t.uuid).toList();
    if (topicIDs.isEmpty) return null;

    final index = topicIDs.indexWhere(
      (t) => !_hasCompletedTopic(userID, t, course),
    );

    return index == -1 ? null : course.topics[index];
  }

  Topic? ownCurrentTopic(CoursePlanModel course) =>
      currentTopic(client.userID!, course);

  int currentTopicIndex(
    String userID,
    CoursePlanModel course,
  ) {
    if (coursePlan == null) return -1;
    final topicIDs = course.topics.map((t) => t.uuid).toList();
    if (topicIDs.isEmpty) return -1;

    final index = topicIDs.indexWhere(
      (t) => !_hasCompletedTopic(userID, t, course),
    );

    return index == -1 ? 0 : index;
  }

  int ownCurrentTopicIndex(CoursePlanModel course) =>
      currentTopicIndex(client.userID!, course);

  Map<String, List<User>> topicsToUsers(CoursePlanModel course) {
    final Map<String, List<User>> topicUserMap = {};
    final users = getParticipants();
    for (final user in users) {
      if (user.id == BotName.byEnvironment) continue;
      final topicIndex = currentTopicIndex(user.id, course);
      if (topicIndex != -1) {
        final topicID = course.topics[topicIndex].uuid;
        topicUserMap.putIfAbsent(topicID, () => []).add(user);
      }
    }
    return topicUserMap;
  }

  Future<void> finishCourseActivity(
    String activityID,
    String topicID,
  ) async {
    CourseUserState? state = _ownCourseState;
    state ??= CourseUserState(
      userID: client.userID!,
      completedActivities: {},
    );
    state.completeActivity(activityID, topicID);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.courseUser,
      client.userID!,
      state.toJson(),
    );
  }
}
