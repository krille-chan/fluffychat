import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/spaces_entry.dart';
import 'package:fluffychat/pages/chat_list/stories_header.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/profile_bottom_sheet.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';

class ChatListViewBody extends StatefulWidget {
  final ChatListController controller;

  const ChatListViewBody(this.controller, {Key? key}) : super(key: key);

  @override
  State<ChatListViewBody> createState() => _ChatListViewBodyState();
}

class _ChatListViewBodyState extends State<ChatListViewBody> {
  // the matrix sync stream
  late StreamSubscription _subscription;

  // used to check the animation direction
  String? _lastUserId;
  SpacesEntry? _lastSpace;

  @override
  void initState() {
    _subscription = Matrix.of(context)
        .client
        .onSync
        .stream
        .where((s) => s.hasRoomUpdate)
        .rateLimit(const Duration(seconds: 1))
        .listen((d) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reversed = !_animationReversed();
    final roomSearchResult = widget.controller.roomSearchResult;
    final userSearchResult = widget.controller.userSearchResult;
    Widget child;
    if (widget.controller.waitForFirstSync &&
        Matrix.of(context).client.prevBatch != null) {
      final rooms = widget.controller.activeSpacesEntry.getRooms(context);
      if (rooms.isEmpty) {
        child = Column(
          key: const ValueKey(null),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/private_chat_wallpaper.png',
              width: 160,
              height: 160,
            ),
            Center(
              child: Text(
                L10n.of(context)!.startYourFirstChat,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      } else {
        final displayStoriesHeader = widget.controller.activeSpacesEntry
            .shouldShowStoriesHeader(context);
        child = ListView.builder(
          key: ValueKey(Matrix.of(context).client.userID.toString() +
              widget.controller.activeSpaceId.toString() +
              widget.controller.activeSpacesEntry.runtimeType.toString()),
          controller: widget.controller.scrollController,
          // add +1 space below in order to properly scroll below the spaces bar
          itemCount: rooms.length + (displayStoriesHeader ? 2 : 1),
          itemBuilder: (BuildContext context, int i) {
            if (displayStoriesHeader) {
              if (i == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ConnectionStatusHeader(),
                    if (roomSearchResult != null) ...[
                      _SearchTitle(title: L10n.of(context)!.publicRooms),
                      AnimatedContainer(
                        height: roomSearchResult.chunk.isEmpty ? 0 : 106,
                        duration: const Duration(milliseconds: 250),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: roomSearchResult.chunk.length,
                          itemBuilder: (context, i) => _SearchItem(
                            title: roomSearchResult.chunk[i].name ??
                                roomSearchResult
                                    .chunk[i].canonicalAlias?.localpart ??
                                L10n.of(context)!.group,
                            avatar: roomSearchResult.chunk[i].avatarUrl,
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (c) => PublicRoomBottomSheet(
                                roomAlias:
                                    roomSearchResult.chunk[i].canonicalAlias ??
                                        roomSearchResult.chunk[i].roomId,
                                outerContext: context,
                                chunk: roomSearchResult.chunk[i],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (userSearchResult != null) ...[
                      _SearchTitle(title: L10n.of(context)!.users),
                      AnimatedContainer(
                        height: userSearchResult.results.isEmpty ? 0 : 106,
                        duration: const Duration(milliseconds: 250),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userSearchResult.results.length,
                          itemBuilder: (context, i) => _SearchItem(
                            title: userSearchResult.results[i].displayName ??
                                userSearchResult.results[i].userId.localpart ??
                                L10n.of(context)!.unknownDevice,
                            avatar: userSearchResult.results[i].avatarUrl,
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (c) => ProfileBottomSheet(
                                userId: userSearchResult.results[i].userId,
                                outerContext: context,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (widget.controller.isSearchMode)
                      _SearchTitle(title: L10n.of(context)!.stories),
                    StoriesHeader(
                      filter: widget.controller.searchController.text,
                    ),
                    AnimatedContainer(
                      height: !widget.controller.isSearchMode &&
                              widget.controller.showChatBackupBanner
                          ? 54
                          : 0,
                      duration: const Duration(milliseconds: 300),
                      clipBehavior: Clip.hardEdge,
                      curve: Curves.bounceInOut,
                      decoration: const BoxDecoration(),
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: Avatar.defaultSize / 2,
                            child:
                                const Icon(Icons.enhanced_encryption_outlined),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          title: Text(
                            Matrix.of(context)
                                    .client
                                    .encryption!
                                    .keyManager
                                    .enabled
                                ? L10n.of(context)!.unlockOldMessages
                                : L10n.of(context)!.enableAutoBackups,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_outlined),
                          onTap: widget.controller.firstRunBootstrapAction,
                        ),
                      ),
                    ),
                    if (widget.controller.isSearchMode)
                      _SearchTitle(title: L10n.of(context)!.chats),
                  ],
                );
              }
              i--;
            }
            if (i >= rooms.length) {
              return const ListTile();
            }
            if (!rooms[i].displayname.toLowerCase().contains(
                widget.controller.searchController.text.toLowerCase())) {
              return Container();
            }
            return ChatListItem(
              rooms[i],
              selected: widget.controller.selectedRoomIds.contains(rooms[i].id),
              onTap: widget.controller.selectMode == SelectMode.select
                  ? () => widget.controller.toggleSelection(rooms[i].id)
                  : null,
              onLongPress: () => widget.controller.toggleSelection(rooms[i].id),
              activeChat: widget.controller.activeChat == rooms[i].id,
            );
          },
        );
      }
    } else {
      const dummyChatCount = 5;
      final titleColor =
          Theme.of(context).textTheme.bodyText1!.color!.withAlpha(100);
      final subtitleColor =
          Theme.of(context).textTheme.bodyText1!.color!.withAlpha(50);
      child = ListView.builder(
        itemCount: dummyChatCount,
        itemBuilder: (context, i) => Opacity(
          opacity: (dummyChatCount - i) / dummyChatCount,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: titleColor,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).textTheme.bodyText1!.color,
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
    }
    return PageTransitionSwitcher(
      reverse: reversed,
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
      child: child,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool _animationReversed() {
    bool reversed;
    // in case the matrix id changes, check the indexOf the matrix id
    final newClient = Matrix.of(context).client;
    if (_lastUserId != newClient.userID) {
      reversed = Matrix.of(context)
              .currentBundle!
              .indexWhere((element) => element!.userID == _lastUserId) <
          Matrix.of(context)
              .currentBundle!
              .indexWhere((element) => element!.userID == newClient.userID);
    }
    // otherwise, the space changed...
    else {
      reversed = widget.controller.spacesEntries
              .indexWhere((element) => element == _lastSpace) <
          widget.controller.spacesEntries.indexWhere(
              (element) => element == widget.controller.activeSpacesEntry);
    }
    _lastUserId = newClient.userID;
    _lastSpace = widget.controller.activeSpacesEntry;
    return reversed;
  }
}

class _SearchTitle extends StatelessWidget {
  final String title;
  const _SearchTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          )),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      );
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
