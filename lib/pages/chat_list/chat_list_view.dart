import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pages/chat_list/spaces_bottom_bar.dart';
import 'package:fluffychat/pages/chat_list/stories_header.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/client_stories_extension.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
        stream: Matrix.of(context).onShareContentChanged.stream,
        builder: (_, __) {
          final selectMode = controller.selectMode;
          return VWidgetGuard(
            onSystemPop: (redirector) async {
              final selMode = controller.selectMode;
              if (selMode != SelectMode.normal) controller.cancelAction();
              if (selMode == SelectMode.select) redirector.stopRedirection();
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: controller.scrolledToTop ? 0 : null,
                actionsIconTheme: IconThemeData(
                  color: controller.selectedRoomIds.isEmpty
                      ? null
                      : Theme.of(context).colorScheme.primary,
                ),
                leading: selectMode == SelectMode.normal
                    ? Matrix.of(context).isMultiAccount
                        ? ClientChooserButton(controller)
                        : null
                    : IconButton(
                        tooltip: L10n.of(context)!.cancel,
                        icon: const Icon(Icons.close_outlined),
                        onPressed: controller.cancelAction,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                centerTitle: false,
                actions: selectMode == SelectMode.share
                    ? null
                    : selectMode == SelectMode.select
                        ? [
                            if (controller.spaces.isNotEmpty)
                              IconButton(
                                tooltip: L10n.of(context)!.addToSpace,
                                icon: const Icon(Icons.group_work_outlined),
                                onPressed: controller.addOrRemoveToSpace,
                              ),
                            IconButton(
                              tooltip: L10n.of(context)!.toggleUnread,
                              icon: Icon(
                                  controller.anySelectedRoomNotMarkedUnread
                                      ? Icons.mark_chat_read_outlined
                                      : Icons.mark_chat_unread_outlined),
                              onPressed: controller.toggleUnread,
                            ),
                            IconButton(
                              tooltip: L10n.of(context)!.toggleFavorite,
                              icon: Icon(controller.anySelectedRoomNotFavorite
                                  ? Icons.push_pin_outlined
                                  : Icons.push_pin),
                              onPressed: controller.toggleFavouriteRoom,
                            ),
                            IconButton(
                              icon: Icon(controller.anySelectedRoomNotMuted
                                  ? Icons.notifications_off_outlined
                                  : Icons.notifications_outlined),
                              tooltip: L10n.of(context)!.toggleMuted,
                              onPressed: controller.toggleMuted,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outlined),
                              tooltip: L10n.of(context)!.archive,
                              onPressed: controller.archiveAction,
                            ),
                          ]
                        : [
                            IconButton(
                              icon: const Icon(Icons.search_outlined),
                              tooltip: L10n.of(context)!.search,
                              onPressed: () =>
                                  VRouter.of(context).to('/search'),
                            ),
                            if (selectMode == SelectMode.normal &&
                                Matrix.of(context).client.storiesRooms.isEmpty)
                              IconButton(
                                icon: const Icon(Icons.camera_alt_outlined),
                                tooltip: L10n.of(context)!.addToStory,
                                onPressed: () =>
                                    VRouter.of(context).to('/stories/create'),
                              ),
                            PopupMenuButton<PopupMenuAction>(
                              onSelected: controller.onPopupMenuSelect,
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: PopupMenuAction.setStatus,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.setStatus),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopupMenuAction.newGroup,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.group_add_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.createNewGroup),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopupMenuAction.newSpace,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.group_work_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.createNewSpace),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopupMenuAction.invite,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.share_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.inviteContact),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopupMenuAction.archive,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.archive_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.archive),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopupMenuAction.settings,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.settings_outlined),
                                      const SizedBox(width: 12),
                                      Text(L10n.of(context)!.settings),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                title: Text(selectMode == SelectMode.share
                    ? L10n.of(context)!.share
                    : selectMode == SelectMode.select
                        ? controller.selectedRoomIds.length.toString()
                        : controller.activeSpaceId == null
                            ? AppConfig.applicationName
                            : Matrix.of(context)
                                .client
                                .getRoomById(controller.activeSpaceId!)!
                                .displayname),
              ),
              body: Column(children: [
                AnimatedContainer(
                  height: controller.showChatBackupBanner ? 54 : 0,
                  duration: const Duration(milliseconds: 300),
                  clipBehavior: Clip.hardEdge,
                  curve: Curves.bounceInOut,
                  decoration: const BoxDecoration(),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      leading: Image.asset(
                        'assets/backup.png',
                        fit: BoxFit.contain,
                        width: 44,
                      ),
                      title: Text(L10n.of(context)!.setupChatBackupNow),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: controller.firstRunBootstrapAction,
                    ),
                  ),
                ),
                Expanded(child: _ChatListViewBody(controller)),
              ]),
              floatingActionButton: selectMode == SelectMode.normal
                  ? FloatingActionButton.extended(
                      isExtended: controller.scrolledToTop,
                      onPressed: () =>
                          VRouter.of(context).to('/newprivatechat'),
                      icon: const Icon(CupertinoIcons.chat_bubble),
                      label: Text(L10n.of(context)!.newChat),
                    )
                  : null,
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ConnectionStatusHeader(),
                  if (controller.spaces.isNotEmpty &&
                      controller.selectedRoomIds.isEmpty)
                    SpacesBottomBar(controller),
                ],
              ),
            ),
          );
        });
  }
}

class _ChatListViewBody extends StatefulWidget {
  final ChatListController controller;

  const _ChatListViewBody(this.controller, {Key? key}) : super(key: key);

  @override
  State<_ChatListViewBody> createState() => _ChatListViewBodyState();
}

class _ChatListViewBodyState extends State<_ChatListViewBody> {
  // the matrix sync stream
  late StreamSubscription _subscription;
  late StreamSubscription _clientSubscription;

  // used to check the animation direction
  String? _lastUserId;
  String? _lastSpaceId;

  @override
  void initState() {
    _subscription = Matrix.of(context)
        .client
        .onSync
        .stream
        .where((s) => s.hasRoomUpdate)
        .rateLimit(const Duration(seconds: 1))
        .listen((d) => setState(() {}));
    _clientSubscription =
        widget.controller.clientStream.listen((d) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reversed = _animationReversed();
    Widget child;
    if (widget.controller.waitForFirstSync &&
        Matrix.of(context).client.prevBatch != null) {
      final rooms = Matrix.of(context)
          .client
          .rooms
          .where(widget.controller.roomCheck)
          .toList();
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
        final displayStoriesHeader = widget.controller.activeSpaceId == null;
        child = ListView.builder(
          key: ValueKey(Matrix.of(context).client.userID.toString() +
              widget.controller.activeSpaceId.toString()),
          controller: widget.controller.scrollController,
          itemCount: rooms.length + (displayStoriesHeader ? 1 : 0),
          itemBuilder: (BuildContext context, int i) {
            if (displayStoriesHeader) {
              if (i == 0) {
                return const StoriesHeader();
              }
              i--;
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
      const dummyChatCount = 8;
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
    child = Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
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
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _clientSubscription.cancel();
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
      reversed = widget.controller.spaces
              .indexWhere((element) => element.id == _lastSpaceId) <
          widget.controller.spaces.indexWhere(
              (element) => element.id == widget.controller.activeSpaceId);
    }
    _lastUserId = newClient.userID;
    _lastSpaceId = widget.controller.activeSpaceId;
    return reversed;
  }
}

enum ChatListPopupMenuItemActions {
  createGroup,
  createSpace,
  discover,
  setStatus,
  inviteContact,
  settings,
}
