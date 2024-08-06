import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/utils/on_chat_tap.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/chat_list_handle_space_tap.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/widgets/chat_list/chat_list_header_wrapper.dart';
import 'package:fluffychat/pangea/widgets/chat_list/chat_list_item_wrapper.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import '../../utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';

class SpaceView extends StatefulWidget {
  final ChatListController controller;
  final ScrollController scrollController;
  const SpaceView(
    this.controller, {
    super.key,
    required this.scrollController,
  });

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  static final Map<String, GetSpaceHierarchyResponse> _lastResponse = {};

  String? prevBatch;
  Object? error;
  bool loading = false;
  // #Pangea
  bool refreshing = false;
  StreamSubscription? _roomSubscription;

  final String _chatCountsKey = 'chatCounts';
  Map<String, int> get chatCounts => Map.from(
        widget.controller.pangeaController.pStoreService.read(_chatCountsKey) ??
            {},
      );

  /// Used to filter out sync updates with hierarchy updates for the active
  /// space so that the view can be auto-reloaded in the room subscription
  bool hasHierarchyUpdate(SyncUpdate update) {
    final joinTimeline =
        update.rooms?.join?[widget.controller.activeSpaceId]?.timeline;
    final leaveTimeline =
        update.rooms?.leave?[widget.controller.activeSpaceId]?.timeline;
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
  // Pangea#

  @override
  void initState() {
    // #Pangea
    // loadHierarchy();

    // If, on launch, this room has had updates to its children,
    // ensure the hierarchy is properly reloaded
    final bool hasUpdate = widget.controller.hasUpdates.contains(
      widget.controller.activeSpaceId,
    );

    loadHierarchy(hasUpdate: hasUpdate).then(
      // remove this space ID from the set of space IDs with updates
      (_) => widget.controller.hasUpdates.remove(
        widget.controller.activeSpaceId,
      ),
    );

    loadChatCounts();

    // Listen for changes to the activeSpace's hierarchy,
    // and reload the hierarchy when they come through
    final client = Matrix.of(context).client;
    _roomSubscription ??= client.onSync.stream
        .where(hasHierarchyUpdate)
        .listen((update) => loadHierarchy(hasUpdate: true));
    // Pangea#
    super.initState();
  }

  // #Pangea
  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }
  // Pangea#

  void _refresh() {
    // #Pangea
    // _lastResponse.remove(widget.controller.activseSpaceId);
    // loadHierarchy();
    if (mounted) setState(() => refreshing = true);
    loadHierarchy(hasUpdate: true).whenComplete(() {
      if (mounted) setState(() => refreshing = false);
    });
    // Pangea#
  }

  // #Pangea
  // Future<GetSpaceHierarchyResponse?> loadHierarchy([String? prevBatch]) async {
  //   final activeSpaceId = widget.controller.activeSpaceId;
  //   if (activeSpaceId == null) return null;
  //   final client = Matrix.of(context).client;

  //   final activeSpace = client.getRoomById(activeSpaceId);
  //   await activeSpace?.postLoad();

  //   setState(() {
  //     error = null;
  //     loading = true;
  //   });

  //   try {
  //     final response = await client.getSpaceHierarchy(
  //       activeSpaceId,
  //       maxDepth: 1,
  //       from: prevBatch,
  //     );

  //     if (prevBatch != null) {
  //       response.rooms.insertAll(0, _lastResponse[activeSpaceId]?.rooms ?? []);
  //     }
  //     setState(() {
  //       _lastResponse[activeSpaceId] = response;
  //     });
  //     return _lastResponse[activeSpaceId]!;
  //   } catch (e) {
  //     setState(() {
  //       error = e;
  //     });
  //     rethrow;
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  /// Loads the hierarchy of the active space (or the given spaceId) and stores
  /// it in _lastResponse map. If there's already a response in that map for the
  /// spaceId, it will try to load the next batch and add the new rooms to the
  /// already loaded ones. Displays a loading indicator while loading, and an error
  /// message if an error occurs.
  /// If hasUpdate is true, it will force the hierarchy to be reloaded.
  Future<void> loadHierarchy({
    String? spaceId,
    bool hasUpdate = false,
  }) async {
    if ((widget.controller.activeSpaceId == null && spaceId == null) ||
        loading) {
      return;
    }

    loading = true;
    error = null;
    setState(() {});

    try {
      await _loadHierarchy(spaceId: spaceId, hasUpdate: hasUpdate);
    } catch (e, s) {
      if (mounted) {
        setState(() => error = e);
      }
      ErrorHandler.logError(e: e, s: s);
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  /// Internal logic of loadHierarchy. It will load the hierarchy of
  /// the active space id (or specified spaceId).
  Future<void> _loadHierarchy({
    String? spaceId,
    bool hasUpdate = false,
  }) async {
    final client = Matrix.of(context).client;
    final activeSpaceId = (widget.controller.activeSpaceId ?? spaceId)!;
    final activeSpace = client.getRoomById(activeSpaceId);

    if (activeSpace == null) {
      ErrorHandler.logError(
        e: Exception('Space not found in loadHierarchy'),
        data: {'spaceId': activeSpaceId},
      );
      return;
    }

    // Load all of the space's state events. Space Child events
    // are used to filtering out unsuggested, unjoined rooms.
    await activeSpace.postLoad();

    // The current number of rooms loaded for this space that are visible in the UI
    final int prevLength = _lastResponse[activeSpaceId] != null && !hasUpdate
        ? filterHierarchyResponse(
            activeSpace,
            _lastResponse[activeSpaceId]!.rooms,
          ).length
        : 0;

    // Failsafe to prevent too many calls to the server in a row
    int callsToServer = 0;

    GetSpaceHierarchyResponse? currentHierarchy =
        hasUpdate ? null : _lastResponse[activeSpaceId];

    // Makes repeated calls to the server until 10 new visible rooms have
    // been loaded, or there are no rooms left to load. Using a loop here,
    // rather than one single call to the endpoint, because some spaces have
    // so many invisible rooms (analytics rooms) that it might look like
    // pressing the 'load more' button does nothing (Because the only rooms
    // coming through from those calls are analytics rooms).
    while (callsToServer < 5) {
      // if this space has been loaded and there are no more rooms to load, break
      if (currentHierarchy != null && currentHierarchy.nextBatch == null) {
        break;
      }

      // if this space has been loaded and 10 new rooms have been loaded, break
      if (currentHierarchy != null) {
        final int currentLength = filterHierarchyResponse(
          activeSpace,
          currentHierarchy.rooms,
        ).length;

        if (currentLength - prevLength >= 10) {
          break;
        }
      }

      // make the call to the server
      final response = await client.getSpaceHierarchy(
        activeSpaceId,
        maxDepth: 1,
        from: currentHierarchy?.nextBatch,
        limit: 100,
      );
      callsToServer++;

      // if rooms have earlier been loaded for this space, add those
      // previously loaded rooms to the front of the response list
      if (currentHierarchy != null) {
        response.rooms.insertAll(
          0,
          currentHierarchy.rooms,
        );
      }

      // finally, set the response to the last response for this space
      currentHierarchy = response;
    }

    if (currentHierarchy != null) {
      _lastResponse[activeSpaceId] = currentHierarchy;
    }

    // After making those calls to the server, set the chat count for
    // this space. Used for the UI of the 'All Spaces' view
    setChatCount(
      activeSpace,
      _lastResponse[activeSpaceId] ??
          GetSpaceHierarchyResponse(
            rooms: [],
          ),
    );
  }
  // Pangea#

  void _onJoinSpaceChild(SpaceRoomsChunk spaceChild) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.controller.activeSpaceId!);
    if (client.getRoomById(spaceChild.roomId) == null) {
      final result = await showFutureLoadingDialog(
        context: context,
        future: () async {
          await client.joinRoom(
            spaceChild.roomId,
            serverName: space?.spaceChildren
                .firstWhereOrNull(
                  (child) => child.roomId == spaceChild.roomId,
                )
                ?.via,
          );
          if (client.getRoomById(spaceChild.roomId) == null) {
            // Wait for room actually appears in sync
            await client.waitForRoomInSync(spaceChild.roomId, join: true);
          }
          // #Pangea
          final room = client.getRoomById(spaceChild.roomId);
          if (room != null && (await room.leaveIfFull())) {
            throw L10n.of(context)!.roomFull;
          }
          // Pangea#
        },
      );
      if (result.error != null) return;
      _refresh();
    }
    // #Pangea
    else {
      final room = client.getRoomById(spaceChild.roomId)!;
      if (room.membership != Membership.leave) return;
      final joinResult = await showFutureLoadingDialog(
        context: context,
        future: () async {
          final waitForRoom = room.client.waitForRoomInSync(
            room.id,
            join: true,
          );
          await room.join();
          await waitForRoom;
          if (await room.leaveIfFull()) {
            throw L10n.of(context)!.roomFull;
          }
        },
      );
      if (joinResult.error != null) return;
    }
    // Pangea#
    if (spaceChild.roomType == 'm.space') {
      if (spaceChild.roomId == widget.controller.activeSpaceId) {
        // #Pangea
        // context.go('/rooms/${spaceChild.roomId}');
        context.go('/rooms/${spaceChild.roomId}/details');
        // Pangea#
      } else {
        widget.controller.setActiveSpace(spaceChild.roomId);
      }
      return;
    }
    context.go('/rooms/${spaceChild.roomId}');
  }

  void _onSpaceChildContextMenu([
    SpaceRoomsChunk? spaceChild,
    Room? room,
  ]) async {
    final client = Matrix.of(context).client;
    final activeSpaceId = widget.controller.activeSpaceId;
    final activeSpace =
        activeSpaceId == null ? null : client.getRoomById(activeSpaceId);
    final action = await showModalActionSheet<SpaceChildContextAction>(
      context: context,
      title: spaceChild?.name ??
          room?.getLocalizedDisplayname(
            MatrixLocals(L10n.of(context)!),
          ),
      // #Pangea
      // message: spaceChild?.topic ?? room?.topic,
      // Pangea#
      actions: [
        // #Pangea
        // if (room == null)
        if (room == null || room.membership == Membership.leave)
          // Pangea#
          SheetAction(
            key: SpaceChildContextAction.join,
            label: L10n.of(context)!.joinRoom,
            icon: Icons.send_outlined,
          ),
        if (spaceChild != null &&
            // #Pangea
            room != null &&
            room.ownPowerLevel >= ClassDefaultValues.powerLevelOfAdmin &&
            // Pangea#
            (activeSpace?.canChangeStateEvent(EventTypes.SpaceChild) ?? false))
          SheetAction(
            key: SpaceChildContextAction.removeFromSpace,
            label: L10n.of(context)!.removeFromSpace,
            icon: Icons.delete_sweep_outlined,
          ),
        // #Pangea
        if (room != null &&
            room.ownPowerLevel >= ClassDefaultValues.powerLevelOfAdmin)
          SheetAction(
            key: SpaceChildContextAction.addToSpace,
            label: L10n.of(context)!.addToSpace,
            icon: Icons.workspaces_outlined,
          ),
        if (room != null &&
            room.isRoomAdmin &&
            room.membership != Membership.leave)
          SheetAction(
            key: SpaceChildContextAction.archive,
            label: room.isSpace
                ? L10n.of(context)!.archiveSpace
                : L10n.of(context)!.archive,
            icon: Icons.architecture_outlined,
            isDestructiveAction: true,
          ),
        // if (room != null)
        if (room != null && room.membership != Membership.leave)
          // Pangea#
          SheetAction(
            key: SpaceChildContextAction.leave,
            label: L10n.of(context)!.leave,
            // #Pangea
            // icon: Icons.delete_outlined,
            icon: Icons.arrow_forward,
            // Pangea#
            isDestructiveAction: true,
          ),
      ],
    );
    if (action == null) return;

    switch (action) {
      case SpaceChildContextAction.join:
        _onJoinSpaceChild(spaceChild!);
        break;
      case SpaceChildContextAction.leave:
        // #Pangea
        widget.controller.cancelAction();
        if (room == null) return;
        if (room.isSpace) {
          await room.isOnlyAdmin()
              ? await room.archiveSpace(
                  context,
                  Matrix.of(context).client,
                  onlyAdmin: true,
                )
              : await room.leaveSpace(
                  context,
                  Matrix.of(context).client,
                );
        } else {
          widget.controller.toggleSelection(room.id);
          await widget.controller.leaveAction();
        }
        _refresh();
        break;
      // await showFutureLoadingDialog(
      //   context: context,
      //   future: room!.leave,
      // );
      // break;
      // Pangea#
      case SpaceChildContextAction.removeFromSpace:
        await showFutureLoadingDialog(
          context: context,
          future: () => activeSpace!.removeSpaceChild(spaceChild!.roomId),
        );
        break;
      // #Pangea
      case SpaceChildContextAction.archive:
        widget.controller.cancelAction();
        // #Pangea
        if (room == null || room.membership == Membership.leave) return;
        if (room.isSpace) {
          await room.archiveSpace(
            context,
            Matrix.of(context).client,
            onlyAdmin: false,
          );
        } else {
          widget.controller.toggleSelection(room.id);
          await widget.controller.archiveAction();
        }
        // Pangea#
        _refresh();
        break;
      case SpaceChildContextAction.addToSpace:
        widget.controller.cancelAction();
        // #Pangea
        if (room == null || room.membership == Membership.leave) return;
        // Pangea#
        widget.controller.toggleSelection(room.id);
        await widget.controller.addToSpace();
        // #Pangea
        setState(() => widget.controller.selectedRoomIds.clear());
        // Pangea#
        break;
    }
  }

  void _addChatOrSubSpace() async {
    final roomType = await showConfirmationDialog(
      context: context,
      title: L10n.of(context)!.addChatOrSubSpace,
      actions: [
        AlertDialogAction(
          key: AddRoomType.subspace,
          label: L10n.of(context)!.createNewSpace,
        ),
        AlertDialogAction(
          key: AddRoomType.chat,
          label: L10n.of(context)!.createGroup,
        ),
      ],
    );
    if (roomType == null) return;

    final names = await showTextInputDialog(
      context: context,
      title: roomType == AddRoomType.subspace
          ? L10n.of(context)!.createNewSpace
          : L10n.of(context)!.createGroup,
      textFields: [
        DialogTextField(
          hintText: roomType == AddRoomType.subspace
              ? L10n.of(context)!.spaceName
              : L10n.of(context)!.groupName,
          minLines: 1,
          maxLines: 1,
          maxLength: 64,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return L10n.of(context)!.pleaseChoose;
            }
            return null;
          },
        ),
        DialogTextField(
          hintText: L10n.of(context)!.chatDescription,
          minLines: 4,
          maxLines: 8,
          maxLength: 255,
        ),
      ],
      okLabel: L10n.of(context)!.create,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (names == null) return;
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () async {
        late final String roomId;
        final activeSpace = client.getRoomById(
          widget.controller.activeSpaceId!,
        )!;

        if (roomType == AddRoomType.subspace) {
          roomId = await client.createSpace(
            name: names.first,
            topic: names.last.isEmpty ? null : names.last,
            visibility: activeSpace.joinRules == JoinRules.public
                ? sdk.Visibility.public
                : sdk.Visibility.private,
          );
        } else {
          roomId = await client.createGroupChat(
            groupName: names.first,
            initialState: names.length > 1 && names.last.isNotEmpty
                ? [
                    sdk.StateEvent(
                      type: sdk.EventTypes.RoomTopic,
                      content: {'topic': names.last},
                    ),
                  ]
                : null,
          );
        }
        await activeSpace.setSpaceChild(
          roomId,
          // #Pangea
          suggested: true,
          // Pangea#
        );
      },
    );
    if (result.error != null) return;
    _refresh();
  }

  // #Pangea
  Future<void> loadChatCounts() async {
    // if not in the call spaces view, don't load chat count yet
    if (widget.controller.activeSpaceId != null) return;

    final List<Room> allSpaces =
        Matrix.of(context).client.rooms.where((room) => room.isSpace).toList();

    for (final Room space in allSpaces) {
      // check if the space is visible in the all spaces list
      final bool isRootSpace = !allSpaces.any(
        (parentSpace) =>
            parentSpace.spaceChildren.any((child) => child.roomId == space.id),
      );

      // if it's visible, and it hasn't been loaded yet, load chat count
      if (isRootSpace && !chatCounts.containsKey(space.id)) {
        loadHierarchy(spaceId: space.id);
      }
    }
  }

  bool includeSpaceChild(
    Room space,
    SpaceRoomsChunk hierarchyMember,
  ) {
    if (!mounted) return false;
    final bool isAnalyticsRoom =
        hierarchyMember.roomType == PangeaRoomTypes.analytics;

    final bool isMember = [Membership.join, Membership.invite].contains(
      Matrix.of(context).client.getRoomById(hierarchyMember.roomId)?.membership,
    );

    final bool isSuggested =
        space.spaceChildSuggestionStatus[hierarchyMember.roomId] ?? true;

    return !isAnalyticsRoom && (isMember || isSuggested);
  }

  List<SpaceRoomsChunk> filterHierarchyResponse(
    Room space,
    List<SpaceRoomsChunk> hierarchyResponse,
  ) {
    final List<SpaceRoomsChunk> filteredChildren = [];
    for (final child in hierarchyResponse) {
      final isDuplicate = filteredChildren.any(
        (filtered) => filtered.roomId == child.roomId,
      );
      if (isDuplicate) continue;

      if (includeSpaceChild(space, child)) {
        filteredChildren.add(child);
      }
    }
    return filteredChildren;
  }

  int sortSpaceChildren(
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

  Future<void> setChatCount(
    Room space,
    GetSpaceHierarchyResponse? response,
  ) async {
    final Map<String, int> updatedChatCounts = Map.from(chatCounts);
    final List<SpaceRoomsChunk> spaceChildren = response?.rooms ?? [];
    final filteredChildren = filterHierarchyResponse(space, spaceChildren)
        .where((sc) => sc.roomId != space.id)
        .toList();
    updatedChatCounts[space.id] = filteredChildren.length;

    await widget.controller.pangeaController.pStoreService.save(
      _chatCountsKey,
      updatedChatCounts,
    );
  }

  bool roomCountLoading(Room space) =>
      space.membership == Membership.join && !chatCounts.containsKey(space.id);

  Widget spaceSubtitle(Room space) {
    if (roomCountLoading(space)) {
      return const CircularProgressIndicator.adaptive();
    }

    return Text(
      space.membership == Membership.join
          ? L10n.of(context)!.numChats(
              chatCounts[space.id].toString(),
            )
          : L10n.of(context)!.youreInvited,
    );
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final activeSpaceId = widget.controller.activeSpaceId;
    final activeSpace = activeSpaceId == null
        ? null
        : client.getRoomById(
            activeSpaceId,
          );
    final allSpaces = client.rooms.where((room) => room.isSpace);
    if (activeSpaceId == null) {
      final rootSpaces = allSpaces
          .where(
            (space) =>
                !allSpaces.any(
                  (parentSpace) => parentSpace.spaceChildren
                      .any((child) => child.roomId == space.id),
                ) &&
                space
                    .getLocalizedDisplayname(MatrixLocals(L10n.of(context)!))
                    .toLowerCase()
                    .contains(
                      widget.controller.searchController.text.toLowerCase(),
                    ),
          )
          .toList();

      return SafeArea(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            // #Pangea
            // ChatListHeader(controller: widget.controller),
            ChatListHeaderWrapper(controller: widget.controller),
            SliverList(
              delegate: SliverChildListDelegate(
                [const LearningProgressIndicators()],
              ),
            ),
            // Pangea#
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final rootSpace = rootSpaces[i];
                  final displayname = rootSpace.getLocalizedDisplayname(
                    MatrixLocals(L10n.of(context)!),
                  );
                  return Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      leading: Avatar(
                        mxContent: rootSpace.avatar,
                        name: displayname,
                        // #Pangea
                        littleIcon: rootSpace.roomTypeIcon,
                        // Pangea#
                      ),
                      title: Text(
                        displayname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // #Pangea
                      subtitle: Row(
                        children: [
                          spaceSubtitle(rootSpace),
                          if (rootSpace.isLocked)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.lock_outlined,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      onTap: () => chatListHandleSpaceTap(
                        context,
                        widget.controller,
                        rootSpaces[i],
                      ),
                      // subtitle: Text(
                      //   L10n.of(context)!.numChats(
                      //     rootSpace.spaceChildren.length.toString(),
                      //   ),
                      // ),
                      // onTap: () =>
                      //     widget.controller.setActiveSpace(rootSpace.id),
                      // Pangea#
                      onLongPress: () =>
                          _onSpaceChildContextMenu(null, rootSpace),
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                  );
                },
                childCount: rootSpaces.length,
              ),
            ),
          ],
        ),
      );
    }

    final parentSpace = allSpaces.firstWhereOrNull(
      (space) =>
          space.spaceChildren.any((child) => child.roomId == activeSpaceId),
    );
    return PopScope(
      canPop: parentSpace == null,
      onPopInvoked: (pop) async {
        if (pop) return;
        if (parentSpace != null) {
          widget.controller.setActiveSpace(parentSpace.id);
        }
      },
      child: SafeArea(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            // #Pangea
            // ChatListHeader(controller: widget.controller, globalSearch: false),
            ChatListHeaderWrapper(
              controller: widget.controller,
              globalSearch: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [const LearningProgressIndicators()],
              ),
            ),
            // Pangea#
            SliverAppBar(
              automaticallyImplyLeading: false,
              primary: false,
              titleSpacing: 0,
              title: ListTile(
                leading: BackButton(
                  // #Pangea
                  onPressed: () {
                    !FluffyThemes.isColumnMode(context) ||
                            parentSpace?.id != null
                        ? widget.controller.setActiveSpace(parentSpace?.id)
                        : widget.controller.onDestinationSelected(0);
                  },
                  // onPressed: () =>
                  //     widget.controller.setActiveSpace(parentSpace?.id),
                  // Pangea#
                ),
                title: Text(
                  parentSpace == null
                      // #Pangea
                      // ? L10n.of(context)!.allSpaces
                      ? !FluffyThemes.isColumnMode(context)
                          ? L10n.of(context)!.allSpaces
                          : L10n.of(context)!.allChats
                      // Pangea#
                      : parentSpace.getLocalizedDisplayname(
                          MatrixLocals(L10n.of(context)!),
                        ),
                ),
                // #Pangea
                // trailing: IconButton(
                //   icon: loading
                //       ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                //       : const Icon(Icons.refresh_outlined),
                //   onPressed: loading ? null : _refresh,
                // ),
                trailing: Tooltip(
                  message: L10n.of(context)!.refresh,
                  child: IconButton(
                    icon: loading
                        ? const CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          )
                        : const Icon(Icons.refresh_outlined),
                    onPressed: loading ? null : _refresh,
                  ),
                ),
                // Pangea#
              ),
            ),
            Builder(
              builder: (context) {
                final response = _lastResponse[activeSpaceId];
                final error = this.error;
                if (error != null) {
                  return SliverFillRemaining(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(error.toLocalizedString(context)),
                        ),
                        IconButton(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh_outlined),
                        ),
                      ],
                    ),
                  );
                }
                if (response == null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(L10n.of(context)!.loadingPleaseWait),
                    ),
                  );
                }
                // #Pangea
                // final spaceChildren = response.rooms;
                List<SpaceRoomsChunk> spaceChildren = response.rooms;
                final space =
                    Matrix.of(context).client.getRoomById(activeSpaceId);
                if (space != null) {
                  spaceChildren = filterHierarchyResponse(space, spaceChildren);
                }
                spaceChildren.sort(sortSpaceChildren);
                // Pangea#
                final canLoadMore = response.nextBatch != null;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      if (canLoadMore && i == spaceChildren.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: OutlinedButton.icon(
                            label: loading
                                ? const LinearProgressIndicator()
                                : Text(L10n.of(context)!.loadMore),
                            icon: const Icon(Icons.chevron_right_outlined),
                            onPressed: loading
                                ? null
                                : () {
                                    // #Pangea
                                    // loadHierarchy(response.nextBatch);
                                    loadHierarchy();
                                    // Pangea#
                                  },
                          ),
                        );
                      }
                      final spaceChild = spaceChildren[i];
                      final room = client.getRoomById(spaceChild.roomId);
                      if (room != null &&
                              !room.isSpace
                              // #Pangea
                              &&
                              room.membership != Membership.leave
                          // Pangea#
                          ) {
                        // #Pangea
                        // return ChatListItem(
                        return ChatListItemWrapper(
                          controller: widget.controller,
                          // Pangea#
                          room,
                          onLongPress: () =>
                              _onSpaceChildContextMenu(spaceChild, room),
                          activeChat: widget.controller.activeChat == room.id,
                          onTap: () => onChatTap(room, context),
                        );
                      }
                      final isSpace = spaceChild.roomType == 'm.space';
                      final topic = spaceChild.topic?.isEmpty ?? true
                          ? null
                          : spaceChild.topic;
                      if (spaceChild.roomId == activeSpaceId) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SearchTitle(
                              title: spaceChild.name ??
                                  spaceChild.canonicalAlias ??
                                  'Space',
                              icon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Avatar(
                                  size: 24,
                                  mxContent: spaceChild.avatarUrl,
                                  name: spaceChild.name,
                                ),
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withAlpha(128),
                              trailing: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                // #Pangea
                                // child: Icon(Icons.edit_outlined),
                                child: Icon(Icons.settings_outlined),
                                // Pangea#
                              ),
                              // #Pangea
                              // onTap: () => _onJoinSpaceChild(spaceChild),
                              onTap: () => context.go(
                                '/rooms/${spaceChild.roomId}/details',
                              ),
                              // Pangea#
                            ),
                            if (activeSpace?.canChangeStateEvent(
                                  EventTypes.SpaceChild,
                                ) ==
                                true)
                              Material(
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.group_add_outlined),
                                  ),
                                  title:
                                      Text(L10n.of(context)!.addChatOrSubSpace),
                                  trailing:
                                      const Icon(Icons.chevron_right_outlined),
                                  onTap: _addChatOrSubSpace,
                                ),
                              ),
                          ],
                        );
                      }
                      final name = spaceChild.name ??
                          spaceChild.canonicalAlias ??
                          L10n.of(context)!.chat;
                      if (widget.controller.isSearchMode &&
                          !name.toLowerCase().contains(
                                widget.controller.searchController.text
                                    .toLowerCase(),
                              )) {
                        return const SizedBox.shrink();
                      }
                      return Material(
                        child: ListTile(
                          leading: Avatar(
                            mxContent: spaceChild.avatarUrl,
                            name: spaceChild.name,
                            //#Pangea
                            littleIcon: room?.roomTypeIcon,
                            //Pangea#
                          ),
                          title: Row(
                            children: [
                              // #Pangea
                              // Expanded(
                              //   child:
                              // Pangea#
                              Text(
                                name,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // #Pangea
                              // ),
                              // Pangea#
                              if (!isSpace) ...[
                                const Icon(
                                  Icons.people_outline,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  spaceChild.numJoinedMembers.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                          // #Pangea
                          // onTap: () => room?.isSpace == true
                          //     ? widget.controller.setActiveSpace(room!.id)
                          //     : _onSpaceChildContextMenu(spaceChild, room),
                          onTap: room?.isSpace ?? false
                              ? () => chatListHandleSpaceTap(
                                    context,
                                    widget.controller,
                                    room!,
                                  )
                              : () => _onJoinSpaceChild(spaceChild),
                          // Pangea#
                          onLongPress: () =>
                              _onSpaceChildContextMenu(spaceChild, room),
                          subtitle: Text(
                            topic ??
                                (isSpace
                                    ? L10n.of(context)!.enterSpace
                                    : L10n.of(context)!.enterRoom),
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: isSpace
                              ? const Icon(Icons.chevron_right_outlined)
                              : null,
                        ),
                      );
                    },
                    childCount: spaceChildren.length + (canLoadMore ? 1 : 0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum SpaceChildContextAction {
  join,
  leave,
  removeFromSpace,
  // #Pangea
  // deleteChat,
  archive,
  addToSpace
  // Pangea#
}

enum AddRoomType { chat, subspace }
