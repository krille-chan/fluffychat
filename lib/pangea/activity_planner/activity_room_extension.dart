import 'dart:math';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_repo.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_request_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';
import 'package:fluffychat/pangea/chat_settings/utils/download_chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';

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

  Future<void> setActivityRole({
    String? role,
  }) async {
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      client.userID!,
      ActivityRoleModel(
        userId: client.userID!,
        role: role,
      ).toJson(),
    );
  }

  Future<void> finishActivity() async {
    final role = activityRole(client.userID!);
    if (role == null) return;

    role.finishedAt = DateTime.now();
    final syncFuture = client.waitForRoomInSync(id);
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      client.userID!,
      role.toJson(),
    );
    await syncFuture;
  }

  Future<void> setActivitySummary(
    ActivitySummaryResponseModel summary,
  ) async {
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activitySummary,
      "",
      summary.toJson(),
    );
  }

  Future<void> fetchSummaries() async {
    if (activitySummary != null) return;

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

    final resp = await ActivitySummaryRepo.get(
      ActivitySummaryRequestModel(
        activity: activityPlan!,
        activityResults: messages,
        contentFeedback: [],
      ),
    );

    await setActivitySummary(resp);
  }

  Future<void> archiveActivity() async {
    final role = activityRole(client.userID!);
    if (role == null) return;

    role.archivedAt = DateTime.now();
    await client.setRoomStateWithKey(
      id,
      PangeaEventTypes.activityRole,
      client.userID!,
      role.toJson(),
    );
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

  ActivityRoleModel? activityRole(String userId) {
    final stateEvent = getState(PangeaEventTypes.activityRole, userId);
    if (stateEvent == null) return null;

    try {
      return ActivityRoleModel.fromJson(stateEvent.content);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "userId": userId,
          "stateEvent": stateEvent.content,
        },
      );
      return null;
    }
  }

  ActivitySummaryResponseModel? get activitySummary {
    final stateEvent = getState(PangeaEventTypes.activitySummary);
    if (stateEvent == null) return null;

    try {
      return ActivitySummaryResponseModel.fromJson(stateEvent.content);
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

  List<StrippedStateEvent> get _activityRoleEvents {
    return states[PangeaEventTypes.activityRole]?.values.toList() ?? [];
  }

  List<ActivityRoleModel> get activityRoles {
    return _activityRoleEvents
        .map((r) => ActivityRoleModel.fromJson(r.content))
        .toList();
  }

  bool get hasJoinedActivity {
    return activityPlan == null || activityRole(client.userID!) != null;
  }

  bool get hasFinishedActivity {
    final role = activityRole(client.userID!);
    return role != null && role.isFinished;
  }

  bool get activityIsFinished {
    return activityRoles.isNotEmpty && activityRoles.every((r) => r.isFinished);
  }

  int? get numberOfParticipants {
    return activityPlan?.req.numberOfParticipants;
  }

  int get remainingRoles {
    if (numberOfParticipants == null) return 0;
    return max(0, numberOfParticipants! - activityRoles.length);
  }
}
