import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:async/async.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../utils/account_bundles.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key key}) : super(key: key);

  List<BottomNavigationBarItem> getBottomBarItems(BuildContext context) {
    final displayClients = Matrix.of(context).currentBundle;
    if (displayClients.isEmpty) {
      displayClients.addAll(Matrix.of(context).widget.clients);
      controller.resetActiveBundle();
    }
    final items = displayClients.map((client) {
      return BottomNavigationBarItem(
        label: client.userID,
        icon: FutureBuilder<Profile>(
            future: client.ownProfile,
            builder: (context, snapshot) {
              return InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: () => controller.setActiveClient(client),
                onLongPress: () =>
                    controller.editBundlesForAccount(client.userID),
                child: Avatar(
                  snapshot.data?.avatarUrl,
                  snapshot.data?.displayName ?? client.userID.localpart,
                  size: 32,
                ),
              );
            }),
      );
    }).toList();

    if (controller.displayBundles && false) {
      items.insert(
          0,
          BottomNavigationBarItem(
              label: 'Bundles',
              icon: PopupMenuButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
                onSelected: controller.setActiveBundle,
                itemBuilder: (context) => Matrix.of(context)
                    .accountBundles
                    .keys
                    .map(
                      (bundle) => PopupMenuItem(
                        value: bundle,
                        child: Text(bundle),
                      ),
                    )
                    .toList(),
              )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
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
                    ? controller.spaces.isEmpty
                        ? null
                        : Builder(
                            builder: (context) => IconButton(
                                  icon: const Icon(Icons.group_work_outlined),
                                  onPressed: Scaffold.of(context).openDrawer,
                                ))
                    : IconButton(
                        tooltip: L10n.of(context).cancel,
                        icon: const Icon(Icons.close_outlined),
                        onPressed: controller.cancelAction,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                centerTitle: false,
                titleSpacing: controller.spaces.isEmpty ? null : 0,
                actions: selectMode == SelectMode.share
                    ? null
                    : selectMode == SelectMode.select
                        ? [
                            if (controller.spaces.isNotEmpty &&
                                !Matrix.of(context)
                                    .client
                                    .getRoomById(
                                        controller.selectedRoomIds.single)
                                    .isDirectChat)
                              IconButton(
                                tooltip: L10n.of(context).addToSpace,
                                icon: const Icon(Icons.group_work_outlined),
                                onPressed: controller.addOrRemoveToSpace,
                              ),
                            IconButton(
                              tooltip: L10n.of(context).toggleUnread,
                              icon: Icon(
                                  controller.anySelectedRoomNotMarkedUnread
                                      ? Icons.mark_chat_read_outlined
                                      : Icons.mark_chat_unread_outlined),
                              onPressed: controller.toggleUnread,
                            ),
                            IconButton(
                              tooltip: L10n.of(context).toggleFavorite,
                              icon: Icon(controller.anySelectedRoomNotFavorite
                                  ? Icons.push_pin_outlined
                                  : Icons.push_pin),
                              onPressed: controller.toggleFavouriteRoom,
                            ),
                            IconButton(
                              icon: Icon(controller.anySelectedRoomNotMuted
                                  ? Icons.notifications_off_outlined
                                  : Icons.notifications_outlined),
                              tooltip: L10n.of(context).toggleMuted,
                              onPressed: controller.toggleMuted,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outlined),
                              tooltip: L10n.of(context).archive,
                              onPressed: controller.archiveAction,
                            ),
                          ]
                        : [
                            IconButton(
                              icon: const Icon(Icons.search_outlined),
                              tooltip: L10n.of(context).search,
                              onPressed: () =>
                                  VRouter.of(context).to('/search'),
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
                                      Text(L10n.of(context).setStatus),
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
                                      Text(L10n.of(context).createNewGroup),
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
                                      Text(L10n.of(context).createNewSpace),
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
                                      Text(L10n.of(context).inviteContact),
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
                                      Text(L10n.of(context).archive),
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
                                      Text(L10n.of(context).settings),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                title: Text(selectMode == SelectMode.share
                    ? L10n.of(context).share
                    : selectMode == SelectMode.select
                        ? controller.selectedRoomIds.length.toString()
                        : controller.activeSpaceId == null
                            ? AppConfig.applicationName
                            : Matrix.of(context)
                                .client
                                .getRoomById(controller.activeSpaceId)
                                .displayname),
              ),
              body: Column(children: [
                const ConnectionStatusHeader(),
                Expanded(child: _ChatListViewBody(controller)),
              ]),
              floatingActionButton: selectMode == SelectMode.normal
                  ? controller.scrolledToTop
                      ? FloatingActionButton.extended(
                          onPressed: () =>
                              VRouter.of(context).to('/newprivatechat'),
                          icon: const Icon(CupertinoIcons.chat_bubble),
                          label: Text(L10n.of(context).newChat),
                        )
                      : FloatingActionButton(
                          onPressed: () =>
                              VRouter.of(context).to('/newprivatechat'),
                          child: const Icon(CupertinoIcons.chat_bubble),
                        )
                  : null,
              bottomNavigationBar: Matrix.of(context).isMultiAccount
                  ? StreamBuilder(
                      stream: StreamGroup.merge(Matrix.of(context)
                          .widget
                          .clients
                          .map((client) => client.onSync.stream.where((s) =>
                              s.accountData != null &&
                              s.accountData
                                  .any((e) => e.type == accountBundlesType)))),
                      builder: (context, _) => Material(
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(height: 1),
                            Builder(builder: (context) {
                              final items = getBottomBarItems(context);
                              if (items.length == 1) {
                                return Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      items.single.icon,
                                      Text(items.single.label),
                                    ],
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: max(
                                    FluffyThemes.isColumnMode(context)
                                        ? FluffyThemes.columnWidth
                                        : MediaQuery.of(context).size.width,
                                    Matrix.of(context).widget.clients.length *
                                        84.0,
                                  ),
                                  child: BottomNavigationBar(
                                    elevation: 0,
                                    onTap: (i) => controller.setActiveClient(
                                        Matrix.of(context).currentBundle[i]),
                                    currentIndex: Matrix.of(context)
                                        .currentBundle
                                        .indexWhere(
                                          (client) =>
                                              client ==
                                              Matrix.of(context).client,
                                        ),
                                    showUnselectedLabels: false,
                                    showSelectedLabels: true,
                                    type: BottomNavigationBarType.shifting,
                                    selectedItemColor:
                                        Theme.of(context).colorScheme.secondary,
                                    items: items,
                                  ),
                                ),
                              );
                            }),
                            if (controller.displayBundles)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 12,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CupertinoSlidingSegmentedControl(
                                    groupValue: controller.secureActiveBundle,
                                    onValueChanged: controller.setActiveBundle,
                                    children: Map.fromEntries(Matrix.of(context)
                                        .accountBundles
                                        .keys
                                        .map((bundle) =>
                                            MapEntry(bundle, Text(bundle)))),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : null,
              drawer: controller.spaces.isEmpty
                  ? null
                  : Drawer(
                      child: SafeArea(
                        child: ListView.builder(
                          itemCount: controller.spaces.length + 1,
                          itemBuilder: (context, i) {
                            if (i == 0) {
                              return ListTile(
                                selected: controller.activeSpaceId == null,
                                selectedTileColor:
                                    Theme.of(context).secondaryHeaderColor,
                                leading: CircleAvatar(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: Avatar.defaultSize / 2,
                                  child: const Icon(Icons.home_outlined),
                                ),
                                title: Text(L10n.of(context).allChats),
                                onTap: () =>
                                    controller.setActiveSpaceId(context, null),
                              );
                            }
                            final space = controller.spaces[i - 1];
                            return ListTile(
                              selected: controller.activeSpaceId == space.id,
                              selectedTileColor:
                                  Theme.of(context).secondaryHeaderColor,
                              leading: Avatar(space.avatar, space.displayname),
                              title: Text(space.displayname, maxLines: 1),
                              subtitle: Text(L10n.of(context).countParticipants(
                                  (space.summary.mJoinedMemberCount +
                                          space.summary.mInvitedMemberCount)
                                      .toString())),
                              onTap: () => controller.setActiveSpaceId(
                                  context, space.id),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    controller.editSpace(context, space.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}

class _ChatListViewBody extends StatelessWidget {
  final ChatListController controller;
  const _ChatListViewBody(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Matrix.of(context)
          .client
          .onSync
          .stream
          .where((s) => s.hasRoomUpdate)
          .rateLimit(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return FutureBuilder<void>(
          future: controller.waitForFirstSync,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final rooms = Matrix.of(context)
                  .client
                  .rooms
                  .where(controller.roomCheck)
                  .toList();
              if (rooms.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.maps_ugc_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    Center(
                      child: Text(
                        L10n.of(context).startYourFirstChat,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                itemCount: rooms.length,
                itemBuilder: (BuildContext context, int i) {
                  return ChatListItem(
                    rooms[i],
                    selected: controller.selectedRoomIds.contains(rooms[i].id),
                    onTap: controller.selectMode == SelectMode.select
                        ? () => controller.toggleSelection(rooms[i].id)
                        : null,
                    onLongPress: () => controller.toggleSelection(rooms[i].id),
                    activeChat: controller.activeChat == rooms[i].id,
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/private_chat_wallpaper.png',
                      width: 100,
                    ),
                    Text(
                      L10n.of(context).yourChatsAreBeingSynced,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          },
        );
      });
}

enum ChatListPopupMenuItemActions {
  createGroup,
  createSpace,
  discover,
  setStatus,
  inviteContact,
  settings,
}
