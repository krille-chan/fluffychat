import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_sessions_start_view.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum SessionState {
  notStarted,
  notSelectedRole,
  selectedRole,
  confirmedRole,
}

class ActivitySessionStartPage extends StatefulWidget {
  final Room room;
  const ActivitySessionStartPage({
    super.key,
    required this.room,
  });

  @override
  ActivitySessionStartController createState() =>
      ActivitySessionStartController();
}

class ActivitySessionStartController extends State<ActivitySessionStartPage> {
  bool _started = false;

  bool showInstructions = false;
  String? _selectedRoleId;

  @override
  void didUpdateWidget(covariant ActivitySessionStartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) {
      setState(() {
        _started = false;
        _selectedRoleId = null;
        showInstructions = false;
      });
    }
  }

  Room get room => widget.room;

  String get displayname => room.getLocalizedDisplayname(
        MatrixLocals(L10n.of(context)),
      );

  SessionState get state {
    if (room.ownRole != null) return SessionState.confirmedRole;
    if (_selectedRoleId != null) return SessionState.selectedRole;
    if (room.isRoomAdmin && !_started) return SessionState.notStarted;
    return SessionState.notSelectedRole;
  }

  String get descriptionText {
    switch (state) {
      case SessionState.confirmedRole:
        return L10n.of(context).waitingToFillRole(room.remainingRoles);
      case SessionState.selectedRole:
        return room.activityPlan!.learningObjective;
      case SessionState.notStarted:
        return L10n.of(context).letsGo;
      case SessionState.notSelectedRole:
        return room.isRoomAdmin
            ? L10n.of(context).chooseRole
            : L10n.of(context).chooseRoleToParticipate;
    }
  }

  String get buttonText => state == SessionState.notStarted
      ? L10n.of(context).start
      : L10n.of(context).confirm;

  bool get enableButtons => [
        SessionState.notStarted,
        SessionState.selectedRole,
      ].contains(state);

  bool canSelectParticipant(String id) {
    if (state == SessionState.confirmedRole) return false;

    final availableRoles = room.activityPlan!.roles;
    final assignedRoles = room.assignedRoles ?? {};
    final unassignedIds = availableRoles.keys
        .where((id) => !assignedRoles.containsKey(id))
        .toList();
    return unassignedIds.contains(id);
  }

  bool isParticipantSelected(String id) {
    if (state == SessionState.confirmedRole) {
      return room.ownRole?.id == id;
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

  Future<void> onTap() async {
    switch (state) {
      case SessionState.notStarted:
        if (mounted) setState(() => _started = true);
      case SessionState.selectedRole:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.joinActivity(
            room.activityPlan!.roles[_selectedRoleId!]!,
          ),
        );
        if (mounted) setState(() {});
      case SessionState.notSelectedRole:
      case SessionState.confirmedRole:
        break;
    }
  }

  Future<void> pingCourse() async {
    if (room.courseParent == null) {
      throw Exception("Activity is not part of a course");
    }

    await room.courseParent!.sendTextEvent("");
  }

  @override
  Widget build(BuildContext context) => ActivitySessionStartView(this);
}
