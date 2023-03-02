import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/space_view.dart';
import 'package:fluffychat/pages/chat_list/stories_header.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/client_stories_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/profile_bottom_sheet.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';
import '../../config/themes.dart';
import '../../widgets/connection_status_header.dart';
import '../../widgets/matrix.dart';

class ChatListViewBody extends StatelessWidget {
  final ChatListController controller;

  const ChatListViewBody(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomSearchResult = controller.roomSearchResult;
    final userSearchResult = controller.userSearchResult;
    final client = Matrix.of(context).client;

    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        );
      },
      child: StreamBuilder(
        key: ValueKey(
          client.userID.toString() +
              controller.activeFilter.toString() +
              controller.activeSpaceId.toString(),
        ),
        stream: client.onSync.stream
            .where((s) => s.hasRoomUpdate)
            .rateLimit(const Duration(seconds: 1)),
        builder: (context, _) {
          if (controller.activeFilter == ActiveFilter.spaces &&
              !controller.isSearchMode) {
            return SpaceView(
              controller,
              scrollController: controller.scrollController,
              key: Key(controller.activeSpaceId ?? 'Spaces'),
            );
          }
          if (controller.waitForFirstSync && client.prevBatch != null) {
            final rooms = controller.filteredRooms;
            final displayStoriesHeader = {
                  ActiveFilter.allChats,
                  ActiveFilter.messages,
                }.contains(controller.activeFilter) &&
                client.storiesRooms.isNotEmpty;
            return ListView.builder(
              controller: controller.scrollController,
              // add +1 space below in order to properly scroll below the spaces bar
              itemCount: rooms.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isSearchMode) ...[
                        SearchTitle(
                          title: L10n.of(context)!.publicRooms,
                          icon: const Icon(Icons.explore_outlined),
                        ),
                        AnimatedContainer(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(),
                          height: roomSearchResult == null ||
                                  roomSearchResult.chunk.isEmpty
                              ? 0
                              : 106,
                          duration: FluffyThemes.animationDuration,
                          curve: FluffyThemes.animationCurve,
                          child: roomSearchResult == null
                              ? null
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: roomSearchResult.chunk.length,
                                  itemBuilder: (context, i) => _SearchItem(
                                    title: roomSearchResult.chunk[i].name ??
                                        roomSearchResult.chunk[i].canonicalAlias
                                            ?.localpart ??
                                        L10n.of(context)!.group,
                                    avatar: roomSearchResult.chunk[i].avatarUrl,
                                    onPressed: () => showAdaptiveBottomSheet(
                                      context: context,
                                      builder: (c) => PublicRoomBottomSheet(
                                        roomAlias: roomSearchResult
                                                .chunk[i].canonicalAlias ??
                                            roomSearchResult.chunk[i].roomId,
                                        outerContext: context,
                                        chunk: roomSearchResult.chunk[i],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SearchTitle(
                          title: L10n.of(context)!.users,
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
                                    title: userSearchResult
                                            .results[i].displayName ??
                                        userSearchResult
                                            .results[i].userId.localpart ??
                                        L10n.of(context)!.unknownDevice,
                                    avatar:
                                        userSearchResult.results[i].avatarUrl,
                                    onPressed: () => showAdaptiveBottomSheet(
                                      context: context,
                                      builder: (c) => ProfileBottomSheet(
                                        userId:
                                            userSearchResult.results[i].userId,
                                        outerContext: context,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SearchTitle(
                          title: L10n.of(context)!.stories,
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                      ],
                      if (displayStoriesHeader)
                        StoriesHeader(
                          key: const Key('stories_header'),
                          filter: controller.searchController.text,
                        ),
                      const ConnectionStatusHeader(),
                      AnimatedContainer(
                        height: controller.isTorBrowser ? 64 : 0,
                        duration: FluffyThemes.animationDuration,
                        curve: FluffyThemes.animationCurve,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          child: ListTile(
                            leading: const Icon(Icons.vpn_key),
                            title: Text(L10n.of(context)!.dehydrateTor),
                            subtitle: Text(L10n.of(context)!.dehydrateTorLong),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: controller.dehydrate,
                          ),
                        ),
                      ),
                      if (controller.isSearchMode)
                        SearchTitle(
                          title: L10n.of(context)!.chats,
                          icon: const Icon(Icons.chat_outlined),
                        ),
                      if (rooms.isEmpty && !controller.isSearchMode)
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/start_chat.png',
                                height: 256,
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        ),
                    ],
                  );
                }
                i--;
                if (!rooms[i]
                    .getLocalizedDisplayname(MatrixLocals(L10n.of(context)!))
                    .toLowerCase()
                    .contains(
                      controller.searchController.text.toLowerCase(),
                    )) {
                  return Container();
                }
                return ChatListItem(
                  rooms[i],
                  key: Key('chat_list_item_${rooms[i].id}'),
                  selected: controller.selectedRoomIds.contains(rooms[i].id),
                  onTap: controller.selectMode == SelectMode.select
                      ? () => controller.toggleSelection(rooms[i].id)
                      : null,
                  onLongPress: () => controller.toggleSelection(rooms[i].id),
                  activeChat: controller.activeChat == rooms[i].id,
                );
              },
            );
          }
          const dummyChatCount = 5;
          final titleColor =
              Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(100);
          final subtitleColor =
              Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(50);
          return ListView.builder(
            key: const Key('dummychats'),
            itemCount: dummyChatCount,
            itemBuilder: (context, i) => Opacity(
              opacity: (dummyChatCount - i) / dummyChatCount,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: titleColor,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: titleColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: subtitleColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: subtitleColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  height: 12,
                  margin: const EdgeInsets.only(right: 22),
                ),
              ),
            ),
          );
        },
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
    Key? key,
  }) : super(key: key);

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
