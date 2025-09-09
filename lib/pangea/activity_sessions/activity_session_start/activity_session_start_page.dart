import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_sessions_start_view.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/course_plans/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
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
  final String parentId;
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
  bool loading = true;
  Object? error;

  bool showInstructions = false;
  String? _selectedRoleId;

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

  Room? get room => widget.room;

  Room? get parent => Matrix.of(context).client.getRoomById(
        widget.parentId,
      );

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

  Future<void> _loadActivity() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

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

  Future<void> onTap() async {
    if (state != SessionState.selectedRole) return;
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => room!.joinActivity(
          activity!.roles[_selectedRoleId!]!,
        ),
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

  Future<void> pingCourse() async {
    if (room?.courseParent == null) {
      throw Exception("Activity is not part of a course");
    }

    await room!.courseParent!.sendTextEvent(
      L10n.of(context).pingParticipantsNotification(
        room!.client.userID!.localpart ?? room!.client.userID!,
        room!.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ActivitySessionStartView(this);
}
