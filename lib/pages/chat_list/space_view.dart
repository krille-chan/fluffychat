import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';
import 'package:pair/pair.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/chat_list_space_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/public_room_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum AddRoomType { chat, subspace }

class SpaceView extends StatefulWidget {
  final String spaceId;
  final void Function() onBack;
  final void Function(String spaceId) toParentSpace;
  final void Function(Room room) onChatTab;
  final void Function(Room room, BuildContext context) onChatContext;
  final String? activeChat;

  const SpaceView({
    required this.spaceId,
    required this.onBack,
    required this.onChatTab,
    required this.activeChat,
    required this.toParentSpace,
    required this.onChatContext,
    super.key,
  });

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  final List<SpaceRoomsChunk> _discoveredChildren = [];
  final TextEditingController _filterController = TextEditingController();
  String? _nextBatch;
  bool _noMoreRooms = false;
  bool _isLoading = false;

  @override
  void initState() {
    _loadHierarchy();
    super.initState();
  }

  void _loadHierarchy() async {
    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    if (room == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final hierarchy = await room.client.getSpaceHierarchy(
        widget.spaceId,
        suggestedOnly: false,
        maxDepth: 2,
        from: _nextBatch,
      );
      if (!mounted) return;
      setState(() {
        _nextBatch = hierarchy.nextBatch;
        if (hierarchy.nextBatch == null) {
          _noMoreRooms = true;
        }
        _discoveredChildren.addAll(
          hierarchy.rooms
              .where((c) => room.client.getRoomById(c.roomId) == null),
        );
        _isLoading = false;
      });
    } catch (e, s) {
      Logs().w('Unable to load hierarchy', e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _joinChildRoom(SpaceRoomsChunk item) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.spaceId);

    final joined = await showAdaptiveDialog<bool>(
      context: context,
      builder: (_) => PublicRoomDialog(
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
        _discoveredChildren.remove(item);
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
          message: L10n.of(context).archiveRoomDescription,
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (!mounted) return;
        if (confirmed != OkCancelResult.ok) return;

        final success = await showFutureLoadingDialog(
          context: context,
          future: () async => await space?.leave(),
        );
        if (!mounted) return;
        if (success.error != null) return;
        widget.onBack();
    }
  }

  void _onSpaceViewOptions(String roomId, SpaceViewOptions option) async {
    AppConfig.spaceViewOptions
        .update(roomId, (value) => option.index, ifAbsent: () => option.index);
    await Matrix.of(context).store.setStringList(
          SettingKeys.spaceViewOptions,
          AppConfig.spaceViewOptions.entries
              .map((entry) => [entry.key, entry.value.toString()])
              .expand((pair) => pair)
              .toList(),
        );
    setState(() {});
  }

  void _addChatOrSubspace() async {
    final roomType = await showModalActionPopup(
      context: context,
      title: L10n.of(context).addChatOrSubSpace,
      actions: [
        AdaptiveModalAction(
          value: AddRoomType.subspace,
          label: L10n.of(context).createNewSpace,
        ),
        AdaptiveModalAction(
          value: AddRoomType.chat,
          label: L10n.of(context).createGroup,
        ),
      ],
    );
    if (roomType == null) return;

    final names = await showTextInputDialog(
      context: context,
      title: roomType == AddRoomType.subspace
          ? L10n.of(context).createNewSpace
          : L10n.of(context).createGroup,
      hintText: roomType == AddRoomType.subspace
          ? L10n.of(context).spaceName
          : L10n.of(context).groupName,
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
          roomId = await client.createSpace(
            name: names,
            visibility: activeSpace.joinRules == JoinRules.public
                ? sdk.Visibility.public
                : sdk.Visibility.private,
          );
        } else {
          roomId = await client.createGroupChat(
            groupName: names,
            preset: activeSpace.joinRules == JoinRules.public
                ? CreateRoomPreset.publicChat
                : CreateRoomPreset.privateChat,
            visibility: activeSpace.joinRules == JoinRules.public
                ? sdk.Visibility.public
                : sdk.Visibility.private,
          );
        }
        await activeSpace.setSpaceChild(roomId);
      },
    );
    if (result.error != null) return;
  }

  void _setCollapsed(String roomId, bool expanded) async {
    if (expanded
        ? AppConfig.collapsedSpace.remove(roomId)
        : AppConfig.collapsedSpace.add(roomId)) {
      await Matrix.of(context).store.setStringList(
            SettingKeys.collapsedSpace,
            AppConfig.collapsedSpace.toList(),
          );
    }
  }

  SliverList _buildChildrenList(Room room, String filter) {
    final childrenRooms = room.spaceChildren
        .map((c) => Pair(
            c, room.client.rooms.firstWhereOrNull((r) => r.id == c.roomId)))
        .where((p) => p.value != null)
        .toList();

    List<Room> mixedRooms;
    if (AppConfig.spaceViewOptions.tryGet(room.id) ==
            SpaceViewOptions.roomTop.index ||
        AppConfig.spaceViewOptions.tryGet(room.id) ==
            SpaceViewOptions.categorized.index) {
      final actualRooms =
          childrenRooms.where((pair) => !pair.value!.isSpace).toList();
      final subspaces =
          childrenRooms.where((pair) => pair.value!.isSpace).toList();

      final sortedRooms = actualRooms
          .where((pair) => pair.key.order.isNotEmpty)
          .sorted((a, b) => a.key.order.compareTo(b.key.order))
          .map((pair) => pair.value)
          .toList();
      final unsortedRooms = actualRooms
          .where((pair) => pair.key.order.isEmpty)
          .map((pair) => pair.value)
          .toList();

      final sortedSpaces = subspaces
          .where((pair) => pair.key.order.isNotEmpty)
          .sorted((a, b) => a.key.order.compareTo(b.key.order))
          .map((pair) => pair.value)
          .toList();
      final unsortedSpaces = subspaces
          .where((pair) => pair.key.order.isEmpty)
          .map((pair) => pair.value)
          .toList();

      mixedRooms = (sortedRooms + unsortedRooms + sortedSpaces + unsortedSpaces)
          .nonNulls
          .toList();

      if (AppConfig.spaceViewOptions.tryGet(room.id) ==
          SpaceViewOptions.categorized.index) {
        final spaceRoomMap = <String, List<Room>>{};
        for (final pair in subspaces) {
          final childrenRooms = pair.value!.spaceChildren
              .map((c) => Pair(c,
                  room.client.rooms.firstWhereOrNull((r) => r.id == c.roomId)))
              .where((p) => p.value != null)
              .toList();

          final actualRooms =
              childrenRooms.where((pair) => !pair.value!.isSpace).toList();
          final subspaces =
              childrenRooms.where((pair) => pair.value!.isSpace).toList();

          final sortedRooms = actualRooms
              .where((pair) => pair.key.order.isNotEmpty)
              .sorted((a, b) => a.key.order.compareTo(b.key.order))
              .map((pair) => pair.value!)
              .toList();
          final unsortedRooms = actualRooms
              .where((pair) => pair.key.order.isEmpty)
              .map((pair) => pair.value!)
              .toList();

          final sortedSpaces = subspaces
              .where((pair) => pair.key.order.isNotEmpty)
              .sorted((a, b) => a.key.order.compareTo(b.key.order))
              .map((pair) => pair.value!)
              .toList();
          final unsortedSpaces = subspaces
              .where((pair) => pair.key.order.isEmpty)
              .map((pair) => pair.value!)
              .toList();

          spaceRoomMap.putIfAbsent(
              pair.value!.id,
              () =>
                  sortedRooms + unsortedRooms + sortedSpaces + unsortedSpaces);
        }

        return SliverList.builder(
          itemCount: mixedRooms.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (room.canChangeStateEvent(
                        EventTypes.SpaceChild,
                      ) &&
                      filter.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 1,
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(
                          AppConfig.borderRadius,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          onTap: _addChatOrSubspace,
                          leading: const CircleAvatar(
                            radius: Avatar.defaultSize / 2,
                            child: Icon(Icons.add_outlined),
                          ),
                          title: Text(
                            L10n.of(context)!.addChatOrSubSpace,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SearchTitle(
                    title: L10n.of(context)!.joinedChats,
                    icon: const Icon(Icons.chat_outlined),
                  ),
                ],
              );
            }
            i--;
            final mixedRoom = mixedRooms[i];
            if (mixedRoom.isSpace) {
              /*return SearchTitle(
                title: mixedRoom.name,
                icon: const Icon(Icons.chat_outlined),
              );*/
              return ChatListSpaceItem(
                mixedRoom,
                spaceRoomMap[mixedRoom.id] ?? List.empty(),
                filter: filter,
                onTapDeep: (room) => widget.onChatTab(room),
                onLongPress: (context) => widget.onChatContext(
                  mixedRoom,
                  context,
                ),
                onLongPressDeep: (room, context) => widget.onChatContext(
                  room,
                  context,
                ),
                onExpansionChanged: (expanded) =>
                    _setCollapsed(mixedRoom.id, expanded),
                defaultExpanded:
                    !AppConfig.collapsedSpace.contains(mixedRoom.id),
                activeChat: widget.activeChat,
              );
            }
            return ChatListItem(
              mixedRoom,
              filter: filter,
              onTap: () => widget.onChatTab(mixedRoom),
              onLongPress: (context) => widget.onChatContext(
                mixedRoom,
                context,
              ),
              activeChat: widget.activeChat == mixedRoom.id,
            );
          },
        );
      }
    } else {
      final sortedRooms = childrenRooms
          .where((pair) => pair.key.order.isNotEmpty)
          .sorted((a, b) => a.key.order.compareTo(b.key.order))
          .map((pair) => pair.value)
          .toList();
      final unsortedRooms = childrenRooms
          .where((pair) => pair.key.order.isEmpty)
          .map((pair) => pair.value)
          .toList();
      mixedRooms = (sortedRooms + unsortedRooms).nonNulls.toList();
    }

    return SliverList.builder(
      itemCount: mixedRooms.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (room.canChangeStateEvent(
                    EventTypes.SpaceChild,
                  ) &&
                  filter.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(
                      AppConfig.borderRadius,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      onTap: _addChatOrSubspace,
                      leading: const CircleAvatar(
                        radius: Avatar.defaultSize / 2,
                        child: Icon(Icons.add_outlined),
                      ),
                      title: Text(
                        L10n.of(context)!.addChatOrSubSpace,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
              SearchTitle(
                title: L10n.of(context)!.joinedChats,
                icon: const Icon(Icons.chat_outlined),
              ),
            ],
          );
        }
        i--;
        final mixedRoom = mixedRooms[i];
        return ChatListItem(
          mixedRoom,
          filter: filter,
          onTap: () => widget.onChatTab(mixedRoom),
          onLongPress: (context) => widget.onChatContext(
            mixedRoom,
            context,
          ),
          activeChat: widget.activeChat == mixedRoom.id,
        );
      },
    );
  }

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
                    room.spaceChildren.length,
                    room.summary.mJoinedMemberCount ?? 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        actions: [
          PopupMenuButton<SpaceViewOptions>(
            onSelected: (option) => _onSpaceViewOptions(room!.id, option),
            icon: Icon((SpaceViewOptions.values.firstWhereOrNull((value) =>
                        value.index == AppConfig.spaceViewOptions[room!.id]) ??
                    SpaceViewOptions.normal)
                .icon),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SpaceViewOptions.normal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SpaceViewOptions.normal.icon),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.spaceViewNormal),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceViewOptions.roomTop,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SpaceViewOptions.roomTop.icon),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.spaceViewRoomTop),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceViewOptions.categorized,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SpaceViewOptions.categorized.icon),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.spaceViewCategorized),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<SpaceActions>(
            useRootNavigator: true,
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
              label: Text(L10n.of(context).group),
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
                    _buildChildrenList(room, filter),
                    /*SliverList.builder(
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
                    ),*/
                    SliverList.builder(
                      itemCount: _discoveredChildren.length + 2,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return SearchTitle(
                            title: L10n.of(context).discover,
                            icon: const Icon(Icons.explore_outlined),
                          );
                        }
                        i--;
                        if (i == _discoveredChildren.length) {
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
                              onPressed: _isLoading ? null : _loadHierarchy,
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
                        final item = _discoveredChildren[i];
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

enum SpaceViewOptions {
  normal(icon: Icons.sort_outlined),
  roomTop(icon: Icons.vertical_align_top_outlined),
  categorized(icon: Icons.category_outlined);

  const SpaceViewOptions({
    required this.icon,
  });

  final IconData icon;
}
