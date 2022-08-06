import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/chat_list/spaces_entry.dart';
import 'package:fluffychat/pages/chat_list/stories_header.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/profile_bottom_sheet.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';
import 'spaces_hierarchy_proposal.dart';

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

      final displayStoriesHeader = widget.controller.activeSpacesEntry
              .shouldShowStoriesHeader(context) ||
          rooms.isEmpty;
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
                  SpaceRoomListTopBar(widget.controller),
                  if (roomSearchResult != null) ...[
                    SearchTitle(
                      title: L10n.of(context)!.publicRooms,
                      icon: const Icon(Icons.explore_outlined),
                    ),
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
                    SearchTitle(
                      title: L10n.of(context)!.users,
                      icon: const Icon(Icons.group_outlined),
                    ),
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
                    SearchTitle(
                      title: L10n.of(context)!.stories,
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
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
                          child: const Icon(Icons.enhanced_encryption_outlined),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          (Matrix.of(context)
                                      .client
                                      .encryption
                                      ?.keyManager
                                      .enabled ==
                                  true)
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
                  AnimatedContainer(
                    height: widget.controller.isTorBrowser ? 64 : 0,
                    duration: const Duration(milliseconds: 300),
                    clipBehavior: Clip.hardEdge,
                    curve: Curves.bounceInOut,
                    decoration: const BoxDecoration(),
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        leading: const Icon(Icons.vpn_key),
                        title: Text(L10n.of(context)!.dehydrateTor),
                        subtitle: Text(L10n.of(context)!.dehydrateTorLong),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: widget.controller.dehydrate,
                      ),
                    ),
                  ),
                  if (widget.controller.isSearchMode)
                    SearchTitle(
                      title: L10n.of(context)!.chats,
                      icon: const Icon(Icons.chat_outlined),
                    ),
                  if (rooms.isEmpty && !widget.controller.isSearchMode)
                    Column(
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
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              );
            }
            i--;
          }
          if (i >= rooms.length) {
            return SpacesHierarchyProposals(
              space: widget.controller.activeSpacesEntry.getSpace(context)?.id,
              query: widget.controller.isSearchMode
                  ? widget.controller.searchController.text
                  : null,
            );
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

  @override
  void didUpdateWidget(covariant ChatListViewBody oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }
}

class SpaceRoomListTopBar extends StatefulWidget {
  final ChatListController controller;

  const SpaceRoomListTopBar(this.controller, {Key? key}) : super(key: key);

  @override
  State<SpaceRoomListTopBar> createState() => _SpaceRoomListTopBarState();
}

class _SpaceRoomListTopBarState extends State<SpaceRoomListTopBar> {
  bool _limitSize = true;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.activeSpacesEntry is SpaceSpacesEntry &&
        !widget.controller.isSearchMode &&
        (widget.controller.activeSpacesEntry as SpaceSpacesEntry)
            .space
            .topic
            .isNotEmpty) {
      return GestureDetector(
        onTap: () => setState(() {
          _limitSize = !_limitSize;
        }),
        child: Column(
          children: [
            Padding(
              child: LinkText(
                text: (widget.controller.activeSpacesEntry as SpaceSpacesEntry)
                    .space
                    .topic,
                maxLines: _limitSize ? 3 : null,
                linkStyle: const TextStyle(color: Colors.blueAccent),
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyText2!.color,
                ),
                onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
              ),
              padding: const EdgeInsets.all(8),
            ),
            const Divider(),
          ],
        ),
      );
    } else {
      return Container();
    }
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
