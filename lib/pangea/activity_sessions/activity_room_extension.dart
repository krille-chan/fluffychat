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
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../activity_summary/activity_summary_repo.dart';

class RoleException implements Exception {
  final String message;
  RoleException(this.message);

  @override
  String toString() => "RoleException: $message";
}

extension ActivityRoomExtension on Room {
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

  Future<void> joinActivity(ActivityRole role) async {
    final assigned = assignedRoles?.values ?? [];
    if (assigned.any((r) => r.userId != client.userID && r.role == role.name)) {
      throw RoleException("Role already taken");
    }

    if (assigned.any((r) => r.userId == client.userID)) {
      throw RoleException("User already has a role");
    }

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
    final role = ownRoleState;
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
    final role = ownRoleState;
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
    final role = ownRoleState;
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

  Future<void> dismissGoalTooltip() async {
    final currentRoles = activityRoles ?? ActivityRolesModel.empty;
    final role = ownRoleState;
    if (role == null) return;
    role.finishedAt = DateTime.now();
    currentRoles.dismissTooltip(role);

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
          ![
            MessageTypes.Text,
            MessageTypes.Audio,
          ].contains(event.messageType)) {
        continue;
      }

      final pangeaMessage = PangeaMessageEvent(
        event: event,
        timeline: timeline,
        ownMessage: client.userID == event.senderId,
      );

      if (event.messageType == MessageTypes.Audio &&
          pangeaMessage.getSpeechToTextLocal() == null) {
        continue;
      }

      final activityMessage = event.messageType == MessageTypes.Text
          ? ActivitySummaryResultsMessage(
              userId: event.senderId,
              sent: pangeaMessage.originalSent?.text ?? event.body,
              written: pangeaMessage.originalWrittenContent,
              time: event.originServerTs,
              tool: [
                if (pangeaMessage.originalSent?.choreo?.includedIT == true)
                  "it",
                if (pangeaMessage.originalSent?.choreo?.includedIGC == true)
                  "igc",
              ],
            )
          : ActivitySummaryResultsMessage(
              userId: event.senderId,
              sent:
                  pangeaMessage.getSpeechToTextLocal()!.transcript.text.trim(),
              written:
                  pangeaMessage.getSpeechToTextLocal()!.transcript.text.trim(),
              time: event.originServerTs,
              tool: [],
            );

      messages.add(activityMessage);

      if (activitySummary?.analytics == null) {
        analytics.addMessageConstructs(pangeaMessage);
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
          roleState: activityRoles,
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
      if (e is! UnsubscribedException) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "roomID": id,
            "activityPlan": activityPlan?.toJson(),
            "activityResults": messages.map((m) => m.toJson()).toList(),
          },
        );
      }

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

  Future<ActivitySummaryAnalyticsModel> getActivityAnalytics() async {
    // wait for local storage box to init in getAnalytics initialization
    if (!MatrixState.pangeaController.getAnalytics.initCompleter.isCompleted) {
      await MatrixState.pangeaController.getAnalytics.initCompleter.future;
    }

    final cached = ActivitySessionAnalyticsRepo.get(id);
    final analytics = cached?.analytics ?? ActivitySummaryAnalyticsModel();

    DateTime? timestamp = creationTimestamp;
    if (cached != null) {
      timestamp = cached.lastUseTimestamp;
    }

    final List<OneConstructUse> uses = [];

    for (final use
        in MatrixState.pangeaController.getAnalytics.constructListModel.uses) {
      final useTimestamp = use.metadata.timeStamp;
      if (timestamp != null &&
          (useTimestamp == timestamp || useTimestamp.isBefore(timestamp))) {
        break;
      }

      if (use.metadata.roomId != id) continue;
      uses.add(use);
    }

    if (uses.isEmpty) {
      return analytics;
    }

    analytics.addConstructs(client.userID!, uses);
    await ActivitySessionAnalyticsRepo.set(
      id,
      uses.first.metadata.timeStamp,
      analytics,
    );

    return analytics;
  }

  // UI-related helper functions

  bool get showActivityChatUI {
    return activityPlan != null &&
        powerForChangingStateEvent(PangeaEventTypes.activityRole) == 0 &&
        powerForChangingStateEvent(PangeaEventTypes.activitySummary) == 0;
  }

  // helper functions for activity role state in overall activity

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

  int get numRemainingRoles {
    final availableRoles = activityPlan?.roles;
    return max(0, (availableRoles?.length ?? 0) - (assignedRoles?.length ?? 0));
  }

  // helper functions for activity role state for specific users

  ActivityRole? get ownRole {
    final role = ownRoleState;
    if (role == null || activityPlan == null) return null;

    return activityPlan!.roles[role.id];
  }

  ActivityRoleModel? get ownRoleState => activityRoles?.role(client.userID!);

  // helper functions for activity state for overall activity

  bool get isActivitySession =>
      (roomType?.startsWith(PangeaRoomTypes.activitySession) == true ||
          activityPlan != null) &&
      activityPlan?.isDeprecatedModel == false;

  String? get activityId {
    if (!isActivitySession) return null;
    if (roomType?.startsWith(PangeaRoomTypes.activitySession) == true) {
      return roomType!.split(":").last;
    }
    return activityPlan?.activityId;
  }

  bool get isActivityStarted =>
      (activityPlan?.roles.length ?? 0) - (assignedRoles?.length ?? 0) <= 0;

  bool get isActivityFinished {
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

  // helper functions for activity state for specific users

  bool get hasPickedRole => ownRoleState != null;

  bool get hasCompletedRole => ownRoleState?.isFinished ?? false;

  bool get hasArchivedActivity => ownRoleState?.isArchived ?? false;

  bool get hasDismissedGoalTooltip =>
      ownRoleState?.dismissedGoalTooltip ?? false;

  bool get isActiveInActivity => hasPickedRole && !hasCompletedRole;

  // helper functions for activity course context

  Room? get courseParent => pangeaSpaceParents.firstWhereOrNull(
        (parent) => parent.coursePlan != null,
      );
}
