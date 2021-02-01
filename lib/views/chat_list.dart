import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/connection_status_header.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/default_drawer.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../components/list_items/chat_list_item.dart';
import '../components/matrix.dart';
import '../utils/matrix_file_extension.dart';
import '../utils/url_launcher.dart';

enum SelectMode { normal, share, select }

class ChatList extends StatefulWidget {
  final String activeChat;

  const ChatList({this.activeChat, Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool get searchMode => searchController.text?.isNotEmpty ?? false;
  final TextEditingController searchController = TextEditingController();
  final _selectedRoomIds = <String>{};

  final ScrollController _scrollController = ScrollController();
  bool _scrolledToTop = true;

  void _toggleSelection(String roomId) =>
      setState(() => _selectedRoomIds.contains(roomId)
          ? _selectedRoomIds.remove(roomId)
          : _selectedRoomIds.add(roomId));

  Future<void> waitForFirstSync(BuildContext context) async {
    var client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    return true;
  }

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels > 0 && _scrolledToTop) {
        setState(() => _scrolledToTop = false);
      } else if (_scrollController.position.pixels == 0 && !_scrolledToTop) {
        setState(() => _scrolledToTop = true);
      }
    });
    _initReceiveSharingIntent();
    super.initState();
  }

  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    final file = File(files.first.path);

    Matrix.of(context).shareContent = {
      'msgtype': 'chat.fluffy.shared_file',
      'file': MatrixFile(
        bytes: file.readAsBytesSync(),
        name: file.path,
      ).detectFileType,
    };
  }

  void _processIncomingSharedText(String text) {
    if (text == null) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    if (text.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        (text.toLowerCase().startsWith(AppConfig.schemePrefix) &&
            !RegExp(r'\s').hasMatch(text))) {
      UrlLauncher(context, text).openMatrixToUrl();
      return;
    }
    Matrix.of(context).shareContent = {
      'msgtype': 'm.text',
      'body': text,
    };
  }

  void _initReceiveSharingIntent() {
    if (!PlatformInfos.isMobile) return;

    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen(_processIncomingSharedFiles, onError: print);

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then(_processIncomingSharedFiles);

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen(_processIncomingSharedText, onError: print);

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then(_processIncomingSharedText);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    super.dispose();
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
      _selectedRoomIds.remove(roomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Matrix.of(context).onShareContentChanged.stream,
        builder: (context, snapshot) {
          final selectMode = Matrix.of(context).shareContent == null
              ? _selectedRoomIds.isEmpty
                  ? SelectMode.normal
                  : SelectMode.select
              : SelectMode.share;
          if (selectMode == SelectMode.share) {
            _selectedRoomIds.clear();
          }
          Room selectedRoom;
          if (_selectedRoomIds.length == 1) {
            selectedRoom =
                Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
          }
          return Scaffold(
            drawer: selectMode != SelectMode.normal ? null : DefaultDrawer(),
            appBar: AppBar(
              centerTitle: false,
              elevation: _scrolledToTop ? 0 : null,
              leading: selectMode == SelectMode.share
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Matrix.of(context).shareContent = null,
                    )
                  : selectMode == SelectMode.select
                      ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => setState(_selectedRoomIds.clear),
                        )
                      : null,
              titleSpacing: 0,
              actions: selectMode != SelectMode.select
                  ? null
                  : [
                      if (_selectedRoomIds.length == 1)
                        IconButton(
                          tooltip: L10n.of(context).toggleUnread,
                          icon: Icon(selectedRoom.isUnread
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
                          icon: Icon(
                              selectedRoom.pushRuleState == PushRuleState.notify
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
              title: selectMode == SelectMode.share
                  ? Text(L10n.of(context).share)
                  : selectMode == SelectMode.select
                      ? Text(_selectedRoomIds.length.toString())
                      : DefaultAppBarSearchField(
                          searchController: searchController,
                          hintText: L10n.of(context).searchForAChat,
                          onChanged: (_) => setState(() => null),
                          suffix: Icon(Icons.search_outlined),
                        ),
            ),
            floatingActionButton:
                AdaptivePageLayout.of(context).columnMode(context)
                    ? null
                    : FloatingActionButton(
                        child: Icon(Icons.add_outlined),
                        onPressed: () => AdaptivePageLayout.of(context)
                            .pushNamedAndRemoveUntilIsFirst('/newprivatechat'),
                      ),
            body: Column(
              children: [
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
                              var rooms = List<Room>.from(
                                  Matrix.of(context).client.rooms);
                              rooms.removeWhere((Room room) =>
                                  room.lastEvent == null ||
                                  (searchMode &&
                                      !room.displayname.toLowerCase().contains(
                                          searchController.text.toLowerCase() ??
                                              '')));
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
                                controller: _scrollController,
                                itemCount: totalCount,
                                itemBuilder: (BuildContext context, int i) =>
                                    ChatListItem(
                                  rooms[i],
                                  selected:
                                      _selectedRoomIds.contains(rooms[i].id),
                                  onTap: selectMode == SelectMode.select
                                      ? () => _toggleSelection(rooms[i].id)
                                      : null,
                                  onLongPress: selectMode != SelectMode.share
                                      ? () => _toggleSelection(rooms[i].id)
                                      : null,
                                  activeChat: widget.activeChat == rooms[i].id,
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
              ],
            ),
          );
        });
  }
}
