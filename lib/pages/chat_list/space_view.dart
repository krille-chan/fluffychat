import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/utils/on_chat_tap.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/extensions/sync_update_extension.dart';
import 'package:fluffychat/pangea/utils/chat_list_handle_space_tap.dart';
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
import 'chat_list_header.dart';

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
  StreamSubscription<SyncUpdate>? _roomSubscription;
  bool refreshing = false;

  final String _chatCountsKey = 'chatCounts';
  Map<String, int> get chatCounts => Map.from(
        widget.controller.pangeaController.pStoreService.read(
              _chatCountsKey,
              local: true,
            ) ??
            {},
      );
  // Pangea#

  @override
  void initState() {
    loadHierarchy();
    // #Pangea
    loadChatCounts();
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
    if (mounted) {
      // Pangea#
      loadHierarchy();
      // #Pangea
    }
    // Pangea#
  }

  Future<GetSpaceHierarchyResponse> loadHierarchy([
    String? prevBatch,
    // #Pangea
    String? spaceId,
    // Pangea#
  ]) async {
    // #Pangea
    if ((widget.controller.activeSpaceId == null && spaceId == null) ||
        loading) {
      return GetSpaceHierarchyResponse(
        rooms: [],
        nextBatch: null,
      );
    }

    setState(() {
      error = null;
      loading = true;
    });
    // Pangea#

    // #Pangea
    // final activeSpaceId = widget.controller.activeSpaceId!;
    final activeSpaceId = (widget.controller.activeSpaceId ?? spaceId)!;
    // Pangea#
    final client = Matrix.of(context).client;

    final activeSpace = client.getRoomById(activeSpaceId);
    await activeSpace?.postLoad();

    // #Pangea
    // setState(() {
    //   error = null;
    //   loading = true;
    // });
    // Pangea#

    try {
      final response = await client.getSpaceHierarchy(
        activeSpaceId,
        maxDepth: 1,
        from: prevBatch,
      );

      if (prevBatch != null) {
        response.rooms.insertAll(0, _lastResponse[activeSpaceId]?.rooms ?? []);
      }
      setState(() {
        _lastResponse[activeSpaceId] = response;
      });
      return _lastResponse[activeSpaceId]!;
    } catch (e) {
      setState(() {
        error = e;
      });
      rethrow;
    } finally {
      // #Pangea
      if (activeSpace != null) {
        await setChatCount(
          activeSpace,
          _lastResponse[activeSpaceId] ??
              GetSpaceHierarchyResponse(
                rooms: [],
              ),
        );
      }
      // Pangea#
      setState(() {
        loading = false;
      });
    }
  }

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
      message: spaceChild?.topic ?? room?.topic,
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
        await activeSpace.setSpaceChild(roomId);
      },
    );
    if (result.error != null) return;
    _refresh();
  }

  // #Pangea
  Future<void> loadChatCounts() async {
    for (final Room room in Matrix.of(context).client.rooms) {
      if (room.isSpace && !chatCounts.containsKey(room.id)) {
        await loadHierarchy(null, room.id);
      }
    }
  }

  Future<void> refreshOnUpdate(SyncUpdate event) async {
    /* refresh on leave, invite, and space child update
      not join events, because there's already a listener on 
      onTapSpaceChild, and they interfere with each other */
    if (widget.controller.activeSpaceId == null || !mounted || refreshing) {
      return;
    }
    setState(() => refreshing = true);
    final client = Matrix.of(context).client;
    if (mounted &&
            event.isMembershipUpdateByType(
              Membership.leave,
              client.userID!,
            ) ||
        event.isMembershipUpdateByType(
          Membership.invite,
          client.userID!,
        ) ||
        event.isSpaceChildUpdate(
          widget.controller.activeSpaceId!,
        )) {
      await loadHierarchy();
    }
    setState(() => refreshing = false);
  }

  bool includeSpaceChild(sc, matchingSpaceChildren) {
    final bool isAnalyticsRoom = sc.roomType == PangeaRoomTypes.analytics;
    final bool isMember = [Membership.join, Membership.invite]
        .contains(Matrix.of(context).client.getRoomById(sc.roomId)?.membership);
    final bool isSuggested = matchingSpaceChildren.any(
      (matchingSpaceChild) =>
          matchingSpaceChild.roomId == sc.roomId &&
          matchingSpaceChild.suggested == true,
    );
    return !isAnalyticsRoom && (isMember || isSuggested);
  }

  List<SpaceRoomsChunk> filterSpaceChildren(
    Room space,
    List<SpaceRoomsChunk> spaceChildren,
  ) {
    final childIds =
        spaceChildren.map((hierarchyMember) => hierarchyMember.roomId);

    final matchingSpaceChildren = space.spaceChildren
        .where((spaceChild) => childIds.contains(spaceChild.roomId))
        .toList();

    final filteredSpaceChildren = spaceChildren
        .where(
          (sc) => includeSpaceChild(
            sc,
            matchingSpaceChildren,
          ),
        )
        .toList();
    return filteredSpaceChildren;
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
    final filteredChildren = filterSpaceChildren(space, spaceChildren)
        .where((sc) => sc.roomId != space.id)
        .toList();
    updatedChatCounts[space.id] = filteredChildren.length;

    await widget.controller.pangeaController.pStoreService.save(
      _chatCountsKey,
      updatedChatCounts,
      local: true,
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
            ChatListHeader(controller: widget.controller),
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

    // #Pangea
    _roomSubscription ??= client.onSync.stream
        .where((event) => event.hasRoomUpdate)
        .listen(refreshOnUpdate);
    // Pangea#

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
            ChatListHeader(controller: widget.controller, globalSearch: false),
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
                  spaceChildren = filterSpaceChildren(space, spaceChildren);
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
                                    loadHierarchy(response.nextBatch);
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
                        return ChatListItem(
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
                                  fontSize: 9,
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
                            // #Pangea
                            // if (activeSpace?.canChangeStateEvent(
                            //       EventTypes.SpaceChild,
                            //     ) ==
                            //     true)
                            //   Material(
                            //     child: ListTile(
                            //       leading: const CircleAvatar(
                            //         child: Icon(Icons.group_add_outlined),
                            //       ),
                            //       title:
                            //           Text(L10n.of(context)!.addChatOrSubSpace),
                            //       trailing:
                            //           const Icon(Icons.chevron_right_outlined),
                            //       onTap: _addChatOrSubSpace,
                            //     ),
                            //   ),
                            // Pangea#
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
