import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat_list/widgets/public_room_bottom_sheet.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_view.dart';
import 'package:fluffychat/pangea/course_chats/course_default_chats_enum.dart';
import 'package:fluffychat/pangea/course_chats/extended_space_rooms_chunk.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/join_codes/knock_room_extension.dart';
import 'package:fluffychat/pangea/navigation/navigation_util.dart';
import 'package:fluffychat/pangea/spaces/space_constants.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseChats extends StatefulWidget {
  final Client client;
  final String roomId;
  final String? activeChat;

  const CourseChats(
    this.roomId, {
    super.key,
    required this.activeChat,
    required this.client,
  });

  @override
  State<CourseChats> createState() => CourseChatsController();
}

class CourseChatsController extends State<CourseChats>
    with ActivitySummariesProvider, CoursePlanProvider {
  String get roomId => widget.roomId;
  Room? get room => widget.client.getRoomById(widget.roomId);

  List<SpaceRoomsChunk$2>? discoveredChildren;
  StreamSubscription? _roomSubscription;
  String? _nextBatch;
  bool noMoreRooms = false;
  bool isLoading = false;

  @override
  void initState() {
    loadHierarchy(reload: true).then((_) => _joinDefaultChats());

    // Listen for changes to the activeSpace's hierarchy,
    // and reload the hierarchy when they come through
    _roomSubscription?.cancel();
    _roomSubscription = widget.client.onSync.stream
        .where(_hasHierarchyUpdate)
        .listen((update) => loadHierarchy(reload: true));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CourseChats oldWidget) {
    // initState doesn't re-run when navigating between spaces
    // via the navigation rail, so this accounts for that
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId) {
      _roomSubscription?.cancel();
      _roomSubscription = widget.client.onSync.stream
          .where(_hasHierarchyUpdate)
          .listen((update) => loadHierarchy(reload: true));

      discoveredChildren = null;
      _nextBatch = null;
      noMoreRooms = false;

      loadHierarchy(reload: true);
    }
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }

  Set<String> get childrenIds =>
      room?.spaceChildren.map((c) => c.roomId).whereType<String>().toSet() ??
      {};

  List<Room> get joinedRooms => Matrix.of(context).client.rooms
      .where((room) => childrenIds.contains(room.id))
      .where((room) => !room.isHiddenRoom)
      .toList();

  List<Room> joinedActivities() =>
      joinedRooms.where((r) => r.isActivitySession).toList();

  List<SpaceRoomsChunk$2> get discoveredGroupChats => (discoveredChildren ?? [])
      .where(
        (chunk) =>
            chunk.roomType == null ||
            !chunk.roomType!.startsWith(PangeaRoomTypes.activitySession),
      )
      .toList();

  Map<String, List<ExtendedSpaceRoomsChunk>> discoveredActivities() {
    if (discoveredChildren == null || roomSummaries == null) return {};
    final Map<String, List<ExtendedSpaceRoomsChunk>> sessionsMap = {};

    final validIDs = course?.activityIDs ?? {};
    for (final chunk in discoveredChildren!) {
      if (chunk.roomType?.startsWith(PangeaRoomTypes.activitySession) != true) {
        continue;
      }

      final summary = roomSummaries?[chunk.roomId];
      if (summary == null) {
        continue;
      }

      final activity = summary.activityPlan;
      final roles = summary.activityRoles;
      final users = summary.joinedUsersWithRoles;

      if (activity == null ||
          roles == null ||
          users.isEmpty ||
          !validIDs.contains(activity.activityId)) {
        continue;
      }

      if (activity.req.numberOfParticipants <= users.length) {
        // Don't show full activities
        continue;
      }

      // If any user has archived the activity, don't show it.
      // It's possible for users to finish an activity and then for some of the
      // users to leave, but if the activity was archived by anyone, that means
      // it was full at some point.
      if (roles.roles.values.any((role) => role.isArchived)) {
        continue;
      }

      sessionsMap[activity.activityId] ??= [];
      sessionsMap[activity.activityId]!.add(
        ExtendedSpaceRoomsChunk(
          chunk: chunk,
          assignedRoles: users.values.toList(),
          activity: activity,
        ),
      );
    }

    return sessionsMap;
  }

  List<Room> get joinedChats =>
      joinedRooms.where((room) => !room.isActivitySession).toList();

  Future<void> _joinDefaultChats() async {
    if (discoveredChildren == null) return;
    final found = List<SpaceRoomsChunk$2>.from(discoveredChildren!);

    final List<Future> joinFutures = [];
    for (final chunk in found) {
      if (chunk.canonicalAlias == null) continue;
      final alias = chunk.canonicalAlias!;

      final isDefaultChat =
          (alias.localpart ?? '').startsWith(
            SpaceConstants.announcementsChatAlias,
          ) ||
          (alias.localpart ?? '').startsWith(
            SpaceConstants.introductionChatAlias,
          );

      if (!isDefaultChat) continue;

      joinFutures.add(
        widget.client
            .joinRoom(alias)
            .then((_) {
              discoveredChildren?.remove(chunk);
            })
            .catchError((e, s) {
              ErrorHandler.logError(
                e: e,
                s: s,
                data: {'alias': alias, 'spaceId': widget.roomId},
              );
              return null;
            }),
      );
    }

    if (joinFutures.isNotEmpty) {
      await Future.wait(joinFutures);
    }
  }

  Future<void> loadHierarchy({bool reload = false}) async {
    final room = widget.client.getRoomById(widget.roomId);
    if (room == null) return;

    if (mounted) setState(() => isLoading = true);

    try {
      await _loadHierarchy(activeSpace: room, reload: reload);
      if (mounted) {
        final futures = [
          loadRoomSummaries(
            room.spaceChildren
                .map((c) => c.roomId)
                .whereType<String>()
                .toList(),
          ),
          if (room.coursePlan?.uuid != null) loadCourse(room.coursePlan!.uuid),
        ];
        await Future.wait(futures);
        if (mounted) {
          await loadTopics();
        }
      }
    } catch (e, s) {
      Logs().w('Unable to load hierarchy', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toLocalizedString(context)),
            showCloseIcon: true,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Internal logic of loadHierarchy. It will load the hierarchy of
  /// the active space id (or specified spaceId).
  /// If [reload] is true, it will reload the entire hierarchy (used when room
  /// is added/removed from the space)
  /// If [reload] is false, it will load the next set of rooms
  Future<void> _loadHierarchy({
    required Room activeSpace,
    bool reload = false,
  }) async {
    // Load all of the space's state events. Space Child events
    // are used to filtering out unsuggested, unjoined rooms.
    final requestSpaceId = widget.roomId;
    await activeSpace.postLoad();

    // The current number of rooms loaded for this space that are visible in the UI
    final int prevLength = !reload ? (discoveredChildren?.length ?? 0) : 0;

    // Failsafe to prevent too many calls to the server in a row
    int callsToServer = 0;

    List<SpaceRoomsChunk$2>? currentHierarchy =
        discoveredChildren == null || reload
        ? null
        : List.from(discoveredChildren!);
    String? currentNextBatch = reload ? null : _nextBatch;

    // Makes repeated calls to the server until 10 new visible rooms have
    // been loaded, or there are no rooms left to load. Using a loop here,
    // rather than one single call to the endpoint, because some spaces have
    // so many invisible rooms (analytics rooms) that it might look like
    // pressing the 'load more' button does nothing (Because the only rooms
    // coming through from those calls are analytics rooms).
    while (callsToServer < 5) {
      // if this space has been loaded and there are no more rooms to load, break
      if (currentHierarchy != null && currentNextBatch == null) {
        break;
      }

      // if this space has been loaded and 10 new rooms have been loaded, break
      final int currentLength = currentHierarchy?.length ?? 0;
      if (currentLength - prevLength >= 10) {
        break;
      }

      // make the call to the server
      final response = await widget.client.getSpaceHierarchy(
        widget.roomId,
        maxDepth: 1,
        from: currentNextBatch,
        limit: 100,
      );

      if (widget.roomId != requestSpaceId) {
        // The user has navigated to a different space since this call was made, so we should discard the response and not update the state
        return;
      }

      callsToServer++;

      if (response.nextBatch == null) {
        noMoreRooms = true;
      }

      // if rooms have earlier been loaded for this space, add those
      // previously loaded rooms to the front of the response list
      response.rooms.insertAll(0, currentHierarchy ?? []);

      // finally, set the response to the last response for this space
      // and set the current next batch token
      currentHierarchy = _filterHierarchyResponse(activeSpace, response.rooms);
      currentNextBatch = response.nextBatch;
    }

    if (widget.roomId != requestSpaceId) {
      // The user has navigated to a different space since the first call was made, so we should discard the response and not update the state
      return;
    }

    discoveredChildren = currentHierarchy;
    discoveredChildren?.sort(_sortSpaceChildren);
    _nextBatch = currentNextBatch;
  }

  void onChatTap(Room room) async {
    if (room.membership == Membership.invite) {
      if (room.hasKnocked) {
        if (!mounted) return;
        await showFutureLoadingDialog(
          context: context,
          future: () async {
            final waitForRoom = room.client.waitForRoomInSync(
              room.id,
              join: true,
            );
            await room.joinKnockedRoom();
            await waitForRoom;
          },
          exceptionContext: ExceptionContext.joinRoom,
        );
      } else {
        final theme = Theme.of(context);
        final inviteEvent = room.getState(
          EventTypes.RoomMember,
          room.client.userID!,
        );
        final matrixLocals = MatrixLocals(L10n.of(context));
        final action = await showAdaptiveDialog<InviteAction>(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256),
              child: Center(
                child: Text(
                  room.getLocalizedDisplayname(matrixLocals),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
              child: Text(
                inviteEvent == null
                    ? L10n.of(context).inviteForMe
                    : inviteEvent.content.tryGet<String>('reason') ??
                          L10n.of(context).youInvitedBy(
                            room
                                .unsafeGetUserFromMemoryOrFallback(
                                  inviteEvent.senderId,
                                )
                                .calcDisplayname(i18n: matrixLocals),
                          ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: [
              AdaptiveDialogAction(
                onPressed: () => Navigator.of(context).pop(InviteAction.accept),
                bigButtons: true,
                child: Text(L10n.of(context).accept),
              ),
              AdaptiveDialogAction(
                onPressed: () =>
                    Navigator.of(context).pop(InviteAction.decline),
                bigButtons: true,
                child: Text(
                  L10n.of(context).decline,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
              AdaptiveDialogAction(
                onPressed: () => Navigator.of(context).pop(InviteAction.block),
                bigButtons: true,
                child: Text(
                  L10n.of(context).block,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        );
        switch (action) {
          case null:
            return;
          case InviteAction.accept:
            break;
          case InviteAction.decline:
            await showFutureLoadingDialog(
              context: context,
              future: () => room.leave(),
            );
            return;
          case InviteAction.block:
            final userId = inviteEvent?.senderId;
            context.go('/rooms/settings/security/ignorelist', extra: userId);
            return;
        }
        if (!mounted) return;
        final joinResult = await showFutureLoadingDialog(
          context: context,
          future: () async {
            final waitForRoom = room.client.waitForRoomInSync(
              room.id,
              join: true,
            );
            await room.join();
            await waitForRoom;
          },
          exceptionContext: ExceptionContext.joinRoom,
        );
        if (joinResult.error != null) return;
      }
    }

    if (room.membership == Membership.ban) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).youHaveBeenBannedFromThisChat)),
      );
      return;
    }

    if (room.membership == Membership.leave) {
      context.go('/rooms/archive/${room.id}');
      return;
    }

    if (room.isSpace) {
      context.go("/rooms/spaces/${room.id}/details");
      return;
    }

    NavigationUtil.goToSpaceRoute(room.id, [], context);
  }

  void joinChildRoom(SpaceRoomsChunk$2 item) async {
    final space = widget.client.getRoomById(widget.roomId);
    final roomId = await PublicRoomBottomSheet.show(
      context: context,
      chunk: item,
      via: space?.spaceChildren
          .firstWhereOrNull((child) => child.roomId == item.roomId)
          ?.via,
    );
    if (mounted && roomId != null) {
      setState(() {
        discoveredChildren?.remove(item);
      });

      NavigationUtil.goToSpaceRoute(roomId, [], context);
    }
  }

  Future<void> joinActivity(
    String activityId,
    ExtendedSpaceRoomsChunk chunk,
  ) async {
    final hasRole = chunk.assignedRoles.any(
      (role) => role.userId == widget.client.userID,
    );
    final roomId = chunk.chunk.roomId;
    if (!hasRole) {
      context.go(
        "/rooms/spaces/${widget.roomId}/activity/$activityId?roomid=$roomId",
      );
      return;
    }

    await widget.client.joinRoom(
      roomId,
      via: widget.client
          .getRoomById(widget.roomId)
          ?.spaceChildren
          .firstWhereOrNull((child) => child.roomId == roomId)
          ?.via,
    );

    final room = widget.client.getRoomById(roomId);
    if (room == null || room.membership != Membership.join) {
      await widget.client.waitForRoomInSync(roomId, join: true);
    }

    if (widget.client.getRoomById(roomId) == null) {
      throw Exception("Failed to join room");
    }

    context.go("/rooms/spaces/${widget.roomId}/$roomId");
  }

  bool _includeSpaceChild(Room space, SpaceRoomsChunk$2 hierarchyMember) {
    if (!mounted) return false;
    final bool isAnalyticsRoom =
        hierarchyMember.roomType == PangeaRoomTypes.analytics;

    final bool isMember = [
      Membership.join,
      Membership.invite,
    ].contains(widget.client.getRoomById(hierarchyMember.roomId)?.membership);

    final bool isSuggested =
        space.spaceChildSuggestionStatus[hierarchyMember.roomId] ?? true;

    return !isAnalyticsRoom && (isMember || isSuggested);
  }

  List<SpaceRoomsChunk$2> _filterHierarchyResponse(
    Room space,
    List<SpaceRoomsChunk$2> hierarchyResponse,
  ) {
    final List<SpaceRoomsChunk$2> filteredChildren = [];
    for (final child in hierarchyResponse) {
      if (child.roomId == widget.roomId) {
        continue;
      }

      final room = space.client.getRoomById(child.roomId);
      if (room != null && room.membership != Membership.leave) {
        // If the room is already joined or invited, skip it
        continue;
      }

      final isDuplicate = filteredChildren.any(
        (filtered) => filtered.roomId == child.roomId,
      );
      if (isDuplicate) continue;

      if (_includeSpaceChild(space, child)) {
        filteredChildren.add(child);
      }
    }
    return filteredChildren;
  }

  /// Used to filter out sync updates with hierarchy updates for the active
  /// space so that the view can be auto-reloaded in the room subscription
  bool _hasHierarchyUpdate(SyncUpdate update) {
    final joinUpdate = update.rooms?.join;
    final inviteUpdate = update.rooms?.invite;
    final leaveUpdate = update.rooms?.leave;
    if (joinUpdate == null && leaveUpdate == null && inviteUpdate == null) {
      return false;
    }

    final joinedRooms = joinUpdate?.entries
        .where((e) => childrenIds.contains(e.key))
        .map((e) => e.value.timeline?.events)
        .whereType<List<MatrixEvent>>();

    final invitedRooms = inviteUpdate?.entries
        .where((e) => childrenIds.contains(e.key))
        .map((e) => e.value.inviteState)
        .whereType<List<StrippedStateEvent>>();

    final leftRooms = leaveUpdate?.entries
        .where((e) => childrenIds.contains(e.key))
        .map((e) => e.value.timeline?.events)
        .whereType<List<MatrixEvent>>();

    final bool hasJoinedRoom =
        joinedRooms?.any(
          (events) => events.any(
            (e) =>
                e.senderId == widget.client.userID &&
                e.type == EventTypes.RoomMember,
          ),
        ) ??
        false;

    final bool hasLeftRoom =
        leftRooms?.any(
          (events) => events.any(
            (e) =>
                e.senderId == widget.client.userID &&
                e.type == EventTypes.RoomMember,
          ),
        ) ??
        false;

    if (hasJoinedRoom || hasLeftRoom || (invitedRooms?.isNotEmpty ?? false)) {
      return true;
    }

    final joinTimeline = joinUpdate?[widget.roomId]?.timeline?.events;
    final leaveTimeline = leaveUpdate?[widget.roomId]?.timeline?.events;
    if (joinTimeline == null && leaveTimeline == null) return false;

    final bool hasJoinUpdate =
        joinTimeline?.any((event) => event.type == EventTypes.SpaceChild) ??
        false;
    final bool hasLeaveUpdate =
        leaveTimeline?.any((event) => event.type == EventTypes.SpaceChild) ??
        false;
    return hasJoinUpdate || hasLeaveUpdate;
  }

  int _sortSpaceChildren(SpaceRoomsChunk$2 a, SpaceRoomsChunk$2 b) {
    final bool aIsSpace = a.roomType == 'm.space';
    final bool bIsSpace = b.roomType == 'm.space';

    if (aIsSpace && !bIsSpace) {
      return -1;
    } else if (!aIsSpace && bIsSpace) {
      return 1;
    }
    return 0;
  }

  bool showDefaultChatCreation(CourseDefaultChatsEnum type) {
    if (room == null || !room!.isRoomAdmin) return false;
    return !room!.dismissedDefaultChat(type) && !room!.hasDefaultChat(type);
  }

  Future<void> dismissDefaultChatCreation(CourseDefaultChatsEnum type) async {
    if (room == null) {
      throw Exception("Room is null");
    }

    final settings = switch (type) {
      CourseDefaultChatsEnum.introductions =>
        room!.courseChatsSettings.copyWith(dismissedIntroChat: true),
      CourseDefaultChatsEnum.announcements =>
        room!.courseChatsSettings.copyWith(dismissedAnnouncementsChat: true),
    };
    await room!.setCourseChatsSettings(settings);
  }

  Future<void> createDefaultChat(CourseDefaultChatsEnum type) async {
    if (room == null) {
      throw Exception("Room is null");
    }

    final roomId = await room!.addDefaultChat(
      type: type,
      name: type.title(L10n.of(context)),
    );

    context.go('/rooms/spaces/${widget.roomId}/$roomId');
  }

  @override
  Widget build(BuildContext context) => CourseChatsView(this);
}
