import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';

enum AddRoomType {
  chat,
  subspace,
}

class SpaceView extends StatefulWidget {
  final String spaceId;
  final void Function() onBack;
  final void Function(String spaceId) toParentSpace;
  final void Function(Room room) onChatTab;
  final void Function(Room room, BuildContext context) onChatContext;
  final String? activeChat;
  // #Pangea
  final ChatListController controller;
  // Pangea#

  const SpaceView({
    required this.spaceId,
    required this.onBack,
    required this.onChatTab,
    required this.activeChat,
    required this.toParentSpace,
    required this.onChatContext,
    // #Pangea
    required this.controller,
    // Pangea#
    super.key,
  });

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  // #Pangea
  // final List<SpaceRoomsChunk> _discoveredChildren = [];
  List<SpaceRoomsChunk>? _discoveredChildren;
  StreamSubscription? _roomSubscription;
  // Pangea#
  final TextEditingController _filterController = TextEditingController();
  String? _nextBatch;
  bool _noMoreRooms = false;
  bool _isLoading = false;

  @override
  void initState() {
    // #Pangea
    // loadHierarchy();

    // If, on launch, this room has had updates to its children,
    // ensure the hierarchy is properly reloaded
    final bool hasUpdate = widget.controller.hasUpdates.contains(
      widget.spaceId,
    );

    loadHierarchy(hasUpdate: hasUpdate).then(
      // remove this space ID from the set of space IDs with updates
      (_) => widget.controller.hasUpdates.remove(
        widget.controller.activeSpaceId,
      ),
    );

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
  void didUpdateWidget(covariant SpaceView oldWidget) {
    // initState doesn't re-run when navigating between spaces
    // via the navigation rail, so this accounts for that
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spaceId != widget.spaceId) {
      _discoveredChildren = null;
      _nextBatch = null;
      _noMoreRooms = false;

      loadHierarchy(hasUpdate: true).then(
          // remove this space ID from the set of space IDs with updates
          (_) {
        if (widget.controller.hasUpdates.contains(widget.spaceId)) {
          widget.controller.hasUpdates.remove(
            widget.controller.activeSpaceId,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadHierarchy({hasUpdate = false}) async {
    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    if (room == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _loadHierarchy(activeSpace: room, hasUpdate: hasUpdate);
    } catch (e, s) {
      Logs().w('Unable to load hierarchy', e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Internal logic of loadHierarchy. It will load the hierarchy of
  /// the active space id (or specified spaceId).
  Future<void> _loadHierarchy({
    required Room activeSpace,
    bool hasUpdate = false,
  }) async {
    // Load all of the space's state events. Space Child events
    // are used to filtering out unsuggested, unjoined rooms.
    await activeSpace.postLoad();

    // The current number of rooms loaded for this space that are visible in the UI
    final int prevLength = !hasUpdate ? (_discoveredChildren?.length ?? 0) : 0;

    // Failsafe to prevent too many calls to the server in a row
    int callsToServer = 0;

    List<SpaceRoomsChunk>? currentHierarchy =
        _discoveredChildren == null || hasUpdate
            ? null
            : List.from(_discoveredChildren!);
    String? currentNextBatch = hasUpdate ? null : _nextBatch;

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
      final response = await Matrix.of(context).client.getSpaceHierarchy(
            widget.spaceId,
            maxDepth: 1,
            from: currentNextBatch,
            limit: 100,
          );
      callsToServer++;

      if (response.nextBatch == null) {
        _noMoreRooms = true;
      }

      // if rooms have earlier been loaded for this space, add those
      // previously loaded rooms to the front of the response list
      response.rooms.insertAll(
        0,
        currentHierarchy ?? [],
      );

      // finally, set the response to the last response for this space
      // and set the current next batch token
      currentHierarchy = filterHierarchyResponse(activeSpace, response.rooms);
      currentNextBatch = response.nextBatch;
    }

    _discoveredChildren = currentHierarchy;
    _discoveredChildren?.sort(sortSpaceChildren);
    _nextBatch = currentNextBatch;
  }

  // void _loadHierarchy() async {
  //   final room = Matrix.of(context).client.getRoomById(widget.spaceId);
  //   if (room == null) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final hierarchy = await room.client.getSpaceHierarchy(
  //       widget.spaceId,
  //       suggestedOnly: false,
  //       maxDepth: 2,
  //       from: _nextBatch,
  //     );
  //     if (!mounted) return;
  //     setState(() {
  //       _nextBatch = hierarchy.nextBatch;
  //       if (hierarchy.nextBatch == null) {
  //         _noMoreRooms = true;
  //       }
  //       _discoveredChildren.addAll(
  //         hierarchy.rooms
  //             .where((c) => room.client.getRoomById(c.roomId) == null),
  //       );
  //       _isLoading = false;
  //     });
  //   } catch (e, s) {
  //     Logs().w('Unable to load hierarchy', e, s);
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  // Pangea#

  void _joinChildRoom(SpaceRoomsChunk item) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.spaceId);

    final joined = await showAdaptiveBottomSheet<bool>(
      context: context,
      builder: (_) => PublicRoomBottomSheet(
        outerContext: context,
        chunk: item,
        via: space?.spaceChildren
            .firstWhereOrNull(
              (child) => child.roomId == item.roomId,
            )
            ?.via,
      ),
    );
    if (mounted && joined == true) {
      setState(() {
        _discoveredChildren?.remove(item);
      });
    }
  }

  void _onSpaceAction(SpaceActions action) async {
    final space = Matrix.of(context).client.getRoomById(widget.spaceId);

    switch (action) {
      case SpaceActions.settings:
        await space?.postLoad();
        context.push('/rooms/${widget.spaceId}/details');
        break;
      case SpaceActions.invite:
        await space?.postLoad();
        context.push('/rooms/${widget.spaceId}/invite');
        break;
      case SpaceActions.leave:
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          // #Pangea
          // message: L10n.of(context).archiveRoomDescription,
          message: L10n.of(context).leaveSpaceDescription,
          // Pangea#
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (!mounted) return;
        if (confirmed != OkCancelResult.ok) return;

        final success = await showFutureLoadingDialog(
          context: context,
          // #Pangea
          // future: () async => await space?.leave(),
          future: () async => await space?.leaveSpace(),
          // Pangea#
        );
        if (!mounted) return;
        if (success.error != null) return;
        widget.onBack();
    }
  }

  void _addChatOrSubspace() async {
    // #Pangea
    // final roomType = await showModalActionPopup(
    //   context: context,
    //   title: L10n.of(context).addChatOrSubSpace,
    //   actions: [
    //     AdaptiveModalAction(
    //       value: AddRoomType.subspace,
    //       label: L10n.of(context).createNewSpace,
    //     ),
    //     AdaptiveModalAction(
    //       value: AddRoomType.chat,
    //       label: L10n.of(context).createGroup,
    //     ),
    //   ],
    // );
    // if (roomType == null) return;
    const roomType = AddRoomType.chat;
    // Pangea#

    final names = await showTextInputDialog(
      context: context,
      // #Pangea
      // title: roomType == AddRoomType.subspace
      //     ? L10n.of(context).createNewSpace
      //     : L10n.of(context).createGroup,
      // hintText: roomType == AddRoomType.subspace
      //     ? L10n.of(context).spaceName
      //     : L10n.of(context).groupName,
      title: L10n.of(context).createChat,
      hintText: L10n.of(context).chatName,
      // Pangea#
      minLines: 1,
      maxLines: 1,
      maxLength: 64,
      validator: (text) {
        if (text.isEmpty) {
          return L10n.of(context).pleaseChoose;
        }
        return null;
      },
      okLabel: L10n.of(context).create,
      cancelLabel: L10n.of(context).cancel,
    );
    if (names == null) return;
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () async {
        late final String roomId;
        final activeSpace = client.getRoomById(widget.spaceId)!;
        await activeSpace.postLoad();

        if (roomType == AddRoomType.subspace) {
          // #Pangea
          // roomId = await client.createSpace(
          //   name: names,
          //   visibility: activeSpace.joinRules == JoinRules.public
          //       ? sdk.Visibility.public
          //       : sdk.Visibility.private,
          // );
          // Pangea#
        } else {
          roomId = await client.createGroupChat(
            groupName: names,
            // #Pangea
            // preset: activeSpace.joinRules == JoinRules.public
            //     ? CreateRoomPreset.publicChat
            //     : CreateRoomPreset.privateChat,
            // visibility: activeSpace.joinRules == JoinRules.public
            //     ? sdk.Visibility.public
            //     : sdk.Visibility.private,
            preset: sdk.CreateRoomPreset.publicChat,
            visibility: sdk.Visibility.private,
            enableEncryption: false,
            initialState: [
              StateEvent(
                type: EventTypes.RoomPowerLevels,
                stateKey: '',
                content: defaultPowerLevels,
              ),
            ],
            // Pangea#
          );
        }
        await activeSpace.setSpaceChild(roomId);
      },
    );
    if (result.error != null) return;
  }

  // #Pangea
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
      if (child.roomId == widget.spaceId ||
          Matrix.of(context).client.getRoomById(child.roomId) != null) {
        continue;
      }

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

  /// Used to filter out sync updates with hierarchy updates for the active
  /// space so that the view can be auto-reloaded in the room subscription
  bool hasHierarchyUpdate(SyncUpdate update) {
    final joinTimeline = update.rooms?.join?[widget.spaceId]?.timeline;
    final leaveTimeline = update.rooms?.leave?[widget.spaceId]?.timeline;
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

  List<Room>? get joinedRooms {
    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    if (room == null) return null;

    final spaceChildIds =
        room.spaceChildren.map((c) => c.roomId).whereType<String>().toSet();

    return room.client.rooms
        .where((room) => spaceChildIds.contains(room.id))
        .where((room) => !room.isAnalyticsRoom)
        .toList();
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    final displayname =
        room?.getLocalizedDisplayname() ?? L10n.of(context).nothingFound;
    return Scaffold(
      appBar: AppBar(
        leading: FluffyThemes.isColumnMode(context)
            ? null
            : Center(
                child: CloseButton(
                  onPressed: widget.onBack,
                ),
              ),
        automaticallyImplyLeading: false,
        titleSpacing: FluffyThemes.isColumnMode(context) ? null : 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Avatar(
            mxContent: room?.avatar,
            name: displayname,
            // #Pangea
            presenceUserId: room?.directChatMatrixID,
            // Pangea#
            border: BorderSide(width: 1, color: theme.dividerColor),
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
          title: Text(
            displayname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: room == null
              ? null
              : Text(
                  L10n.of(context).countChatsAndCountParticipants(
                    // #Pangea
                    // room.spaceChildren.length,
                    room.spaceChildCount,
                    // Pangea#
                    room.summary.mJoinedMemberCount ?? 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        actions: [
          PopupMenuButton<SpaceActions>(
            onSelected: _onSpaceAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SpaceActions.settings,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).settings),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.invite,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).invite),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.leave,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).leave),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: room?.canChangeStateEvent(
                EventTypes.SpaceChild,
              ) ==
              true
          ? FloatingActionButton.extended(
              onPressed: _addChatOrSubspace,
              // #Pangea
              // label: Text(L10n.of(context).group),
              label: Text(L10n.of(context).chat),
              // Pangea#
              icon: const Icon(Icons.group_add_outlined),
            )
          : null,
      body: room == null
          ? const Center(
              child: Icon(
                Icons.search_outlined,
                size: 80,
              ),
            )
          : StreamBuilder(
              stream: room.client.onSync.stream
                  .where((s) => s.hasRoomUpdate)
                  .rateLimit(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                final childrenIds = room.spaceChildren
                    .map((c) => c.roomId)
                    .whereType<String>()
                    .toSet();

                final joinedRooms = room.client.rooms
                    .where((room) => childrenIds.remove(room.id))
                    // #Pangea
                    .where((room) => !room.isAnalyticsRoom)
                    // Pangea#
                    .toList();

                final joinedParents = room.spaceParents
                    .map((parent) {
                      final roomId = parent.roomId;
                      if (roomId == null) return null;
                      return room.client.getRoomById(roomId);
                    })
                    .whereType<Room>()
                    .toList();
                final filter = _filterController.text.trim().toLowerCase();
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      toolbarHeight: 72,
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      title: TextField(
                        controller: _filterController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.colorScheme.secondaryContainer,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: L10n.of(context).search,
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.normal,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search_outlined,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: joinedParents.length,
                      itemBuilder: (context, i) {
                        final displayname =
                            joinedParents[i].getLocalizedDisplayname();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 1,
                          ),
                          child: Material(
                            borderRadius:
                                BorderRadius.circular(AppConfig.borderRadius),
                            clipBehavior: Clip.hardEdge,
                            child: ListTile(
                              minVerticalPadding: 0,
                              leading: Icon(
                                Icons.adaptive.arrow_back_outlined,
                                size: 16,
                              ),
                              title: Row(
                                children: [
                                  Avatar(
                                    mxContent: joinedParents[i].avatar,
                                    name: displayname,
                                    // #Pangea
                                    presenceUserId:
                                        joinedParents[i].directChatMatrixID,
                                    // Pangea#
                                    size: Avatar.defaultSize / 2,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 4,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(displayname)),
                                ],
                              ),
                              onTap: () =>
                                  widget.toParentSpace(joinedParents[i].id),
                            ),
                          ),
                        );
                      },
                    ),
                    SliverList.builder(
                      itemCount: joinedRooms.length,
                      itemBuilder: (context, i) {
                        final joinedRoom = joinedRooms[i];
                        return ChatListItem(
                          joinedRoom,
                          filter: filter,
                          onTap: () => widget.onChatTab(joinedRoom),
                          onLongPress: (context) => widget.onChatContext(
                            joinedRoom,
                            context,
                          ),
                          activeChat: widget.activeChat == joinedRoom.id,
                        );
                      },
                    ),
                    SliverList.builder(
                      itemCount: (_discoveredChildren?.length ?? 0) + 2,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return SearchTitle(
                            title: L10n.of(context).discover,
                            icon: const Icon(Icons.explore_outlined),
                          );
                        }
                        i--;
                        if (i == (_discoveredChildren?.length ?? 0)) {
                          if (_noMoreRooms) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  L10n.of(context).noMoreChatsFound,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 2.0,
                            ),
                            child: TextButton(
                              onPressed: _isLoading ? null : loadHierarchy,
                              child: _isLoading
                                  ? LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(
                                        AppConfig.borderRadius,
                                      ),
                                    )
                                  : Text(L10n.of(context).loadMore),
                            ),
                          );
                        }
                        final item = _discoveredChildren![i];
                        final displayname = item.name ??
                            item.canonicalAlias ??
                            L10n.of(context).emptyChat;
                        if (!displayname.toLowerCase().contains(filter)) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 1,
                          ),
                          child: Material(
                            borderRadius:
                                BorderRadius.circular(AppConfig.borderRadius),
                            clipBehavior: Clip.hardEdge,
                            child: ListTile(
                              visualDensity:
                                  const VisualDensity(vertical: -0.5),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onTap: () => _joinChildRoom(item),
                              leading: Avatar(
                                mxContent: item.avatarUrl,
                                name: displayname,
                                // #Pangea
                                presenceUserId: Matrix.of(context)
                                    .client
                                    .getRoomById(item.roomId)
                                    ?.directChatMatrixID,
                                // Pangea#
                                borderRadius: item.roomType == 'm.space'
                                    ? BorderRadius.circular(
                                        AppConfig.borderRadius / 2,
                                      )
                                    : null,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayname,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item.numJoinedMembers.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.people_outlined,
                                    size: 14,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                item.topic ??
                                    L10n.of(context).countParticipants(
                                      item.numJoinedMembers,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 32)),
                  ],
                );
              },
            ),
    );
  }
}

enum SpaceActions {
  settings,
  invite,
  leave,
}
