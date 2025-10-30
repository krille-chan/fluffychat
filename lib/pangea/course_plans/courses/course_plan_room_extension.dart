import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_event.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

extension CoursePlanRoomExtension on Room {
  CoursePlanEvent? get coursePlan {
    final event = getState(PangeaEventTypes.coursePlan);
    if (event == null) return null;
    return CoursePlanEvent.fromJson(event.content);
  }

  String? activeActivityRoomId(String activityId) {
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final room = client.getRoomById(child.roomId!);
      if (room?.membership == Membership.join &&
          room?.activityId == activityId &&
          !room!.hasArchivedActivity) {
        return room.id;
      }
    }
    return null;
  }

  Future<void> addCourseToSpace(String courseId) async {
    if (coursePlan?.uuid == courseId) return;
    final future = waitForRoomInSync();
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.coursePlan,
      "",
      {
        "uuid": courseId,
      },
    );
    if (coursePlan?.uuid != courseId) {
      await future;
    }
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
      topic: activity.description,
      initialState: [
        StateEvent(
          type: PangeaEventTypes.activityPlan,
          content: activity.toJson(),
        ),
        if (activity.imageURL != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': activity.imageURL!},
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
