import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pages/chat_list/spaces_bottom_bar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../utils/stream_extension.dart';
import '../../widgets/matrix.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key key}) : super(key: key);

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
                    ? Matrix.of(context).isMultiAccount
                        ? ClientChooserButton(controller)
                        : null
                    : IconButton(
                        tooltip: L10n.of(context).cancel,
                        icon: const Icon(Icons.close_outlined),
                        onPressed: controller.cancelAction,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                centerTitle: false,
                actions: selectMode == SelectMode.share
                    ? null
                    : selectMode == SelectMode.select
                        ? [
                            if (controller.selectedRoomIds.length == 1 &&
                                controller.spaces.isNotEmpty &&
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
                            if (controller.selectedRoomIds.length == 1)
                              IconButton(
                                tooltip: L10n.of(context).toggleUnread,
                                icon: Icon(Matrix.of(context)
                                        .client
                                        .getRoomById(
                                            controller.selectedRoomIds.single)
                                        .isUnread
                                    ? Icons.mark_chat_read_outlined
                                    : Icons.mark_chat_unread_outlined),
                                onPressed: controller.toggleUnread,
                              ),
                            if (controller.selectedRoomIds.length == 1)
                              IconButton(
                                tooltip: L10n.of(context).toggleFavorite,
                                icon: const Icon(Icons.push_pin_outlined),
                                onPressed: controller.toggleFavouriteRoom,
                              ),
                            if (controller.selectedRoomIds.length == 1)
                              IconButton(
                                icon: Icon(Matrix.of(context)
                                            .client
                                            .getRoomById(controller
                                                .selectedRoomIds.single)
                                            .pushRuleState ==
                                        PushRuleState.notify
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
              bottomNavigationBar: controller.spaces.isEmpty
                  ? null
                  : SpacesBottomBar(controller),
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
