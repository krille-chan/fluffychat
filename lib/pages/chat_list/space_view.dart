import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

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

    final consent = await showOkCancelAlertDialog(
      context: context,
      title: item.name ?? item.canonicalAlias ?? L10n.of(context)!.emptyChat,
      message: item.topic,
      okLabel: L10n.of(context)!.joinRoom,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await client.joinRoom(
          item.roomId,
          serverName: space?.spaceChildren
              .firstWhereOrNull(
                (child) => child.roomId == item.roomId,
              )
              ?.via,
        );
        if (client.getRoomById(item.roomId) == null) {
          // Wait for room actually appears in sync
          await client.waitForRoomInSync(item.roomId, join: true);
        }
      },
    );
    if (!mounted) return;

    setState(() {
      _discoveredChildren.remove(item);
    });
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
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.ok,
          cancelLabel: L10n.of(context)!.cancel,
          message: L10n.of(context)!.archiveRoomDescription,
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

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    final displayname =
        room?.getLocalizedDisplayname() ?? L10n.of(context)!.nothingFound;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => widget.onBack(),
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: CloseButton(
              onPressed: widget.onBack,
            ),
          ),
          titleSpacing: 0,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Avatar(
              mxContent: room?.avatar,
              name: displayname,
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
                    L10n.of(context)!.countChatsAndCountParticipants(
                      room.spaceChildren.length,
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
                      Text(L10n.of(context)!.settings),
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
                      Text(L10n.of(context)!.invite),
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
                      Text(L10n.of(context)!.leave),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
                            fillColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            contentPadding: EdgeInsets.zero,
                            hintText: L10n.of(context)!.search,
                            hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontWeight: FontWeight.normal,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
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
                      SliverList.builder(
                        itemCount: joinedRooms.length + 1,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return SearchTitle(
                              title: L10n.of(context)!.joinedChats,
                              icon: const Icon(Icons.chat_outlined),
                            );
                          }
                          i--;
                          final room = joinedRooms[i];
                          return ChatListItem(
                            room,
                            filter: filter,
                            onTap: () => widget.onChatTab(room),
                            onLongPress: (context) => widget.onChatContext(
                              room,
                              context,
                            ),
                            activeChat: widget.activeChat == room.id,
                          );
                        },
                      ),
                      SliverList.builder(
                        itemCount: _discoveredChildren.length + 2,
                        itemBuilder: (context, i) {
                          if (i == 0) {
                            return SearchTitle(
                              title: L10n.of(context)!.discover,
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
                                    L10n.of(context)!.noMoreChatsFound,
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
                                    : Text(L10n.of(context)!.loadMore),
                              ),
                            );
                          }
                          final item = _discoveredChildren[i];
                          final displayname = item.name ??
                              item.canonicalAlias ??
                              L10n.of(context)!.emptyChat;
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
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.add_circle_outline_outlined,
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  item.topic ??
                                      L10n.of(context)!.countParticipants(
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
                    ],
                  );
                },
              ),
      ),
    );
  }
}

enum SpaceActions {
  settings,
  invite,
  leave,
}
