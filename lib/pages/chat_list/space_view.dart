// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/archive_space.dart';
import 'package:fluffychat/pangea/utils/chat_list_handle_space_tap.dart';
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
  static final Map<String, Future<GetSpaceHierarchyResponse>> _requests = {};

  String? prevBatch;

  void _refresh() {
    // #Pangea
    if (mounted) {
      // Pangea#
      setState(() {
        _requests.remove(widget.controller.activeSpaceId);
      });
      // #Pangea
    }
    // Pangea#
  }

  Future<GetSpaceHierarchyResponse> getFuture(String activeSpaceId) =>
      _requests[activeSpaceId] ??= Matrix.of(context).client.getSpaceHierarchy(
            activeSpaceId,
            maxDepth: 1,
            from: prevBatch,
          );

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
        // #Pangea
        // context.go('/rooms/${spaceChild.roomId}');
        context.push('/spaces/${spaceChild.roomId}');
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
        if (room == null)
          SheetAction(
            key: SpaceChildContextAction.join,
            label: L10n.of(context)!.joinRoom,
            icon: Icons.send_outlined,
          ),
        if (spaceChild != null && (activeSpace?.canSendDefaultStates ?? false))
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
        if (room != null && room.isRoomAdmin)
          SheetAction(
            key: SpaceChildContextAction.archive,
            label: room.isSpace
                ? L10n.of(context)!.archiveSpace
                : L10n.of(context)!.archive,
            icon: Icons.architecture_outlined,
          ),
        // Pangea#
        if (room != null)
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
        await showFutureLoadingDialog(
          context: context,
          // #Pangea
          // future: room!.leave,
          future: () async {
            await room!.leave();
            if (Matrix.of(context).activeRoomId == room.id) {
              context.go('/rooms');
            }
          },
          // Pangea#
        );
        break;
      case SpaceChildContextAction.removeFromSpace:
        await showFutureLoadingDialog(
          context: context,
          future: () => activeSpace!.removeSpaceChild(spaceChild!.roomId),
        );
        break;
      // #Pangea
      case SpaceChildContextAction.archive:
        widget.controller.cancelAction();
        widget.controller.toggleSelection(room!.id);
        room.isSpace
            ? await showFutureLoadingDialog(
                context: context,
                future: () async {
                  await archiveSpace(
                    room,
                    Matrix.of(context).client,
                  );
                  widget.controller.selectedRoomIds.clear();
                },
              )
            : await widget.controller.archiveAction();
        _refresh();
        break;
      case SpaceChildContextAction.addToSpace:
        widget.controller.cancelAction();
        widget.controller.toggleSelection(room!.id);
        await widget.controller.addToSpace();
        break;
      // Pangea#
    }
  }

  // #Pangea
  StreamSubscription<SyncUpdate>? _roomSubscription;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
    _roomSubscription?.cancel();
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final activeSpaceId = widget.controller.activeSpaceId;
    final allSpaces = client.rooms.where((room) => room.isSpace);
    if (activeSpaceId == null) {
      final rootSpaces = allSpaces
          // #Pangea
          // .where(
          //   (space) => !allSpaces.any(
          //     (parentSpace) => parentSpace.spaceChildren
          //         .any((child) => child.roomId == space.id),
          //   ),
          // )
          // Pangea#
          .toList();

      return CustomScrollView(
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
                    subtitle: Text(
                      rootSpace.membership == Membership.join
                          ? L10n.of(context)!.numChats(
                              rootSpace.spaceChildren.length.toString(),
                            )
                          : L10n.of(context)!.youreInvited,
                    ),
                    onTap: () => chatListHandleSpaceTap(
                      context,
                      widget.controller,
                      rootSpaces[i],
                    ),
                    // subtitle: Text(
                    //   L10n.of(context)!
                    //       .numChats(rootSpace.spaceChildren.length.toString()),
                    // ),
                    // onTap: () => widget.controller.setActiveSpace(rootSpace.id),
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
      );
    }

    // #Pangea
    _roomSubscription = client.onSync.stream
        .where((event) => event.rooms?.join?.isNotEmpty ?? false)
        .listen((event) {
      if (mounted) {
        final List<String> joinedRoomIds = event.rooms!.join!.keys.toList();
        final joinedRoomFutures = joinedRoomIds.map(
          (joinedRoomId) => client.waitForRoomInSync(
            joinedRoomId,
            join: true,
          ),
        );
        Future.wait(joinedRoomFutures).then((_) {
          _refresh();
        });
      }
    });
    // Pangea#
    return FutureBuilder<GetSpaceHierarchyResponse>(
      future: getFuture(activeSpaceId),
      builder: (context, snapshot) {
        final response = snapshot.data;
        final error = snapshot.error;
        if (error != null) {
          return Column(
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
          );
        }
        if (response == null) {
          return CustomScrollView(
            slivers: [
              ChatListHeader(controller: widget.controller),
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ],
          );
        }
        final parentSpace = allSpaces.firstWhereOrNull(
          (space) =>
              space.spaceChildren.any((child) => child.roomId == activeSpaceId),
        );
        // #Pangea
        // final spaceChildren = response.rooms;
        List<SpaceRoomsChunk> spaceChildren = response.rooms;
        final space = Matrix.of(context).client.getRoomById(activeSpaceId);
        if (space != null) {
          final matchingSpaceChildren = space.spaceChildren
              .where(
                (spaceChild) => spaceChildren
                    .map((hierarchyMember) => hierarchyMember.roomId)
                    .contains(spaceChild.roomId),
              )
              .toList();
          spaceChildren = spaceChildren
              .where(
                (spaceChild) =>
                    matchingSpaceChildren.any(
                      (matchingSpaceChild) =>
                          matchingSpaceChild.roomId == spaceChild.roomId &&
                          matchingSpaceChild.suggested == true,
                    ) ||
                    [Membership.join, Membership.invite].contains(
                      Matrix.of(context)
                          .client
                          .getRoomById(spaceChild.roomId)
                          ?.membership,
                    ),
              )
              .toList();
        }
        spaceChildren.sort((a, b) {
          final bool aIsSpace = a.roomType == 'm.space';
          final bool bIsSpace = b.roomType == 'm.space';

          if (aIsSpace && !bIsSpace) {
            return -1;
          } else if (!aIsSpace && bIsSpace) {
            return 1;
          }
          return 0;
        });
        // Pangea#

        final canLoadMore = response.nextBatch != null;
        return PopScope(
          canPop: parentSpace == null,
          onPopInvoked: (pop) async {
            if (pop) return;
            if (parentSpace != null) {
              widget.controller.setActiveSpace(parentSpace.id);
            }
          },
          child: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              ChatListHeader(controller: widget.controller),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if (i == 0) {
                      return ListTile(
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
                          icon: snapshot.connectionState != ConnectionState.done
                              ? const CircularProgressIndicator.adaptive()
                              : const Icon(Icons.refresh_outlined),
                          onPressed:
                              snapshot.connectionState != ConnectionState.done
                                  ? null
                                  : _refresh,
                        ),
                      );
                    }
                    i--;
                    if (canLoadMore && i == spaceChildren.length) {
                      return ListTile(
                        title: Text(L10n.of(context)!.loadMore),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          prevBatch = response.nextBatch;
                          _refresh();
                        },
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
                      );
                    }
                    final isSpace = spaceChild.roomType == 'm.space';
                    final topic = spaceChild.topic?.isEmpty ?? true
                        ? null
                        : spaceChild.topic;
                    if (spaceChild.roomId == activeSpaceId) {
                      return SearchTitle(
                        title: spaceChild.name ??
                            spaceChild.canonicalAlias ??
                            'Space',
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        onTap: () => context.push(
                          '/spaces/${spaceChild.roomId}',
                        ),
                        // Pangea#
                      );
                    }
                    return ListTile(
                      leading: Avatar(
                        mxContent: spaceChild.avatarUrl,
                        name: spaceChild.name,
                        //#Pangea
                        littleIcon: room?.roomTypeIcon,
                        //Pangea#
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              spaceChild.name ??
                                  spaceChild.canonicalAlias ??
                                  L10n.of(context)!.chat,
                              maxLines: 1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                      //#Pangea
                      // onTap: () => _onJoinSpaceChild(spaceChild),
                      onTap: room?.isSpace ?? false
                          ? () => chatListHandleSpaceTap(
                                context,
                                widget.controller,
                                room!,
                              )
                          : () => _onJoinSpaceChild(spaceChild),
                      //Pangea#
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
                    );
                  },
                  childCount: spaceChildren.length + 1 + (canLoadMore ? 1 : 0),
                ),
              ),
            ],
          ),
        );
      },
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
