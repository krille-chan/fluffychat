import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/connection_status_header.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

enum ChatListType { messages, groups, all }

enum SelectMode { normal, select }

class ChatList extends StatefulWidget {
  final ChatListType type;
  final void Function(AppBar appBar) onCustomAppBar;

  const ChatList({
    Key key,
    @required this.type,
    this.onCustomAppBar,
  }) : super(key: key);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool get searchMode => searchController.text?.isNotEmpty ?? false;
  final TextEditingController searchController = TextEditingController();
  final _selectedRoomIds = <String>{};

  void _toggleSelection(String roomId) {
    setState(() => _selectedRoomIds.contains(roomId)
        ? _selectedRoomIds.remove(roomId)
        : _selectedRoomIds.add(roomId));
    widget.onCustomAppBar(
      _selectedRoomIds.isEmpty
          ? null
          : AppBar(
              centerTitle: false,
              leading: IconButton(
                icon: Icon(Icons.close_outlined),
                onPressed: () {
                  _selectedRoomIds.clear();
                  widget.onCustomAppBar(null);
                },
              ),
              title: Text(
                L10n.of(context)
                    .numberSelected(_selectedRoomIds.length.toString()),
              ),
              actions: [
                if (_selectedRoomIds.length == 1)
                  IconButton(
                    tooltip: L10n.of(context).toggleUnread,
                    icon: Icon(Matrix.of(context)
                            .client
                            .getRoomById(_selectedRoomIds.single)
                            .isUnread
                        ? Icons.mark_chat_read_outlined
                        : Icons.mark_chat_unread_outlined),
                    onPressed: () => _toggleUnread(context),
                  ),
                if (_selectedRoomIds.length == 1)
                  IconButton(
                    tooltip: L10n.of(context).toggleFavorite,
                    icon: Icon(Icons.push_pin_outlined),
                    onPressed: () => _toggleFavouriteRoom(context),
                  ),
                if (_selectedRoomIds.length == 1)
                  IconButton(
                    icon: Icon(Matrix.of(context)
                                .client
                                .getRoomById(_selectedRoomIds.single)
                                .pushRuleState ==
                            PushRuleState.notify
                        ? Icons.notifications_off_outlined
                        : Icons.notifications_outlined),
                    tooltip: L10n.of(context).toggleMuted,
                    onPressed: () => _toggleMuted(context),
                  ),
                IconButton(
                  icon: Icon(Icons.archive_outlined),
                  tooltip: L10n.of(context).archive,
                  onPressed: () => _archiveAction(context),
                ),
              ],
            ),
    );
  }

  Future<void> _toggleUnread(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setUnread(!room.isUnread),
    );
  }

  Future<void> _toggleFavouriteRoom(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setFavourite(!room.isFavourite),
    );
  }

  Future<void> _toggleMuted(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
    return showFutureLoadingDialog(
      context: context,
      future: () => room.setPushRuleState(
          room.pushRuleState == PushRuleState.notify
              ? PushRuleState.mentions_only
              : PushRuleState.notify),
    );
  }

  Future<void> _archiveAction(BuildContext context) async {
    final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => _archiveSelectedRooms(context),
    );
    setState(() => null);
  }

  Future<void> _archiveSelectedRooms(BuildContext context) async {
    final client = Matrix.of(context).client;
    while (_selectedRoomIds.isNotEmpty) {
      final roomId = _selectedRoomIds.first;
      await client.getRoomById(roomId).leave();
      _toggleSelection(roomId);
    }
  }

  Future<void> waitForFirstSync(BuildContext context) async {
    var client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final selectMode =
        _selectedRoomIds.isEmpty ? SelectMode.normal : SelectMode.select;
    return Column(children: [
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
                future: waitForFirstSync(context),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    var rooms =
                        List<Room>.from(Matrix.of(context).client.rooms);
                    rooms.removeWhere((room) =>
                        room.lastEvent == null ||
                        (searchMode &&
                            !room.displayname.toLowerCase().contains(
                                searchController.text.toLowerCase() ?? '')));
                    if (widget.type == ChatListType.messages) {
                      rooms.removeWhere((room) => !room.isDirectChat);
                    } else if (widget.type == ChatListType.groups) {
                      rooms.removeWhere((room) => room.isDirectChat);
                    }
                    if (rooms.isEmpty && (!searchMode)) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            searchMode
                                ? Icons.search_outlined
                                : Icons.maps_ugc_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          Text(
                            searchMode
                                ? L10n.of(context).noRoomsFound
                                : L10n.of(context).startYourFirstChat,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }
                    final totalCount = rooms.length;
                    return ListView.builder(
                      itemCount: totalCount + 1,
                      itemBuilder: (BuildContext context, int i) => i == 0
                          ? Padding(
                              padding: EdgeInsets.all(12),
                              child: DefaultAppBarSearchField(
                                hintText: L10n.of(context).search,
                                prefixIcon: Icon(Icons.search_outlined),
                                searchController: searchController,
                                onChanged: (_) => setState(() => null),
                                padding: EdgeInsets.zero,
                              ),
                            )
                          : ChatListItem(
                              rooms[i - 1],
                              selected:
                                  _selectedRoomIds.contains(rooms[i - 1].id),
                              onTap: selectMode == SelectMode.select &&
                                      widget.onCustomAppBar != null
                                  ? () => _toggleSelection(rooms[i - 1].id)
                                  : null,
                              onLongPress: widget.onCustomAppBar != null
                                  ? () => _toggleSelection(rooms[i - 1].id)
                                  : null,
                              activeChat: Matrix.of(context).activeRoomId ==
                                  rooms[i - 1].id,
                            ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }),
      ),
    ]);
  }
}
