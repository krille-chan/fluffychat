import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/matrix_api.dart';
import 'package:fluffychat/components/connection_status_header.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/list_items/public_room_list_item.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../components/adaptive_page_layout.dart';
import '../components/list_items/chat_list_item.dart';
import '../components/matrix.dart';
import '../utils/app_route.dart';
import '../utils/matrix_file_extension.dart';
import '../utils/url_launcher.dart';
import 'archive.dart';
import 'homeserver_picker.dart';
import 'new_group.dart';
import 'new_private_chat.dart';
import 'settings.dart';

enum SelectMode { normal, share, select }

class ChatListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.FIRST,
      firstScaffold: ChatList(),
      secondScaffold: Scaffold(
        body: Center(
          child: Image.asset('assets/logo.png', width: 100, height: 100),
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  final String activeChat;

  const ChatList({this.activeChat, Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool get searchMode => searchController.text?.isNotEmpty ?? false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer coolDown;
  PublicRoomsResponse publicRoomsResponse;
  bool loadingPublicRooms = false;
  String searchServer;
  final _selectedRoomIds = <String>{};

  final ScrollController _scrollController = ScrollController();

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

  bool _scrolledToTop = true;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels > 0 && _scrolledToTop) {
        setState(() => _scrolledToTop = false);
      } else if (_scrollController.position.pixels == 0 && !_scrolledToTop) {
        setState(() => _scrolledToTop = true);
      }
    });
    searchController.addListener(() {
      coolDown?.cancel();
      if (searchController.text.isEmpty) {
        setState(() {
          loadingPublicRooms = false;
          publicRoomsResponse = null;
        });
        return;
      }
      coolDown = Timer(Duration(seconds: 1), () async {
        setState(() => loadingPublicRooms = true);
        final newPublicRoomsResponse =
            await SimpleDialogs(context).tryRequestWithErrorToast(
          Matrix.of(context).client.searchPublicRooms(
                limit: 30,
                includeAllNetworks: true,
                genericSearchTerm: searchController.text,
                server: searchServer,
              ),
        );
        setState(() {
          loadingPublicRooms = false;
          if (newPublicRoomsResponse != false) {
            publicRoomsResponse = newPublicRoomsResponse;
            if (searchController.text.isNotEmpty &&
                searchController.text.isValidMatrixId &&
                searchController.text.sigil == '#') {
              publicRoomsResponse.chunk.add(
                PublicRoom.fromJson({
                  'aliases': [searchController.text],
                  'name': searchController.text,
                  'room_id': searchController.text,
                }),
              );
            }
          }
        });
      });
      setState(() => null);
    });
    _initReceiveSharingIntent();
    super.initState();
  }

  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
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
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
    if (text.startsWith('https://matrix.to/#/')) {
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

  void _drawerTapAction(Widget view) {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
      AppRoute.defaultRoute(
        context,
        view,
      ),
      (r) => r.isFirst,
    );
  }

  void _setStatus(BuildContext context) async {
    Navigator.of(context).pop();
    final statusMsg = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).setStatus,
      labelText: L10n.of(context).setStatus,
      hintText: L10n.of(context).statusExampleMessage,
      multiLine: true,
    );
    if (statusMsg?.isEmpty ?? true) return;
    final client = Matrix.of(context).client;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      client.sendPresence(
        client.userID,
        PresenceType.online,
        statusMsg: statusMsg,
      ),
    );
    return;
  }

  @override
  void dispose() {
    searchController.removeListener(
      () => setState(() => null),
    );
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleFavouriteRoom(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
    return SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.setFavourite(!room.isFavourite),
    );
  }

  Future<void> _toggleMuted(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(_selectedRoomIds.single);
    return SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.setPushRuleState(room.pushRuleState == PushRuleState.notify
          ? PushRuleState.mentions_only
          : PushRuleState.notify),
    );
  }

  Future<void> _archiveAction(BuildContext context) async {
    final confirmed = await SimpleDialogs(context).askConfirmation();
    if (!confirmed) return;
    await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(_archiveSelectedRooms(context));
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
    return StreamBuilder<LoginState>(
        stream: Matrix.of(context).client.onLoginStateChanged.stream,
        builder: (context, snapshot) {
          if (snapshot.data == LoginState.loggedOut) {
            Timer(Duration(seconds: 1), () {
              Matrix.of(context).clean();
              Navigator.of(context).pushAndRemoveUntil(
                  AppRoute.defaultRoute(context, HomeserverPicker()),
                  (r) => false);
            });
          }
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
                return Scaffold(
                  drawer: selectMode != SelectMode.normal
                      ? null
                      : Drawer(
                          child: SafeArea(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text(L10n.of(context).setStatus),
                                  onTap: () => _setStatus(context),
                                ),
                                Divider(height: 1),
                                ListTile(
                                  leading: Icon(Icons.people_outline),
                                  title: Text(L10n.of(context).createNewGroup),
                                  onTap: () => _drawerTapAction(NewGroupView()),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person_add),
                                  title: Text(L10n.of(context).newPrivateChat),
                                  onTap: () =>
                                      _drawerTapAction(NewPrivateChatView()),
                                ),
                                Divider(height: 1),
                                ListTile(
                                  leading: Icon(Icons.archive),
                                  title: Text(L10n.of(context).archive),
                                  onTap: () => _drawerTapAction(
                                    Archive(),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.settings),
                                  title: Text(L10n.of(context).settings),
                                  onTap: () => _drawerTapAction(
                                    SettingsView(),
                                  ),
                                ),
                                Divider(height: 1),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text(L10n.of(context).inviteContact),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    FluffyShare.share(
                                        L10n.of(context).inviteText(
                                            Matrix.of(context).client.userID,
                                            'https://matrix.to/#/${Matrix.of(context).client.userID}'),
                                        context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                  appBar: AppBar(
                    centerTitle: false,
                    elevation: _scrolledToTop ? 0 : null,
                    leading: selectMode == SelectMode.share
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () =>
                                Matrix.of(context).shareContent = null,
                          )
                        : selectMode == SelectMode.select
                            ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    setState(_selectedRoomIds.clear),
                              )
                            : null,
                    titleSpacing: 0,
                    actions: selectMode != SelectMode.select
                        ? null
                        : [
                            if (_selectedRoomIds.length == 1)
                              IconButton(
                                icon: Icon(Icons.favorite_border_outlined),
                                onPressed: () => _toggleFavouriteRoom(context),
                              ),
                            if (_selectedRoomIds.length == 1)
                              IconButton(
                                icon: Icon(Icons.notifications_none),
                                onPressed: () => _toggleMuted(context),
                              ),
                            IconButton(
                              icon: Icon(Icons.archive),
                              onPressed: () => _archiveAction(context),
                            ),
                          ],
                    title: selectMode == SelectMode.share
                        ? Text(L10n.of(context).share)
                        : selectMode == SelectMode.select
                            ? Text(_selectedRoomIds.length.toString())
                            : Container(
                                height: 40,
                                padding: EdgeInsets.only(right: 8),
                                child: Material(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  borderRadius: BorderRadius.circular(32),
                                  child: TextField(
                                    autocorrect: false,
                                    controller: searchController,
                                    focusNode: _searchFocusNode,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 8,
                                        left: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      hintText: L10n.of(context).searchForAChat,
                                      suffixIcon: searchMode
                                          ? IconButton(
                                              icon: Icon(Icons.backspace),
                                              onPressed: () => setState(() {
                                                searchController.clear();
                                                _searchFocusNode.unfocus();
                                              }),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                  floatingActionButton: AdaptivePageLayout.columnMode(context)
                      ? null
                      : FloatingActionButton(
                          child: Icon(Icons.add),
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.of(context)
                              .pushAndRemoveUntil(
                                  AppRoute.defaultRoute(
                                      context, NewPrivateChatView()),
                                  (r) => r.isFirst),
                        ),
                  body: Column(
                    children: [
                      ConnectionStatusHeader(),
                      Expanded(
                        child: StreamBuilder(
                            stream:
                                Matrix.of(context).client.onSync.stream.where(
                                      (s) =>
                                          s.hasRoomUpdate ||
                                          s.accountData
                                              .where((a) =>
                                                  a.type ==
                                                  MatrixState.userStatusesType)
                                              .isNotEmpty,
                                    ),
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
                                            !room.displayname
                                                .toLowerCase()
                                                .contains(searchController.text
                                                        .toLowerCase() ??
                                                    '')));
                                    if (rooms.isEmpty &&
                                        (!searchMode ||
                                            publicRoomsResponse == null)) {
                                      return Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              searchMode
                                                  ? Icons.search
                                                  : Icons.chat_bubble_outline,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                            Text(searchMode
                                                ? L10n.of(context).noRoomsFound
                                                : L10n.of(context)
                                                    .startYourFirstChat),
                                          ],
                                        ),
                                      );
                                    }
                                    final publicRoomsCount =
                                        (publicRoomsResponse?.chunk?.length ??
                                            0);
                                    final totalCount =
                                        rooms.length + publicRoomsCount;
                                    return ListView.separated(
                                      controller: _scrollController,
                                      separatorBuilder: (BuildContext context,
                                              int i) =>
                                          i == totalCount - publicRoomsCount
                                              ? ListTile(
                                                  title: Text(
                                                    L10n.of(context)
                                                            .publicRooms +
                                                        ':',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                      itemCount: totalCount,
                                      itemBuilder: (BuildContext context,
                                              int i) =>
                                          i < rooms.length
                                              ? ChatListItem(
                                                  rooms[i],
                                                  selected: _selectedRoomIds
                                                      .contains(rooms[i].id),
                                                  onTap: selectMode ==
                                                          SelectMode.select
                                                      ? () => _toggleSelection(
                                                          rooms[i].id)
                                                      : null,
                                                  onLongPress: selectMode !=
                                                          SelectMode.share
                                                      ? () => _toggleSelection(
                                                          rooms[i].id)
                                                      : null,
                                                  activeChat:
                                                      widget.activeChat ==
                                                          rooms[i].id,
                                                )
                                              : PublicRoomListItem(
                                                  publicRoomsResponse
                                                      .chunk[i - rooms.length],
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
        });
  }
}
