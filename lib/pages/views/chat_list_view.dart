import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/chat_list.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/list_items/chat_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import '../../widgets/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
                  leading: selectMode == SelectMode.normal
                      ? null
                      : IconButton(
                          tooltip: L10n.of(context).cancel,
                          icon: Icon(Icons.close_outlined),
                          onPressed: controller.cancelAction,
                        ),
                  centerTitle: false,
                  actions: selectMode == SelectMode.share
                      ? null
                      : selectMode == SelectMode.select
                          ? [
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
                                  icon: Icon(Icons.push_pin_outlined),
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
                                icon: Icon(Icons.archive_outlined),
                                tooltip: L10n.of(context).archive,
                                onPressed: controller.archiveAction,
                              ),
                            ]
                          : [
                              IconButton(
                                icon: Icon(Icons.search_outlined),
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
                                        Icon(Icons.edit_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).setStatus),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: PopupMenuAction.newGroup,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.group_add_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).createNewGroup),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: PopupMenuAction.invite,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.share_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).inviteContact),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: PopupMenuAction.archive,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.archive_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).archive),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: PopupMenuAction.settings,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.settings_outlined),
                                        SizedBox(width: 12),
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
                          ? L10n.of(context).numberSelected(
                              controller.selectedRoomIds.length.toString())
                          : AppConfig.applicationName),
                ),
                body: Column(children: [
                  ConnectionStatusHeader(),
                  Expanded(
                    child: StreamBuilder(
                        stream: Matrix.of(context)
                            .client
                            .onSync
                            .stream
                            .where((s) => s.hasRoomUpdate),
                        builder: (context, snapshot) {
                          return FutureBuilder<void>(
                            future: controller.waitForFirstSync(),
                            builder: (BuildContext context, snapshot) {
                              if (Matrix.of(context).client.prevBatch != null) {
                                final rooms = List<Room>.from(
                                    Matrix.of(context).client.rooms);
                                rooms.removeWhere(
                                    (room) => room.lastEvent == null);
                                if (rooms.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.maps_ugc_outlined,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      Center(
                                        child: Text(
                                          L10n.of(context).startYourFirstChat,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                final totalCount = rooms.length + 1;
                                return ListView.builder(
                                  itemCount: totalCount,
                                  itemBuilder: (BuildContext context, int i) {
                                    if (i == 0) {
                                      return FutureBuilder(
                                          future: controller
                                              .crossSigningCachedFuture,
                                          builder: (context, snapshot) {
                                            final needsBootstrap =
                                                Matrix.of(context)
                                                            .client
                                                            .encryption
                                                            ?.crossSigning
                                                            ?.enabled ==
                                                        false ||
                                                    snapshot.data == false;
                                            final isUnknownSession =
                                                Matrix.of(context)
                                                    .client
                                                    .isUnknownSession;
                                            final displayHeader =
                                                needsBootstrap ||
                                                    isUnknownSession;
                                            if (!displayHeader ||
                                                controller
                                                    .hideChatBackupBanner) {
                                              return Container();
                                            }
                                            return Material(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Theme.of(
                                                          context)
                                                      .scaffoldBackgroundColor,
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondaryVariant,
                                                  child: Icon(Icons.cloud),
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: controller
                                                      .hideChatBackupBannerAction,
                                                ),
                                                title: Text(L10n.of(context)
                                                    .chatBackup),
                                                subtitle: Text(L10n.of(context)
                                                    .enableChatBackup),
                                                onTap: controller
                                                    .firstRunBootstrapAction,
                                              ),
                                            );
                                          });
                                    }
                                    i--;
                                    return ChatListItem(
                                      rooms[i],
                                      selected: controller.selectedRoomIds
                                          .contains(rooms[i].id),
                                      onTap: selectMode == SelectMode.select
                                          ? () => controller
                                              .toggleSelection(rooms[i].id)
                                          : null,
                                      onLongPress: () => controller
                                          .toggleSelection(rooms[i].id),
                                      activeChat:
                                          controller.activeChat == rooms[i].id,
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
                                        L10n.of(context)
                                            .yourChatsAreBeingSynced,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        }),
                  ),
                ]),
                floatingActionButton: selectMode == SelectMode.normal
                    ? FloatingActionButton(
                        heroTag: 'main_fab',
                        onPressed: () =>
                            VRouter.of(context).to('/newprivatechat'),
                        child: Icon(CupertinoIcons.chat_bubble),
                      )
                    : null,
              ));
        });
  }
}

enum ChatListPopupMenuItemActions {
  createGroup,
  discover,
  setStatus,
  inviteContact,
  settings,
}
