import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_sessions_start_view.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/course_plans/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum SessionState {
  /// The room hasn't been created yet
  notStarted,

  /// The room has been created but the user hasn't selected a role yet. Non-admins haven't joined yet.
  notSelectedRole,

  /// The user has selected a role but hasn't confirmed yet. Non-admins haven't joined yet.
  selectedRole,

  /// The user has confirmed their role and is waiting for others to join. Non-admins have joined.
  confirmedRole,
}

class ActivitySessionStartPage extends StatefulWidget {
  final String activityId;
  final String? roomId;
  final String? parentId;
  final bool launch;

  const ActivitySessionStartPage({
    super.key,
    required this.activityId,
    required this.parentId,
    this.roomId,
    this.launch = false,
  });

  @override
  ActivitySessionStartController createState() =>
      ActivitySessionStartController();
}

class ActivitySessionStartController extends State<ActivitySessionStartPage>
    with ActivitySummariesProvider {
  ActivityPlanModel? activity;
  CoursePlanModel? course;

  bool loading = true;
  Object? error;

  bool showInstructions = false;
  String? _selectedRoleId;

  Timer? _pingCooldown;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ActivitySessionStartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId) {
      setState(() {
        _selectedRoleId = null;
        showInstructions = false;
      });
    }

    if (oldWidget.activityId != widget.activityId) {
      _load();
    }
  }

  @override
  void dispose() {
    _pingCooldown?.cancel();
    super.dispose();
  }

  Room? get activityRoom => widget.roomId != null
      ? Matrix.of(context).client.getRoomById(
            widget.roomId!,
          )
      : null;

  Room? get courseParent => widget.parentId != null
      ? Matrix.of(context).client.getRoomById(
            widget.parentId!,
          )
      : null;

  bool get isBotRoomMember =>
      activityRoom?.getParticipants().any(
            (p) => p.id == BotName.byEnvironment,
          ) ??
      false;

  SessionState get state {
    if (activityRoom?.ownRoleState != null) return SessionState.confirmedRole;
    if (_selectedRoleId != null) return SessionState.selectedRole;
    if (activityRoom == null) {
      return widget.roomId != null || widget.launch
          ? SessionState.notSelectedRole
          : SessionState.notStarted;
    }
    return SessionState.notSelectedRole;
  }

  String? get descriptionText {
    switch (state) {
      case SessionState.confirmedRole:
        return L10n.of(context).waitingToFillRole(activityRoom!.remainingRoles);
      case SessionState.selectedRole:
        return activity!.roles[_selectedRoleId!]!.goal;
      case SessionState.notStarted:
        return null;

      case SessionState.notSelectedRole:
        return activityRoom?.isRoomAdmin ?? false
            ? L10n.of(context).chooseRole
            : L10n.of(context).chooseRoleToParticipate;
    }
  }

  bool get enableButtons => [
        SessionState.notStarted,
        SessionState.selectedRole,
      ].contains(state);

  bool canSelectParticipant(String id) {
    if (state == SessionState.confirmedRole ||
        state == SessionState.notStarted) {
      return false;
    }

    final availableRoles = activity!.roles;
    final assignedRoles = activityRoom?.assignedRoles ??
        roomSummaries?[widget.roomId]?.activityRoles.roles ??
        {};
    final unassignedIds = availableRoles.keys
        .where((id) => !assignedRoles.containsKey(id))
        .toList();
    return unassignedIds.contains(id);
  }

  bool isParticipantSelected(String id) {
    if (state == SessionState.confirmedRole) {
      return activityRoom?.ownRoleState?.id == id;
    }
    return _selectedRoleId == id;
  }

  bool get canJoinExistingSession {
    if (activityRoom != null) return false;
    return numOpenSessions(widget.activityId) > 0;
  }

  bool get canPingParticipants {
    if (activityRoom == null || courseParent == null) return false;
    return _pingCooldown == null || !_pingCooldown!.isActive;
  }

  void toggleInstructions() {
    setState(() {
      showInstructions = !showInstructions;
    });
  }

  void selectRole(String id) {
    if (state == SessionState.confirmedRole) return;
    if (_selectedRoleId == id) return;
    if (mounted) setState(() => _selectedRoleId = id);
  }

  Future<int> neededCourseParticipants() async {
    final courseParticipants = await courseParent?.requestParticipants(
          [Membership.join, Membership.invite, Membership.knock],
          false,
          true,
        ) ??
        [];

    final botInCourse = courseParticipants.any(
      (p) => p.id == BotName.byEnvironment,
    );

    final addBotToAvailableUsers = !botInCourse && !isBotRoomMember;
    final availableParticipants =
        courseParticipants.length + (addBotToAvailableUsers ? 1 : 0);
    if (availableParticipants >= (activity?.req.numberOfParticipants ?? 0)) {
      return 0;
    }
    return (activity?.req.numberOfParticipants ?? 0) - availableParticipants;
  }

  Future<void> _load() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });
      final futures = <Future>[];
      futures.add(_loadSummary());
      futures.add(_loadActivity());
      await Future.wait(futures);
    } catch (e) {
      error = e;
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _loadSummary() async {
    if (courseParent == null) return;
    await loadRoomSummaries(
      courseParent!.spaceChildren
          .map((c) => c.roomId)
          .whereType<String>()
          .toList(),
    );
  }

  Future<void> _loadActivity() async {
    if (courseParent?.coursePlan != null) {
      course = await CoursePlansRepo.get(courseParent!.coursePlan!.uuid);
    }

    final activities = await CourseActivityRepo.get(
      widget.activityId,
      [widget.activityId],
    );

    if (activities.isEmpty) {
      throw Exception("Activity not found");
    }

    activity = activities.first;
  }

  Future<void> joinActivity() async {
    if (state != SessionState.selectedRole) return;
    if (widget.roomId == null) {
      throw Exception(
        "Cannot join activity: room ID is required but not provided",
      );
    }

    final client = Matrix.of(context).client;
    if (activityRoom?.membership != Membership.join) {
      await client.joinRoom(
        widget.roomId!,
        serverName: courseParent?.spaceChildren
            .firstWhereOrNull(
              (child) => child.roomId == widget.roomId,
            )
            ?.via,
      );

      if (activityRoom == null || activityRoom!.membership != Membership.join) {
        await client.waitForRoomInSync(widget.roomId!, join: true);
      }

      if (activityRoom == null || activityRoom!.membership != Membership.join) {
        throw Exception("Failed to join activity room. "
            "Room ID: ${widget.roomId}, "
            "Membership status: ${activityRoom?.membership}");
      }
    }

    try {
      await activityRoom!.joinActivity(
        activity!.roles[_selectedRoleId!]!,
      );
    } catch (e) {
      if (e is! RoleException) {
        rethrow;
      }
    }

    context.go("/rooms/spaces/${widget.parentId}/${widget.roomId}");
  }

  Future<void> confirmRoleSelection() async {
    if (state != SessionState.selectedRole) return;
    if (activityRoom?.membership == Membership.join) {
      await showFutureLoadingDialog(
        context: context,
        future: () => activityRoom!.joinActivity(
          activity!.roles[_selectedRoleId!]!,
        ),
      );
    } else if (widget.roomId != null) {
      await showFutureLoadingDialog(
        context: context,
        future: joinActivity,
      );
    } else {
      final resp = await showFutureLoadingDialog(
        context: context,
        future: () => courseParent!.launchActivityRoom(
          activity!,
          activity!.roles[_selectedRoleId!],
        ),
      );

      if (!resp.isError) {
        context.go("/rooms/spaces/${widget.parentId}/${resp.result}");
      }
    }
  }

  Future<String> joinExistingSession() async {
    if (!canJoinExistingSession) {
      throw Exception("No existing session to join");
    }

    final sessionIds = openSessions(widget.activityId);
    String? joinedSessionId;
    for (final sessionId in sessionIds) {
      try {
        await courseParent!.client.joinRoom(
          sessionId,
          via: courseParent?.spaceChildren
              .firstWhereOrNull(
                (child) => child.roomId == sessionId,
              )
              ?.via,
        );
        joinedSessionId = sessionId;
        break;
      } catch (_) {
        // try next session
        continue;
      }
    }

    if (joinedSessionId == null) {
      throw Exception("Failed to join any existing session");
    }

    final room = courseParent!.client.getRoomById(joinedSessionId);
    if (room == null || room.membership != Membership.join) {
      await courseParent!.client.waitForRoomInSync(joinedSessionId, join: true);
    }

    return joinedSessionId;
  }

  Future<void> pingCourse() async {
    if (activityRoom?.courseParent == null) {
      throw Exception("Activity is not part of a course");
    }

    if (!canPingParticipants) {
      throw Exception("Ping is on cooldown");
    }

    _pingCooldown?.cancel();
    _pingCooldown = Timer(const Duration(minutes: 1), () {
      _pingCooldown = null;
      if (mounted) setState(() {});
    });

    await activityRoom!.courseParent!.sendEvent(
      {
        "body": L10n.of(context).pingParticipantsNotification(
          activityRoom!.client.userID!.localpart ??
              activityRoom!.client.userID!,
          activityRoom!.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
        ),
        "msgtype": "m.text",
        "pangea.activity.session_room_id": activityRoom!.id,
        "pangea.activity.id": widget.activityId,
      },
    );

    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            L10n.of(context).pingSent,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  Future<void> playWithBot() async {
    if (activityRoom == null) {
      throw Exception("Room is null");
    }

    if (isBotRoomMember) {
      throw Exception("Bot is a member of the room");
    }

    final future = activityRoom!.client.onRoomState.stream
        .where(
          (state) =>
              state.roomId == activityRoom!.id &&
              state.state.type == PangeaEventTypes.activityRole &&
              state.state.senderId == BotName.byEnvironment,
        )
        .first;
    activityRoom!.invite(BotName.byEnvironment);
    await future.timeout(const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) => ActivitySessionStartView(this);
}
