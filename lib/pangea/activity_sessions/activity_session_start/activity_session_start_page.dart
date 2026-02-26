import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_sessions_start_view.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/bot_join_error_dialog.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_translation_request.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/navigation/navigation_util.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum SessionState {
  /// The room hasn't been created yet
  notStarted,

  /// The room has been created but the user hasn't selected a role yet. Non-admins haven't joined yet.
  notSelectedRole,

  /// The room has been created and all roles are full. The user cannot get a role in this session.
  selectedSessionFull,

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

  bool loading = true;
  Object? error;

  bool showInstructions = false;
  String? _selectedRoleId;

  Timer? _pingCooldown;
  final ScrollController scrollController = ScrollController();

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

      _load();
    }
  }

  @override
  void dispose() {
    _pingCooldown?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  Room? get activityRoom => widget.roomId != null
      ? Matrix.of(context).client.getRoomById(widget.roomId!)
      : null;

  Room? get courseParent => widget.parentId != null
      ? Matrix.of(context).client.getRoomById(widget.parentId!)
      : null;

  bool get isBotRoomMember =>
      activityRoom?.getParticipants().any(
        (p) => p.id == BotName.byEnvironment,
      ) ??
      false;

  SessionState get state {
    // the room exists and user has set their role
    if (activityRoom?.membership == Membership.join &&
        activityRoom?.hasPickedRole == true) {
      return SessionState.confirmedRole;
    }

    // the user has selected a role but hasn't confirmed yet
    if (_selectedRoleId != null) {
      return SessionState.selectedRole;
    }

    // the room either doesn't exist or the user hasn't joined it yet
    if (activityRoom == null || activityRoom!.membership != Membership.join) {
      // If the room does exist or is being created, then user needs to select a role.
      // Else (room doesn't exist and user hasn't started creating it), then not started.
      return widget.roomId != null || widget.launch
          ? canSelectRole
                ? SessionState.notSelectedRole
                : SessionState.selectedSessionFull
          : SessionState.notStarted;
    }

    return canSelectRole
        ? SessionState.notSelectedRole
        : SessionState.selectedSessionFull;
  }

  String? get descriptionText {
    switch (state) {
      case SessionState.confirmedRole:
        return L10n.of(
          context,
        ).waitingToFillRole(activityRoom!.numRemainingRoles);
      case SessionState.selectedRole:
        return activity!.roles[_selectedRoleId!]!.goal;
      case SessionState.notStarted:
        if (joinedActivityRoomId != null) {
          return L10n.of(context).inOngoingActivity;
        }
        return null;

      case SessionState.notSelectedRole:
        return activityRoom?.isRoomAdmin ?? false
            ? L10n.of(context).chooseRole
            : L10n.of(context).chooseRoleToParticipate;
      case SessionState.selectedSessionFull:
        return L10n.of(context).sessionFull;
    }
  }

  Map<String, ActivityRoleModel> get assignedRoles {
    if (activityRoom != null && activityRoom!.membership == Membership.join) {
      return activityRoom!.assignedRoles ?? {};
    }
    return roomSummaries?[widget.roomId]?.joinedUsersWithRoles ?? {};
  }

  bool get canSelectRole {
    final assigned = assignedRoles.length;
    final total = activity?.roles.length ?? 0;
    return assigned < total;
  }

  bool canSelectParticipant(String id) {
    if (state == SessionState.confirmedRole ||
        state == SessionState.notStarted) {
      return false;
    }

    final availableRoles = activity!.roles;
    final assignedRoles =
        activityRoom?.assignedRoles ??
        roomSummaries?[widget.roomId]?.joinedUsersWithRoles ??
        {};
    final unassignedIds = availableRoles.keys
        .where((id) => !assignedRoles.containsKey(id))
        .toList();
    return unassignedIds.contains(id);
  }

  bool isParticipantShimmering(String id) {
    if (state != SessionState.notSelectedRole) {
      return false;
    }

    final availableRoles = activity!.roles;
    final assignedRoles =
        activityRoom?.assignedRoles ??
        roomSummaries?[widget.roomId]?.activityRoles?.roles ??
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

  String? get joinedActivityRoomId =>
      courseParent?.activeActivityRoomId(widget.activityId);

  bool get canPingParticipants {
    if (activityRoom == null || courseParent == null) return false;
    if (_pingCooldown != null && _pingCooldown!.isActive) return false;

    final courseParticipants = courseParent!.getParticipants();
    final roomParticipants = activityRoom!.getParticipants();
    for (final p in courseParticipants) {
      if (p.id == BotName.byEnvironment) continue;
      if (roomParticipants.any((rp) => rp.id == p.id)) continue;
      return true;
    }
    return false;
  }

  void startNewActivity() {
    scrollController.jumpTo(0);
    context.go(
      "/rooms/spaces/${widget.parentId}/activity/${widget.activityId}?launch=true",
    );
  }

  Map<ActivitySummaryStatus, Map<String, RoomSummaryResponse>>
  get activityStatuses => activitySessionStatuses(widget.activityId);

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
    final courseParticipants =
        await courseParent?.requestParticipants(
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

      // load the course participants, since we will need that
      // info to determine if course pinging is enabled
      if (courseParent != null) {
        futures.add(
          courseParent!.requestParticipants(
            [Membership.join, Membership.invite, Membership.knock],
            false,
            true,
          ),
        );
      }
      await Future.wait(futures);
    } catch (e, s) {
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "activityId": widget.activityId,
          "roomId": widget.roomId,
          "parentId": widget.parentId,
        },
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _loadSummary() async {
    final Set<String> roomIds = {};
    if (widget.roomId != null) {
      roomIds.add(widget.roomId!);
    }

    if (courseParent != null) {
      roomIds.addAll(
        courseParent!.spaceChildren.map((c) => c.roomId).whereType<String>(),
      );
    }

    if (roomIds.isEmpty) return;
    await loadRoomSummaries(roomIds.toList());
  }

  Future<void> _loadActivity() async {
    final activitiesResponse = await CourseActivityRepo.get(
      TranslateActivityRequest(
        activityIds: [widget.activityId],
        l1: MatrixState.pangeaController.userController.userL1Code!,
      ),
      widget.activityId,
    );
    final activities = activitiesResponse.plans.values.toList();

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
            .firstWhereOrNull((child) => child.roomId == widget.roomId)
            ?.via,
      );

      if (activityRoom == null || activityRoom!.membership != Membership.join) {
        await client.waitForRoomInSync(widget.roomId!, join: true);
      }

      if (activityRoom == null || activityRoom!.membership != Membership.join) {
        throw Exception(
          "Failed to join activity room. "
          "Room ID: ${widget.roomId}, "
          "Membership status: ${activityRoom?.membership}",
        );
      }
    }

    try {
      // Since the method that check for assigned roles needs to know each
      // participant's membership status (to exclude left users), we need
      // to pre-load the room's participants list.
      activityRoom!.requestParticipants(
        [Membership.join, Membership.invite, Membership.knock],
        false,
        true,
      );

      await activityRoom!.joinActivity(activity!.roles[_selectedRoleId!]!);
    } catch (e) {
      if (e is! RoleException) {
        rethrow;
      }
    }

    NavigationUtil.goToSpaceRoute(widget.roomId, [], context);
  }

  Future<void> confirmRoleSelection() async {
    if (state != SessionState.selectedRole) return;
    if (activityRoom?.membership == Membership.join) {
      await showFutureLoadingDialog(
        context: context,
        future: () =>
            activityRoom!.joinActivity(activity!.roles[_selectedRoleId!]!),
      );
    } else if (widget.roomId != null) {
      await showFutureLoadingDialog(context: context, future: joinActivity);
    } else {
      final resp = await showFutureLoadingDialog(
        context: context,
        future: () => courseParent!.launchActivityRoom(
          activity!,
          activity!.roles[_selectedRoleId!],
        ),
      );

      if (!resp.isError) {
        NavigationUtil.goToSpaceRoute(resp.result, [], context);
      }
    }
  }

  Future<void> joinExistingSession() async {
    final resp = await showFutureLoadingDialog(
      context: context,
      future: _joinExistingSession,
    );

    if (!resp.isError) {
      NavigationUtil.goToSpaceRoute(resp.result, [], context);
    }
  }

  Future<String> _joinExistingSession() async {
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
              .firstWhereOrNull((child) => child.roomId == sessionId)
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

  Future<void> joinActivityByRoomId(String roomId) async {
    final room = Matrix.of(context).client.getRoomById(roomId);
    if (room != null && room.membership == Membership.join) {
      NavigationUtil.goToSpaceRoute(roomId, [], context);
      return;
    }

    final resp = await showFutureLoadingDialog(
      context: context,
      future: () async {
        await courseParent!.client.joinRoom(
          roomId,
          via: courseParent?.spaceChildren
              .firstWhereOrNull((child) => child.roomId == roomId)
              ?.via,
        );

        final room = courseParent!.client.getRoomById(roomId);
        if (room == null || room.membership != Membership.join) {
          await courseParent!.client.waitForRoomInSync(roomId, join: true);
        }
      },
    );

    if (!resp.isError) {
      NavigationUtil.goToSpaceRoute(roomId, [], context);
    }
  }

  Future<void> pingCourse() =>
      showFutureLoadingDialog(context: context, future: _pingCourse);

  Future<void> _pingCourse() async {
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

    await activityRoom!.courseParent!.sendEvent({
      "body": L10n.of(context).pingParticipantsNotification(
        activityRoom!.client.userID!.localpart ?? activityRoom!.client.userID!,
        activityRoom!.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
      ),
      "msgtype": "m.text",
      "pangea.activity.session_room_id": activityRoom!.id,
      "pangea.activity.id": widget.activityId,
    });

    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).pingSent, textAlign: TextAlign.center),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  Future<void> playWithBot() async {
    final resp = await showFutureLoadingDialog(
      context: context,
      future: _playWithBot,
      showError: (e) => e is! TimeoutException,
    );

    if (resp.isError && resp.error is TimeoutException) {
      showDialog(context: context, builder: (_) => const BotJoinErrorDialog());
    }
  }

  Future<void> _playWithBot() async {
    if (activityRoom == null) {
      throw Exception("Room is null");
    }

    if (isBotRoomMember) {
      throw Exception("Bot is a member of the room");
    }

    final Future<({String roomId, StrippedStateEvent state})?> future =
        activityRoom!.client.onRoomState.stream
            .where(
              (state) =>
                  state.roomId == activityRoom!.id &&
                  state.state.type == PangeaEventTypes.activityRole &&
                  state.state.senderId == BotName.byEnvironment,
            )
            .first;
    activityRoom!.invite(BotName.byEnvironment);
    await future.timeout(const Duration(seconds: 5));
  }

  void inviteFriends() {
    if (activityRoom == null) return;
    NavigationUtil.goToSpaceRoute(activityRoom!.id, ['invite'], context);
  }

  void inviteToCourse() {
    if (courseParent == null) return;
    context.push("/rooms/spaces/${courseParent!.id}/invite");
  }

  void goToCourse() {
    if (courseParent == null) return;
    context.push("/rooms/spaces/${courseParent!.id}/details?tab=course");
  }

  void goToJoinedActivity() {
    if (joinedActivityRoomId == null) return;
    NavigationUtil.goToSpaceRoute(joinedActivityRoomId!, [], context);
  }

  void returnFromFullSession() {
    if (courseParent != null) {
      goToCourse();
    } else {
      NavigationUtil.goToSpaceRoute(null, [], context);
    }
  }

  @override
  Widget build(BuildContext context) => ActivitySessionStartView(this);
}
