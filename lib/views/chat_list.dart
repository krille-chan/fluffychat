import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/connection_status_header.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/horizontal_stories_list.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../components/matrix.dart';
import '../utils/matrix_file_extension.dart';
import '../utils/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum SelectMode { normal, share, select }

class ChatList extends StatefulWidget {
  final String activeChat;

  const ChatList({this.activeChat, Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  AppBar appBar;

  bool get searchMode => searchController.text?.isNotEmpty ?? false;
  final TextEditingController searchController = TextEditingController();
  final _selectedRoomIds = <String>{};

  final ScrollController _scrollController = ScrollController();

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
  void initState() {
    _initReceiveSharingIntent();
    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    super.dispose();
  }

  void _onPopupMenuButtonSelect(ChatListPopupMenuItemActions action) {
    switch (action) {
      case ChatListPopupMenuItemActions.createGroup:
        AdaptivePageLayout.of(context).pushNamed('/newgroup');
        break;
      case ChatListPopupMenuItemActions.discover:
        AdaptivePageLayout.of(context).pushNamed('/discover');
        break;
      case ChatListPopupMenuItemActions.setStatus:
        _setStatus();
        break;
      case ChatListPopupMenuItemActions.inviteContact:
        FluffyShare.share(
            L10n.of(context).inviteText(Matrix.of(context).client.userID,
                'https://matrix.to/#/${Matrix.of(context).client.userID}'),
            context);
        break;
      case ChatListPopupMenuItemActions.settings:
        AdaptivePageLayout.of(context).pushNamed('/settings');
        break;
    }
  }

  void _setStatus() async {
    final input = await showTextInputDialog(
        context: context,
        title: L10n.of(context).setStatus,
        textFields: [
          DialogTextField(
            hintText: L10n.of(context).statusExampleMessage,
          ),
        ]);
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.sendPresence(
            Matrix.of(context).client.userID,
            PresenceType.online,
            statusMsg: input.single,
          ),
    );
  }

  void _toggleSelection(String roomId) {
    setState(() => _selectedRoomIds.contains(roomId)
        ? _selectedRoomIds.remove(roomId)
        : _selectedRoomIds.add(roomId));
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

  final GlobalKey<DefaultAppBarSearchFieldState> _searchFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Matrix.of(context).onShareContentChanged.stream,
        builder: (_, __) {
          final selectMode = Matrix.of(context).shareContent != null
              ? SelectMode.share
              : _selectedRoomIds.isEmpty
                  ? SelectMode.normal
                  : SelectMode.select;
          return Scaffold(
            appBar: appBar ??
                AppBar(
                  leading: selectMode == SelectMode.normal
                      ? null
                      : IconButton(
                          icon: Icon(Icons.close_outlined),
                          onPressed: () => selectMode == SelectMode.share
                              ? setState(
                                  () => Matrix.of(context).shareContent = null)
                              : setState(() => _selectedRoomIds.clear()),
                        ),
                  centerTitle: false,
                  actions: selectMode == SelectMode.share
                      ? null
                      : selectMode == SelectMode.select
                          ? [
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
                                  onPressed: () =>
                                      _toggleFavouriteRoom(context),
                                ),
                              if (_selectedRoomIds.length == 1)
                                IconButton(
                                  icon: Icon(Matrix.of(context)
                                              .client
                                              .getRoomById(
                                                  _selectedRoomIds.single)
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
                            ]
                          : [
                              IconButton(
                                icon: Icon(Icons.search_outlined),
                                onPressed: () async {
                                  await _scrollController.animateTo(
                                    _scrollController.position.minScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease,
                                  );
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => _searchFieldKey.currentState
                                        .requestFocus(),
                                  );
                                },
                              ),
                              PopupMenuButton<ChatListPopupMenuItemActions>(
                                onSelected: _onPopupMenuButtonSelect,
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: ChatListPopupMenuItemActions
                                        .createGroup,
                                    child: Row(
                                      children: [
                                        Icon(Icons.group_add_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).createNewGroup),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value:
                                        ChatListPopupMenuItemActions.discover,
                                    child: Row(
                                      children: [
                                        Icon(Icons.group_work_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).discoverGroups),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value:
                                        ChatListPopupMenuItemActions.setStatus,
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).setStatus),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: ChatListPopupMenuItemActions
                                        .inviteContact,
                                    child: Row(
                                      children: [
                                        Icon(Icons.share_outlined),
                                        SizedBox(width: 12),
                                        Text(L10n.of(context).inviteContact),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value:
                                        ChatListPopupMenuItemActions.settings,
                                    child: Row(
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
                              _selectedRoomIds.length.toString())
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
                        future: waitForFirstSync(context),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            var rooms = List<Room>.from(
                                Matrix.of(context).client.rooms);
                            rooms.removeWhere((room) =>
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
                                  Center(
                                    child: Text(
                                      searchMode
                                          ? L10n.of(context).noRoomsFound
                                          : L10n.of(context).startYourFirstChat,
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
                            final totalCount = rooms.length;
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: totalCount + 1,
                              itemBuilder: (BuildContext context, int i) => i ==
                                      0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(12),
                                          child: DefaultAppBarSearchField(
                                            key: _searchFieldKey,
                                            hintText: L10n.of(context).search,
                                            prefixIcon:
                                                Icon(Icons.search_outlined),
                                            searchController: searchController,
                                            onChanged: (_) =>
                                                setState(() => null),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                        if (selectMode == SelectMode.normal)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: HorizontalStoriesList(
                                              searchQuery:
                                                  searchController.text,
                                            ),
                                          ),
                                      ],
                                    )
                                  : ChatListItem(
                                      rooms[i - 1],
                                      selected: _selectedRoomIds
                                          .contains(rooms[i - 1].id),
                                      onTap: selectMode == SelectMode.select
                                          ? () =>
                                              _toggleSelection(rooms[i - 1].id)
                                          : null,
                                      onLongPress: () =>
                                          _toggleSelection(rooms[i - 1].id),
                                      activeChat:
                                          widget.activeChat == rooms[i - 1].id,
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
            ]),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add_outlined),
              onPressed: () => AdaptivePageLayout.of(context)
                  .pushNamedAndRemoveUntilIsFirst('/newprivatechat'),
            ),
          );
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
