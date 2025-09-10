import 'package:matrix/matrix.dart' as sdk;
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

    try {
      return CourseUserState.fromJson(event.content);
    } catch (e) {
      return null;
    }
  }

  CourseUserState? get _ownCourseState => _courseUserState(client.userID!);

  Map<String, CourseUserState> get allCourseUserStates {
    final content = states[PangeaEventTypes.courseUser];
    if (content == null || content.isEmpty) return {};
    return Map<String, CourseUserState>.fromEntries(
      content.entries.map(
        (e) {
          try {
            return MapEntry(
              e.key,
              CourseUserState.fromJson(e.value.content),
            );
          } catch (e) {
            return null;
          }
        },
      ).whereType<MapEntry<String, CourseUserState>>(),
    );
  }

  Set<String> openSessions(String activityId) {
    final Set<String> sessions = {};
    final Set<String> childIds =
        spaceChildren.map((child) => child.roomId).whereType<String>().toSet();

    for (final userState in allCourseUserStates.values) {
      final activitySessions = userState.joinedActivities[activityId]?.toSet();
      if (activitySessions == null) continue;
      sessions.addAll(
        activitySessions.intersection(childIds),
      );
    }
    return sessions;
  }

  int numOpenSessions(String activityId) => openSessions(activityId).length;

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
    CourseTopicModel topic,
    CoursePlanModel course,
  ) {
    final state = _courseUserState(userID);
    if (state == null) return false;

    final topicIndex = course.loadedTopics.indexWhere(
      (t) => t.uuid == topic.uuid,
    );

    if (topicIndex == -1) {
      throw Exception('Topic not found');
    }

    final activityIds = course.loadedTopics[topicIndex].loadedActivities
        .map((a) => a.activityId)
        .toList();
    return state.completedActivities.toSet().containsAll(activityIds);
  }

  CourseTopicModel? currentTopic(
    String userID,
    CoursePlanModel course,
  ) {
    if (coursePlan == null) return null;
    if (course.loadedTopics.isEmpty) return null;

    final index = course.loadedTopics.indexWhere(
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
    if (course.loadedTopics.isEmpty) return -1;

    final index = course.loadedTopics.indexWhere(
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
      if (room?.membership == Membership.join &&
          room?.activityId == activityId &&
          !room!.isHiddenActivityRoom) {
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

  Future<void> joinCourseActivity(
    String activityID,
    String roomID,
  ) async {
    CourseUserState? state = _ownCourseState;
    state ??= CourseUserState(
      userID: client.userID!,
      completedActivities: {},
      joinActivities: {},
    );
    state.joinActivity(activityID, roomID);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.courseUser,
      client.userID!,
      state.toJson(),
    );
  }

  Future<void> finishCourseActivity(
    String activityID,
    String roomID,
  ) async {
    CourseUserState? state = _ownCourseState;
    state ??= CourseUserState(
      userID: client.userID!,
      completedActivities: {},
      joinActivities: {},
    );
    state.completeActivity(activityID, roomID);
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
      visibility: sdk.Visibility.private,
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

    await joinCourseActivity(
      activity.activityId,
      roomID,
    );
    return roomID;
  }
}
