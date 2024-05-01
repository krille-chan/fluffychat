import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/utils/on_chat_tap.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
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

  @override
  void initState() {
    loadHierarchy();
    super.initState();
  }

  void _refresh() {
    _lastResponse.remove(widget.controller.activeSpaceId);
    loadHierarchy();
  }

  Future<GetSpaceHierarchyResponse> loadHierarchy([String? prevBatch]) async {
    final activeSpaceId = widget.controller.activeSpaceId!;
    final client = Matrix.of(context).client;

    final activeSpace = client.getRoomById(activeSpaceId);
    await activeSpace?.postLoad();

    setState(() {
      error = null;
      loading = true;
    });

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
        },
      );
      if (result.error != null) return;
      _refresh();
    }
    if (spaceChild.roomType == 'm.space') {
      if (spaceChild.roomId == widget.controller.activeSpaceId) {
        context.go('/rooms/${spaceChild.roomId}');
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
        if (room == null)
          SheetAction(
            key: SpaceChildContextAction.join,
            label: L10n.of(context)!.joinRoom,
            icon: Icons.send_outlined,
          ),
        if (spaceChild != null &&
            (activeSpace?.canChangeStateEvent(EventTypes.SpaceChild) ?? false))
          SheetAction(
            key: SpaceChildContextAction.removeFromSpace,
            label: L10n.of(context)!.removeFromSpace,
            icon: Icons.delete_sweep_outlined,
          ),
        if (room != null)
          SheetAction(
            key: SpaceChildContextAction.leave,
            label: L10n.of(context)!.leave,
            icon: Icons.delete_outlined,
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
        await showFutureLoadingDialog(
          context: context,
          future: room!.leave,
        );
        break;
      case SpaceChildContextAction.removeFromSpace:
        await showFutureLoadingDialog(
          context: context,
          future: () => activeSpace!.removeSpaceChild(spaceChild!.roomId),
        );
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
                    color: Theme.of(context).colorScheme.background,
                    child: ListTile(
                      leading: Avatar(
                        mxContent: rootSpace.avatar,
                        name: displayname,
                      ),
                      title: Text(
                        displayname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        L10n.of(context)!.numChats(
                          rootSpace.spaceChildren.length.toString(),
                        ),
                      ),
                      onTap: () =>
                          widget.controller.setActiveSpace(rootSpace.id),
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
            ChatListHeader(controller: widget.controller, globalSearch: false),
            SliverAppBar(
              automaticallyImplyLeading: false,
              primary: false,
              titleSpacing: 0,
              title: ListTile(
                leading: BackButton(
                  onPressed: () =>
                      widget.controller.setActiveSpace(parentSpace?.id),
                ),
                title: Text(
                  parentSpace == null
                      ? L10n.of(context)!.allSpaces
                      : parentSpace.getLocalizedDisplayname(
                          MatrixLocals(L10n.of(context)!),
                        ),
                ),
                trailing: IconButton(
                  icon: loading
                      ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                      : const Icon(Icons.refresh_outlined),
                  onPressed: loading ? null : _refresh,
                ),
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
                final spaceChildren = response.rooms;
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
                      if (room != null && !room.isSpace) {
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
                                child: Icon(Icons.edit_outlined),
                              ),
                              onTap: () => _onJoinSpaceChild(spaceChild),
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
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                          onTap: () => room?.isSpace == true
                              ? widget.controller.setActiveSpace(room!.id)
                              : _onSpaceChildContextMenu(spaceChild, room),
                          onLongPress: () =>
                              _onSpaceChildContextMenu(spaceChild, room),
                          subtitle: Text(
                            topic ??
                                (isSpace
                                    ? L10n.of(context)!.enterSpace
                                    : L10n.of(context)!.enterRoom),
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
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
}

enum AddRoomType { chat, subspace }
