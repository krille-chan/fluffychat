import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/dummy_chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/space_view.dart';
import 'package:fluffychat/pages/chat_list/status_msg_list.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/public_room_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../config/themes.dart';
import '../../widgets/adaptive_dialogs/user_dialog.dart';
import '../../widgets/matrix.dart';
import 'chat_list_header.dart';

class ChatListViewBody extends StatelessWidget {
  final ChatListController controller;

  const ChatListViewBody(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final client = Matrix.of(context).client;
    final activeSpace = controller.activeSpaceId;
    if (activeSpace != null) {
      return SpaceView(
        key: ValueKey(activeSpace),
        spaceId: activeSpace,
        onBack: controller.clearActiveSpace,
        onChatTab: (room) => controller.onChatTap(room),
        onChatContext: (room, context) =>
            controller.chatContextAction(room, context),
        activeChat: controller.activeChat,
        toParentSpace: controller.setActiveSpace,
      );
    }
    final spaces = client.rooms.where((r) => r.isSpace);
    final spaceDelegateCandidates = <String, Room>{};
    for (final space in spaces) {
      for (final spaceChild in space.spaceChildren) {
        final roomId = spaceChild.roomId;
        if (roomId == null) continue;
        spaceDelegateCandidates[roomId] = space;
      }
    }

    final publicRooms = controller.roomSearchResult?.chunk
        .where((room) => room.roomType != 'm.space')
        .toList();
    final publicSpaces = controller.roomSearchResult?.chunk
        .where((room) => room.roomType == 'm.space')
        .toList();
    final userSearchResult = controller.userSearchResult;
    const dummyChatCount = 4;
    final filter = controller.searchController.text.toLowerCase();
    return StreamBuilder(
      key: ValueKey(
        client.userID.toString(),
      ),
      stream: client.onSync.stream
          .where((s) => s.hasRoomUpdate)
          .rateLimit(const Duration(seconds: 1)),
      builder: (context, _) {
        final rooms = controller.filteredRooms;

        return SafeArea(
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              ChatListHeader(controller: controller),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (controller.isSearchMode) ...[
                      SearchTitle(
                        title: L10n.of(context).publicRooms,
                        icon: const Icon(Icons.explore_outlined),
                      ),
                      PublicRoomsHorizontalList(publicRooms: publicRooms),
                      SearchTitle(
                        title: L10n.of(context).publicSpaces,
                        icon: const Icon(Icons.workspaces_outlined),
                      ),
                      PublicRoomsHorizontalList(publicRooms: publicSpaces),
                      SearchTitle(
                        title: L10n.of(context).users,
                        icon: const Icon(Icons.group_outlined),
                      ),
                      AnimatedContainer(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        height: userSearchResult == null ||
                                userSearchResult.results.isEmpty
                            ? 0
                            : 106,
                        duration: FluffyThemes.animationDuration,
                        curve: FluffyThemes.animationCurve,
                        child: userSearchResult == null
                            ? null
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: userSearchResult.results.length,
                                itemBuilder: (context, i) => _SearchItem(
                                  title:
                                      userSearchResult.results[i].displayName ??
                                          userSearchResult
                                              .results[i].userId.localpart ??
                                          L10n.of(context).unknownDevice,
                                  avatar: userSearchResult.results[i].avatarUrl,
                                  onPressed: () => UserDialog.show(
                                    context: context,
                                    profile: userSearchResult.results[i],
                                  ),
                                ),
                              ),
                      ),
                    ],
                    if (!controller.isSearchMode && AppConfig.showPresences)
                      GestureDetector(
                        onLongPress: () => controller.dismissStatusList(),
                        child: StatusMessageList(
                          onStatusEdit: controller.setStatus,
                        ),
                      ),
                    AnimatedContainer(
                      height: controller.isTorBrowser ? 64 : 0,
                      duration: FluffyThemes.animationDuration,
                      curve: FluffyThemes.animationCurve,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(),
                      child: Material(
                        color: theme.colorScheme.surface,
                        child: ListTile(
                          leading: const Icon(Icons.vpn_key),
                          title: Text(L10n.of(context).dehydrateTor),
                          subtitle: Text(L10n.of(context).dehydrateTorLong),
                          trailing: const Icon(Icons.chevron_right_outlined),
                          onTap: controller.dehydrate,
                        ),
                      ),
                    ),
                    if (client.rooms.isNotEmpty && !controller.isSearchMode)
                      SizedBox(
                        height: 64,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (AppConfig.separateChatTypes)
                              ActiveFilter.messages
                            else
                              ActiveFilter.allChats,
                            ActiveFilter.groups,
                            ActiveFilter.unread,
                            if (spaceDelegateCandidates.isNotEmpty &&
                                !AppConfig.displayNavigationRail &&
                                !FluffyThemes.isColumnMode(context))
                              ActiveFilter.spaces,
                          ]
                              .map(
                                (filter) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: FilterChip(
                                    selected: filter == controller.activeFilter,
                                    onSelected: (_) =>
                                        controller.setActiveFilter(filter),
                                    label:
                                        Text(filter.toLocalizedString(context)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    if (controller.isSearchMode)
                      SearchTitle(
                        title: L10n.of(context).chats,
                        icon: const Icon(Icons.forum_outlined),
                      ),
                    if (client.prevBatch != null &&
                        rooms.isEmpty &&
                        !controller.isSearchMode) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DummyChatListItem(
                                    opacity: 0.5,
                                    animate: false,
                                  ),
                                  DummyChatListItem(
                                    opacity: 0.3,
                                    animate: false,
                                  ),
                                ],
                              ),
                              Icon(
                                CupertinoIcons.chat_bubble_text_fill,
                                size: 128,
                                color: theme.colorScheme.secondary,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              client.rooms.isEmpty
                                  ? L10n.of(context).noChatsFoundHere
                                  : L10n.of(context).noMoreChatsFound,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (client.prevBatch == null)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => DummyChatListItem(
                      opacity: (dummyChatCount - i) / dummyChatCount,
                      animate: true,
                    ),
                    childCount: dummyChatCount,
                  ),
                ),
              if (client.prevBatch != null)
                SliverList.builder(
                  itemCount: rooms.length,
                  itemBuilder: (BuildContext context, int i) {
                    final room = rooms[i];
                    final space = spaceDelegateCandidates[room.id];
                    return ChatListItem(
                      room,
                      space: space,
                      key: Key('chat_list_item_${room.id}'),
                      filter: filter,
                      onTap: () => controller.onChatTap(room),
                      onLongPress: (context) =>
                          controller.chatContextAction(room, context, space),
                      activeChat: controller.activeChat == room.id,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class PublicRoomsHorizontalList extends StatelessWidget {
  const PublicRoomsHorizontalList({
    super.key,
    required this.publicRooms,
  });

  final List<PublicRoomsChunk>? publicRooms;

  @override
  Widget build(BuildContext context) {
    final publicRooms = this.publicRooms;
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: publicRooms == null || publicRooms.isEmpty ? 0 : 106,
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      child: publicRooms == null
          ? null
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: publicRooms.length,
              itemBuilder: (context, i) => _SearchItem(
                title: publicRooms[i].name ??
                    publicRooms[i].canonicalAlias?.localpart ??
                    L10n.of(context).group,
                avatar: publicRooms[i].avatarUrl,
                onPressed: () => showAdaptiveDialog(
                  context: context,
                  builder: (c) => PublicRoomDialog(
                    roomAlias:
                        publicRooms[i].canonicalAlias ?? publicRooms[i].roomId,
                    chunk: publicRooms[i],
                  ),
                ),
              ),
            ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final String title;
  final Uri? avatar;
  final void Function() onPressed;

  const _SearchItem({
    required this.title,
    this.avatar,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 84,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Avatar(
                mxContent: avatar,
                name: title,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
