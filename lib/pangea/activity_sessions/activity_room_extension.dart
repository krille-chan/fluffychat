import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_analytics_repo.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_request_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../activity_summary/activity_summary_repo.dart';

extension ActivityRoomExtension on Room {
  Future<void> joinActivity(ActivityRole role) async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final activityRole = ActivityRoleModel(
      id: role.id,
      userId: client.userID!,
      role: role.name,
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
    final role = ownRole;
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
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final role = ownRole;
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

  Future<void> finishActivityForAll() async {
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
    final role = ownRole;
    if (role == null || !role.isFinished || role.isArchived) return;

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
    if (activitySummary?.summary != null) {
      return;
    }

    await setActivitySummary(
      ActivitySummaryModel(
        requestedAt: DateTime.now(),
        summary: activitySummary?.summary,
      ),
    );

    final events = await getAllEvents();
    final List<ActivitySummaryResultsMessage> messages = [];
    final ActivitySummaryAnalyticsModel analytics =
        activitySummary?.analytics ?? ActivitySummaryAnalyticsModel();

    final timeline = this.timeline ?? await getTimeline();
    for (final event in events) {
      if (event.type != EventTypes.Message ||
          event.messageType != MessageTypes.Text) {
        continue;
      }

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

      if (activitySummary?.analytics == null) {
        analytics.addConstructs(pangeaMessage);
      }
    }

    try {
      final resp = await ActivitySummaryRepo.get(
        id,
        ActivitySummaryRequestModel(
          activity: activityPlan!,
          activityResults: messages,
          contentFeedback: [],
          analytics: analytics,
        ),
      );

      await setActivitySummary(
        ActivitySummaryModel(
          summary: resp,
          analytics: analytics,
        ),
      );

      ActivitySummaryRepo.delete(id, activityPlan!);
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
            analytics: analytics,
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
      if (!kDebugMode && !Environment.isStagingEnvironment) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "roomID": id,
            "stateEvent": content,
          },
        );
      }
      return null;
    }
  }

  Map<String, ActivityRoleModel>? get assignedRoles {
    final roles = activityRoles?.roles;
    if (roles == null) return null;

    final participants = getParticipants();
    return Map.fromEntries(
      roles.entries.where(
        (r) => participants.any(
          (p) => p.id == r.value.userId && p.membership == Membership.join,
        ),
      ),
    );
  }

  ActivityRoleModel? get ownRole => activityRoles?.role(client.userID!);

  int get remainingRoles {
    final availableRoles = activityPlan?.roles;
    return max(0, (availableRoles?.length ?? 0) - (assignedRoles?.length ?? 0));
  }

  bool get showActivityChatUI {
    return activityPlan != null &&
        powerForChangingStateEvent(PangeaEventTypes.activityRole) == 0 &&
        powerForChangingStateEvent(PangeaEventTypes.activitySummary) == 0;
  }

  bool get activityHasStarted =>
      (activityPlan?.roles.length ?? 0) - (activityRoles?.roles.length ?? 0) <=
      0;

  bool get isActiveInActivity {
    if (!showActivityChatUI) return false;
    final role = ownRole;
    return role != null && !role.isFinished;
  }

  bool get isInactiveInActivity {
    if (!showActivityChatUI) return false;
    final role = ownRole;
    return role == null || role.isFinished;
  }

  bool get hasCompletedActivity => ownRole?.isFinished ?? false;

  bool get activityIsFinished {
    final roles = activityRoles?.roles.values.where(
      (r) => r.userId != BotName.byEnvironment,
    );

    if (roles == null || roles.isEmpty) return false;
    if (!roles.any((r) => r.isFinished)) return false;

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

  bool get isHiddenActivityRoom => ownRole?.isArchived ?? false;

  Room? get courseParent => pangeaSpaceParents.firstWhereOrNull(
        (parent) => parent.coursePlan != null,
      );

  bool get isActivityRoomType =>
      roomType?.startsWith(PangeaRoomTypes.activitySession) == true;

  bool get isActivitySession => isActivityRoomType || activityPlan != null;

  bool get showActivityFinished =>
      showActivityChatUI && ownRole != null && hasCompletedActivity;

  String? get activityId {
    if (!isActivitySession) return null;
    if (isActivityRoomType) {
      return roomType!.split(":").last;
    }
    return activityPlan?.activityId;
  }

  Future<ActivitySummaryAnalyticsModel> getActivityAnalytics() async {
    // wait for local storage box to init in getAnalytics initialization
    if (!MatrixState.pangeaController.getAnalytics.initCompleter.isCompleted) {
      await MatrixState.pangeaController.getAnalytics.initCompleter.future;
    }

    final cached = ActivitySessionAnalyticsRepo.get(id);
    final analytics = cached?.analytics ?? ActivitySummaryAnalyticsModel();

    final eventsSince = await getAllEvents(since: cached?.lastEventId);
    final timeline = this.timeline ?? await getTimeline();
    final messageEvents = getPangeaMessageEvents(
      eventsSince,
      timeline,
      msgtypes: [
        MessageTypes.Text,
        MessageTypes.Audio,
      ],
    );

    if (messageEvents.isEmpty) {
      return analytics;
    }

    for (final pangeaMessage in messageEvents) {
      analytics.addConstructs(pangeaMessage);
    }

    await ActivitySessionAnalyticsRepo.set(
      id,
      messageEvents.last.eventId,
      analytics,
    );

    return analytics;
  }
}
