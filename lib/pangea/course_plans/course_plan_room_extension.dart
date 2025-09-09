import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_event.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/course_user_event.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

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

  bool hasCompletedActivity(
    String userID,
    String activityID,
  ) {
    final state = _courseUserState(userID);
    if (state == null) return false;
    return state.hasCompletedActivity(activityID);
  }

  bool _hasCompletedTopic(
    String userID,
    String topicID,
    CoursePlanModel course,
  ) {
    final state = _courseUserState(userID);
    if (state == null) return false;

    final topicIndex = course.loadedTopics.indexWhere(
      (t) => t.uuid == topicID,
    );

    if (topicIndex == -1) {
      throw Exception('Topic not found');
    }

    final activityIds = course.loadedTopics[topicIndex].loadedActivities
        .map((a) => a.activityId)
        .toList();
    return state.completedActivities(topicID).toSet().containsAll(activityIds);
  }

  CourseTopicModel? currentTopic(
    String userID,
    CoursePlanModel course,
  ) {
    if (coursePlan == null) return null;
    final topicIDs = course.loadedTopics.map((t) => t.uuid).toList();
    if (topicIDs.isEmpty) return null;

    final index = topicIDs.indexWhere(
      (t) => !_hasCompletedTopic(userID, t, course),
    );

    return index == -1 ? null : course.loadedTopics[index];
  }

  CourseTopicModel? ownCurrentTopic(CoursePlanModel course) =>
      currentTopic(client.userID!, course);

  int currentTopicIndex(
    String userID,
    CoursePlanModel course,
  ) {
    if (coursePlan == null) return -1;
    final topicIDs = course.loadedTopics.map((t) => t.uuid).toList();
    if (topicIDs.isEmpty) return -1;

    final index = topicIDs.indexWhere(
      (t) => !_hasCompletedTopic(userID, t, course),
    );

    return index == -1 ? 0 : index;
  }

  int ownCurrentTopicIndex(CoursePlanModel course) =>
      currentTopicIndex(client.userID!, course);

  String? activeActivityRoomId(String activityId) {
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final room = client.getRoomById(child.roomId!);
      if (room?.activityId == activityId && !room!.isHiddenActivityRoom) {
        return room.id;
      }
    }
    return null;
  }

  Future<Map<String, List<User>>> topicsToUsers(CoursePlanModel course) async {
    final Map<String, List<User>> topicUserMap = {};
    final users = await requestParticipants(
      [Membership.join, Membership.invite, Membership.knock],
      false,
      true,
    );

    for (final user in users) {
      if (user.id == BotName.byEnvironment) continue;
      final topicIndex = currentTopicIndex(user.id, course);
      if (topicIndex != -1) {
        final topicID = course.loadedTopics[topicIndex].uuid;
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

  Future<String> launchActivityRoom(
    ActivityPlanModel activity,
    ActivityRole? role,
  ) async {
    final roomID = await client.createRoom(
      creationContent: {
        'type': "${PangeaRoomTypes.activitySession}:${activity.activityId}",
      },
      visibility: Visibility.private,
      name: activity.title,
      initialState: [
        StateEvent(
          type: PangeaEventTypes.activityPlan,
          content: activity.toJson(),
        ),
        if (activity.imageURL != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': activity.imageURL},
          ),
        if (role != null)
          StateEvent(
            type: PangeaEventTypes.activityRole,
            content: ActivityRolesModel({
              role.id: ActivityRoleModel(
                id: role.id,
                userId: client.userID!,
                role: role.name,
              ),
            }).toJson(),
          ),
        RoomDefaults.defaultPowerLevels(
          client.userID!,
        ),
        await client.pangeaJoinRules(
          'knock_restricted',
          allow: [
            {
              "type": "m.room_membership",
              "room_id": id,
            }
          ],
        ),
      ],
    );

    await addToSpace(roomID);
    if (pangeaSpaceParents.isEmpty) {
      await client.waitForRoomInSync(roomID);
    }
    return roomID;
  }
}
