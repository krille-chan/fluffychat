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
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
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
  notStarted,
  notSelectedRole,
  selectedRole,
  confirmedRole,
}

class ActivitySessionStartPage extends StatefulWidget {
  final String activityId;
  final bool isNew;
  final Room? room;
  final String? parentId;
  const ActivitySessionStartPage({
    super.key,
    required this.activityId,
    this.isNew = false,
    this.room,
    required this.parentId,
  });

  @override
  ActivitySessionStartController createState() =>
      ActivitySessionStartController();
}

class ActivitySessionStartController extends State<ActivitySessionStartPage> {
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
    _loadActivity();
  }

  @override
  void didUpdateWidget(covariant ActivitySessionStartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room?.id != widget.room?.id) {
      setState(() {
        _selectedRoleId = null;
        showInstructions = false;
      });
    }

    if (oldWidget.activityId != widget.activityId) {
      _loadActivity();
    }
  }

  @override
  void dispose() {
    _pingCooldown?.cancel();
    super.dispose();
  }

  Room? get room => widget.room;

  Room? get parent => widget.parentId != null
      ? Matrix.of(context).client.getRoomById(
            widget.parentId!,
          )
      : null;

  bool get isBotRoomMember =>
      room?.getParticipants().any(
            (p) => p.id == BotName.byEnvironment,
          ) ??
      false;

  SessionState get state {
    if (room?.ownRoleState != null) return SessionState.confirmedRole;
    if (_selectedRoleId != null) return SessionState.selectedRole;
    if (room == null) {
      return widget.isNew
          ? SessionState.notSelectedRole
          : SessionState.notStarted;
    }
    return SessionState.notSelectedRole;
  }

  String? get descriptionText {
    switch (state) {
      case SessionState.confirmedRole:
        return L10n.of(context).waitingToFillRole(room!.remainingRoles);
      case SessionState.selectedRole:
        return activity!.roles[_selectedRoleId!]!.goal;
      case SessionState.notStarted:
        return null;

      case SessionState.notSelectedRole:
        return room?.isRoomAdmin ?? false
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
    final assignedRoles = room?.assignedRoles ?? {};
    final unassignedIds = availableRoles.keys
        .where((id) => !assignedRoles.containsKey(id))
        .toList();
    return unassignedIds.contains(id);
  }

  bool isParticipantSelected(String id) {
    if (state == SessionState.confirmedRole) {
      return room?.ownRoleState?.id == id;
    }
    return _selectedRoleId == id;
  }

  bool get canJoinExistingSession {
    // if the activity session already exists, if there's no parent course, or if the parent course doesn't
    // have the event where existing sessions are stored, joining an existing session is not possible
    if (room != null || parent?.allCourseUserStates == null) return false;
    return parent!.numOpenSessions(widget.activityId) > 0;
  }

  bool get canPingParticipants {
    if (room == null || room?.courseParent == null) return false;
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

  Future<bool> courseHasEnoughParticipants() async {
    final roomParticipants = widget.room?.getParticipants() ?? [];
    final courseParticipants = await parent?.requestParticipants(
          [Membership.join, Membership.invite, Membership.knock],
          false,
          true,
        ) ??
        [];

    final botInRoom = roomParticipants.any(
      (p) => p.id == BotName.byEnvironment,
    );
    final botInCourse = courseParticipants.any(
      (p) => p.id == BotName.byEnvironment,
    );

    final addBotToAvailableUsers = !botInCourse && !botInRoom;
    final availableParticipants =
        courseParticipants.length + (addBotToAvailableUsers ? 1 : 0);
    return availableParticipants >= (activity?.req.numberOfParticipants ?? 0);
  }

  Future<void> _loadActivity() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      if (parent?.coursePlan != null) {
        course = await CoursePlansRepo.get(parent!.coursePlan!.uuid);
      }

      final activities = await CourseActivityRepo.get(
        widget.activityId,
        [widget.activityId],
      );

      if (activities.isEmpty) {
        throw Exception("Activity not found");
      }

      if (mounted) setState(() => activity = activities.first);
    } catch (e) {
      if (mounted) setState(() => error = e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> confirmRoleSelection() async {
    if (state != SessionState.selectedRole) return;
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          await room!.joinActivity(
            activity!.roles[_selectedRoleId!]!,
          );

          try {
            await parent!.joinCourseActivity(
              widget.activityId,
              room!.id,
            );
          } catch (e, s) {
            ErrorHandler.logError(
              e: e,
              s: s,
              data: {
                "activityId": widget.activityId,
                "parentId": widget.parentId,
              },
            );
          }
        },
      );
    } else {
      final resp = await showFutureLoadingDialog(
        context: context,
        future: () => parent!.launchActivityRoom(
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

    final sessionIds = parent!.openSessions(widget.activityId);
    String? joinedSessionId;
    for (final sessionId in sessionIds) {
      try {
        await parent!.client.joinRoom(
          sessionId,
          via: parent?.spaceChildren
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

    final room = parent!.client.getRoomById(joinedSessionId);
    if (room == null || room.membership != Membership.join) {
      await parent!.client.waitForRoomInSync(joinedSessionId, join: true);
    }

    return joinedSessionId;
  }

  Future<void> pingCourse() async {
    if (room?.courseParent == null) {
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

    await room!.courseParent!.sendEvent(
      {
        "body": L10n.of(context).pingParticipantsNotification(
          room!.client.userID!.localpart ?? room!.client.userID!,
          room!.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
        ),
        "msgtype": "m.text",
        "pangea.activity.session_room_id": room!.id,
      },
    );

    if (mounted) setState(() {});
  }

  Future<void> playWithBot() async {
    if (room == null) {
      throw Exception("Room is null");
    }

    if (isBotRoomMember) {
      throw Exception("Bot is a member of the room");
    }

    final future = room!.client.onRoomState.stream
        .where(
          (state) =>
              state.roomId == room!.id &&
              state.state.type == PangeaEventTypes.activityRole &&
              state.state.senderId == BotName.byEnvironment,
        )
        .first;
    room!.invite(BotName.byEnvironment);
    await future.timeout(const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) => ActivitySessionStartView(this);
}
