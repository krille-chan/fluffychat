import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_repo.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_request_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/utils/download_chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

extension ActivityRoomExtension on Room {
  Future<void> sendActivityPlan(
    ActivityPlanModel activity, {
    Uint8List? avatar,
    String? filename,
  }) async {
    BookmarkedActivitiesRepo.save(activity);

    if (canChangeStateEvent(PangeaEventTypes.activityPlan)) {
      await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.activityPlan,
        "",
        activity.toJson(),
      );
    }
  }

  Future<void> joinActivity({
    String? role,
  }) async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final activityRole = ActivityRoleModel(
      userId: client.userID!,
      role: role,
    );

    currentRoles.updateRole(activityRole);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      "",
      currentRoles.toJson(),
    );
  }

  Future<void> continueActivity() async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final role = currentRoles.role(client.userID!);
    if (role == null || !role.isFinished) return;

    role.finishedAt = null; // Reset finished state
    currentRoles.updateRole(role);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      "",
      currentRoles.toJson(),
    );
  }

  Future<void> finishActivity() async {
    if (isRoomAdmin) {
      await _finishActivityForAll();
      return;
    }

    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final role = currentRoles.role(client.userID!);
    if (role == null || role.isFinished) return;
    role.finishedAt = DateTime.now();
    currentRoles.updateRole(role);

    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      "",
      currentRoles.toJson(),
    );
  }

  Future<void> _finishActivityForAll() async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    currentRoles.finishAll();
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      "",
      currentRoles.toJson(),
    );
  }

  Future<void> archiveActivity() async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final role = currentRoles.role(client.userID!);
    if (role == null || !role.isFinished) return;

    role.archivedAt = DateTime.now();
    currentRoles.updateRole(role);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      "",
      currentRoles.toJson(),
    );
  }

  Future<void> setActivitySummary(
    ActivitySummaryModel summary,
  ) async {
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activitySummary,
      "",
      summary.toJson(),
    );
  }

  Future<void> fetchSummaries() async {
    if (activitySummary?.summary != null) return;

    await setActivitySummary(
      ActivitySummaryModel(
        requestedAt: DateTime.now(),
        summary: activitySummary?.summary,
      ),
    );

    final events = await getAllEvents(this);
    final List<ActivitySummaryResultsMessage> messages = [];
    for (final event in events) {
      if (event.type != EventTypes.Message ||
          event.messageType != MessageTypes.Text) {
        continue;
      }

      final timeline = this.timeline ?? await getTimeline();
      final pangeaMessage = PangeaMessageEvent(
        event: event,
        timeline: timeline,
        ownMessage: client.userID == event.senderId,
      );

      final activityMessage = ActivitySummaryResultsMessage(
        userId: event.senderId,
        sent: pangeaMessage.originalSent?.text ?? event.body,
        written: pangeaMessage.originalWrittenContent,
        time: event.originServerTs,
        tool: [
          if (pangeaMessage.originalSent?.choreo?.includedIT == true) "it",
          if (pangeaMessage.originalSent?.choreo?.includedIGC == true) "igc",
        ],
      );

      messages.add(activityMessage);
    }

    try {
      final resp = await ActivitySummaryRepo.get(
        ActivitySummaryRequestModel(
          activity: activityPlan!,
          activityResults: messages,
          contentFeedback: [],
        ),
      );

      await setActivitySummary(
        ActivitySummaryModel(summary: resp),
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "activityPlan": activityPlan?.toJson(),
          "activityResults": messages.map((m) => m.toJson()).toList(),
        },
      );

      if (activitySummary?.summary == null) {
        await setActivitySummary(
          ActivitySummaryModel(
            errorAt: DateTime.now(),
          ),
        );
      }
    }
  }

  ActivityPlanModel? get activityPlan {
    final stateEvent = getState(PangeaEventTypes.activityPlan);
    if (stateEvent == null) return null;

    try {
      return ActivityPlanModel.fromJson(stateEvent.content);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "stateEvent": stateEvent.content,
        },
      );
      return null;
    }
  }

  ActivitySummaryModel? get activitySummary {
    final stateEvent = getState(PangeaEventTypes.activitySummary);
    if (stateEvent == null) return null;

    try {
      return ActivitySummaryModel.fromJson(stateEvent.content);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "stateEvent": stateEvent.content,
        },
      );
      return null;
    }
  }

  ActivityRolesModel? get activityRoles {
    final content = getState(PangeaEventTypes.activityRole)?.content;
    if (content == null) return null;

    try {
      return ActivityRolesModel.fromJson(content);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "stateEvent": content,
        },
      );
      return null;
    }
  }

  bool get showActivityChatUI {
    return activityPlan != null &&
        powerForChangingStateEvent(PangeaEventTypes.activityRole) == 0 &&
        powerForChangingStateEvent(PangeaEventTypes.activitySummary) == 0;
  }

  bool get isActiveInActivity {
    if (!showActivityChatUI) return false;
    final role = activityRoles?.role(client.userID!);
    return role != null && !role.isFinished;
  }

  bool get isInactiveInActivity {
    if (!showActivityChatUI) return false;
    final role = activityRoles?.role(client.userID!);
    return role == null || role.isFinished;
  }

  bool get hasCompletedActivity =>
      activityRoles?.role(client.userID!)?.isFinished ?? false;

  bool get activityIsFinished {
    final roles = activityRoles?.roles.where(
      (r) => r.userId != BotName.byEnvironment,
    );

    if (roles == null || roles.isEmpty) return false;
    return roles.every((r) {
      if (r.isFinished) return true;

      // if the user is in the chat (not null && membership is join),
      // then the activity is not finished for them
      final user = getParticipants().firstWhereOrNull(
        (u) => u.id == r.userId,
      );
      return user == null || user.membership != Membership.join;
    });
  }

  int get remainingRoles {
    if (activityPlan == null) return 0;
    return max(
      0,
      activityPlan!.roles.length - (activityRoles?.roles.length ?? 0),
    );
  }

  bool get isHiddenActivityRoom =>
      activityRoles?.role(client.userID!)?.isArchived ?? false;
}
