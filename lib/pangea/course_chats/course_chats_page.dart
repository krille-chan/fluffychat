import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/chat_settings/utils/delete_room.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/delete_space_dialog.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_view.dart';
import 'package:fluffychat/pangea/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/public_spaces/public_room_bottom_sheet.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

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

class CourseChatsController extends State<CourseChats> {
  String get roomId => widget.roomId;
  Room? get room => widget.client.getRoomById(widget.roomId);

  List<SpaceRoomsChunk>? discoveredChildren;
  StreamSubscription? _roomSubscription;
  String? _nextBatch;
  bool noMoreRooms = false;
  bool isLoading = false;

  CoursePlanModel? course;
  String? selectedTopicId;

  @override
  void initState() {
    loadHierarchy(reload: true);

    // Listen for changes to the activeSpace's hierarchy,
    // and reload the hierarchy when they come through
    _roomSubscription ??= widget.client.onSync.stream
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

  void setCourse(CoursePlanModel? course) {
    setState(() {
      this.course = course;
    });
  }

  void setSelectedTopicId(String topicID) {
    setState(() {
      selectedTopicId = topicID;
    });
  }

  int get _selectedTopicIndex =>
      course?.topics.indexWhere((t) => t.uuid == selectedTopicId) ?? -1;

  bool get canMoveLeft => _selectedTopicIndex > 0;
  bool get canMoveRight {
    if (course == null) return false;
    final endIndex =
        room?.ownCurrentTopicIndex(course!) ?? (course!.topics.length - 1);
    return _selectedTopicIndex < endIndex;
  }

  void moveLeft() {
    if (canMoveLeft) {
      setSelectedTopicId(course!.topics[_selectedTopicIndex - 1].uuid);
    }
  }

  void moveRight() {
    if (canMoveRight) {
      setSelectedTopicId(course!.topics[_selectedTopicIndex + 1].uuid);
    }
  }

  Topic? get selectedTopic => course?.topics.firstWhereOrNull(
        (topic) => topic.uuid == selectedTopicId,
      );

  Future<void> _joinDefaultChats() async {
    if (discoveredChildren == null) return;
    final found = List<SpaceRoomsChunk>.from(discoveredChildren!);

    final List<Future> joinFutures = [];
    for (final chunk in found) {
      if (chunk.canonicalAlias == null) continue;
      final alias = chunk.canonicalAlias!;

      final isDefaultChat = (alias.localpart ?? '')
              .startsWith(SpaceConstants.announcementsChatAlias) ||
          (alias.localpart ?? '')
              .startsWith(SpaceConstants.introductionChatAlias);

      if (!isDefaultChat) continue;

      joinFutures.add(
        widget.client.joinRoom(alias).then((_) {
          discoveredChildren?.remove(chunk);
        }).catchError((e, s) {
          ErrorHandler.logError(
            e: e,
            s: s,
            data: {
              'alias': alias,
              'spaceId': widget.roomId,
            },
          );
          return null;
        }),
      );
    }

    if (joinFutures.isNotEmpty) {
      await Future.wait(joinFutures);
    }
  }

  Future<void> loadHierarchy({reload = false}) async {
    final room = widget.client.getRoomById(widget.roomId);
    if (room == null) return;

    if (mounted) setState(() => isLoading = true);

    try {
      await _loadHierarchy(activeSpace: room, reload: reload);
      await _joinDefaultChats();
    } catch (e, s) {
      Logs().w('Unable to load hierarchy', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toLocalizedString(context))),
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
    await activeSpace.postLoad();

    // The current number of rooms loaded for this space that are visible in the UI
    final int prevLength = !reload ? (discoveredChildren?.length ?? 0) : 0;

    // Failsafe to prevent too many calls to the server in a row
    int callsToServer = 0;

    List<SpaceRoomsChunk>? currentHierarchy =
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
      callsToServer++;

      if (response.nextBatch == null) {
        noMoreRooms = true;
      }

      // if rooms have earlier been loaded for this space, add those
      // previously loaded rooms to the front of the response list
      response.rooms.insertAll(
        0,
        currentHierarchy ?? [],
      );

      // finally, set the response to the last response for this space
      // and set the current next batch token
      currentHierarchy = _filterHierarchyResponse(activeSpace, response.rooms);
      currentNextBatch = response.nextBatch;
    }

    discoveredChildren = currentHierarchy;
    discoveredChildren?.sort(_sortSpaceChildren);
    _nextBatch = currentNextBatch;
  }

  void onChatTap(Room room) async {
    if (room.membership == Membership.invite) {
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
              onPressed: () => Navigator.of(context).pop(InviteAction.decline),
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

    if (room.membership == Membership.ban) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).youHaveBeenBannedFromThisChat),
        ),
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

    context.go('/rooms/${room.id}');
  }

  void joinChildRoom(SpaceRoomsChunk item) async {
    final space = widget.client.getRoomById(widget.roomId);
    final joined = await PublicRoomBottomSheet.show(
      context: context,
      chunk: item,
      via: space?.spaceChildren
          .firstWhereOrNull(
            (child) => child.roomId == item.roomId,
          )
          ?.via,
    );
    if (mounted && joined == true) {
      setState(() {
        discoveredChildren?.remove(item);
      });
    }
  }

  void chatContextAction(
    Room room,
    BuildContext posContext, [
    Room? space,
  ]) async {
    final overlay =
        Overlay.of(posContext).context.findRenderObject() as RenderBox;

    final button = posContext.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, -65), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final displayname =
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)));

    final action = await showMenu<ChatContextAction>(
      context: posContext,
      position: position,
      items: [
        PopupMenuItem(
          value: ChatContextAction.open,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              Avatar(
                mxContent: room.avatar,
                name: displayname,
                userId: room.directChatMatrixID,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 128),
                child: Text(
                  displayname,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        if (space != null)
          PopupMenuItem(
            value: ChatContextAction.goToSpace,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(
                  mxContent: space.avatar,
                  size: Avatar.defaultSize / 2,
                  name: space.getLocalizedDisplayname(),
                  userId: space.directChatMatrixID,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10n.of(context).goToSpace(space.getLocalizedDisplayname()),
                  ),
                ),
              ],
            ),
          ),
        if (room.membership == Membership.join) ...[
          PopupMenuItem(
            value: ChatContextAction.mute,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.pushRuleState == PushRuleState.notify
                      ? Icons.notifications_on_outlined
                      : Icons.notifications_off_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.pushRuleState == PushRuleState.notify
                      ? L10n.of(context).notificationsOn
                      : L10n.of(context).notificationsOff,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ChatContextAction.markUnread,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.markedUnread
                      ? Icons.mark_as_unread
                      : Icons.mark_as_unread_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.markedUnread
                      ? L10n.of(context).markAsRead
                      : L10n.of(context).markAsUnread,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: ChatContextAction.favorite,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  room.isFavourite ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                const SizedBox(width: 12),
                Text(
                  room.isFavourite
                      ? L10n.of(context).unpin
                      : L10n.of(context).pin,
                ),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: ChatContextAction.leave,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout_outlined,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Text(
                room.membership == Membership.invite
                    ? L10n.of(context).delete
                    : L10n.of(context).leave,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
        if (room.isRoomAdmin && !room.isDirectChat)
          PopupMenuItem(
            value: ChatContextAction.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outlined,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  L10n.of(context).delete,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    if (action == null) return;
    if (!mounted) return;

    switch (action) {
      case ChatContextAction.open:
        onChatTap(room);
        return;
      case ChatContextAction.goToSpace:
        context.go("/rooms/spaces/${space!.id}/details");
        return;
      case ChatContextAction.favorite:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setFavourite(!room.isFavourite),
        );
        return;
      case ChatContextAction.markUnread:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.markUnread(!room.markedUnread),
        );
        return;
      case ChatContextAction.mute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(
            room.pushRuleState == PushRuleState.notify
                ? PushRuleState.mentionsOnly
                : PushRuleState.notify,
          ),
        );
        return;
      case ChatContextAction.leave:
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          message: room.isSpace
              ? L10n.of(context).leaveSpaceDescription
              : L10n.of(context).leaveRoomDescription,
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (confirmed != OkCancelResult.ok) return;
        if (!mounted) return;

        final resp = await showFutureLoadingDialog(
          context: context,
          future: room.isSpace ? room.leaveSpace : room.leave,
        );
        if (mounted && !resp.isError) {
          context.go("/rooms");
        }

        return;
      case ChatContextAction.delete:
        if (room.isSpace) {
          final resp = await showDialog<bool?>(
            context: context,
            builder: (_) => DeleteSpaceDialog(space: room),
          );
          if (resp == true && mounted) {
            context.go("/rooms");
          }
        } else {
          final confirmed = await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).delete,
            cancelLabel: L10n.of(context).cancel,
            isDestructive: true,
            message: room.isSpace
                ? L10n.of(context).deleteSpaceDesc
                : L10n.of(context).deleteChatDesc,
          );
          if (confirmed != OkCancelResult.ok) return;
          if (!mounted) return;

          final resp = await showFutureLoadingDialog(
            context: context,
            future: room.delete,
          );
          if (mounted && !resp.isError) {
            context.go("/rooms/spaces/${widget.roomId}/details");
          }
        }
        return;
    }
  }

  bool _includeSpaceChild(
    Room space,
    SpaceRoomsChunk hierarchyMember,
  ) {
    if (!mounted) return false;
    final bool isAnalyticsRoom =
        hierarchyMember.roomType == PangeaRoomTypes.analytics;

    final bool isMember = [Membership.join, Membership.invite].contains(
      widget.client.getRoomById(hierarchyMember.roomId)?.membership,
    );

    final bool isSuggested =
        space.spaceChildSuggestionStatus[hierarchyMember.roomId] ?? true;

    return !isAnalyticsRoom && (isMember || isSuggested);
  }

  List<SpaceRoomsChunk> _filterHierarchyResponse(
    Room space,
    List<SpaceRoomsChunk> hierarchyResponse,
  ) {
    final List<SpaceRoomsChunk> filteredChildren = [];
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
    final joinTimeline = update.rooms?.join?[widget.roomId]?.timeline;
    final leaveTimeline = update.rooms?.leave?[widget.roomId]?.timeline;
    if (joinTimeline == null && leaveTimeline == null) return false;
    final bool hasJoinUpdate = joinTimeline?.events?.any(
          (event) => event.type == EventTypes.SpaceChild,
        ) ??
        false;
    final bool hasLeaveUpdate = leaveTimeline?.events?.any(
          (event) => event.type == EventTypes.SpaceChild,
        ) ??
        false;
    return hasJoinUpdate || hasLeaveUpdate;
  }

  int _sortSpaceChildren(
    SpaceRoomsChunk a,
    SpaceRoomsChunk b,
  ) {
    final bool aIsSpace = a.roomType == 'm.space';
    final bool bIsSpace = b.roomType == 'm.space';

    if (aIsSpace && !bIsSpace) {
      return -1;
    } else if (!aIsSpace && bIsSpace) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) => CourseChatsView(this);
}
