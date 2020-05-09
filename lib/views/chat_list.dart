import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/list_items/presence_list_item.dart';
import 'package:fluffychat/components/list_items/public_room_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';

import '../components/theme_switcher.dart';
import '../components/adaptive_page_layout.dart';
import '../components/list_items/chat_list_item.dart';
import '../components/matrix.dart';
import '../l10n/l10n.dart';
import '../utils/app_route.dart';
import '../utils/url_launcher.dart';
import '../utils/client_presence_extension.dart';
import 'archive.dart';
import 'new_group.dart';
import 'new_private_chat.dart';
import 'settings.dart';

enum SelectMode { normal, share }

class ChatListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.FIRST,
      firstScaffold: ChatList(),
      secondScaffold: Scaffold(
        body: Center(
          child: Image.asset("assets/logo.png", width: 100, height: 100),
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
  Timer coolDown;
  PublicRoomsResponse publicRoomsResponse;
  bool loadingPublicRooms = false;
  String searchServer;

  Future<void> waitForFirstSync(BuildContext context) async {
    Client client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    return true;
  }

  @override
  void initState() {
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
          Matrix.of(context).client.requestPublicRooms(
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
                searchController.text.sigil == "#") {
              publicRoomsResponse.publicRooms.add(
                PublicRoomEntry(
                  aliases: [searchController.text],
                  name: searchController.text,
                  roomId: searchController.text,
                  client: Matrix.of(context).client,
                ),
              );
            }
          }
        });
      });
      setState(() => null);
    });
    _initReceiveSharingINtent();
    super.initState();
  }

  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
    final File file = File(files.first.path);

    Matrix.of(context).shareContent = {
      "msgtype": "chat.fluffy.shared_file",
      "file": MatrixFile(
        bytes: file.readAsBytesSync(),
        path: file.path,
      ),
    };
  }

  void _processIncomingSharedText(String text) {
    if (text == null) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
    if (text.startsWith("https://matrix.to/#/")) {
      UrlLauncher(context, text).openMatrixToUrl();
      return;
    }
    Matrix.of(context).shareContent = {
      "msgtype": "m.text",
      "body": text,
    };
  }

  void _initReceiveSharingINtent() {
    if (kIsWeb) return;

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
    final status = await SimpleDialogs(context).enterText(
      multiLine: true,
      titleText: L10n.of(context).setStatus,
      labelText: L10n.of(context).setStatus,
      hintText: L10n.of(context).statusExampleMessage,
    );
    if (status?.isEmpty ?? true) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.jsonRequest(
        type: HTTPType.PUT,
        action:
            '/client/r0/presence/${Matrix.of(context).client.userID}/status',
        data: {
          "presence": "online",
          "status_msg": status,
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Matrix.of(context).onShareContentChanged.stream,
        builder: (context, snapshot) {
          final selectMode = Matrix.of(context).shareContent == null
              ? SelectMode.normal
              : SelectMode.share;
          return Scaffold(
            drawer: selectMode == SelectMode.share
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
                            onTap: () => _drawerTapAction(NewPrivateChatView()),
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
                              Share.share(L10n.of(context).inviteText(
                                  Matrix.of(context).client.userID,
                                  "https://matrix.to/#/${Matrix.of(context).client.userID}"));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            appBar: AppBar(
              leading: selectMode != SelectMode.share
                  ? null
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Matrix.of(context).shareContent = null,
                    ),
              titleSpacing: 0,
              title: selectMode == SelectMode.share
                  ? Text(L10n.of(context).share)
                  : Container(
                      padding: EdgeInsets.all(8),
                      height: 42,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        autocorrect: false,
                        controller: searchController,
                        decoration: InputDecoration(
                          suffixIcon: loadingPublicRooms
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Icon(Icons.search),
                          contentPadding: EdgeInsets.all(9),
                          border: InputBorder.none,
                          hintText: L10n.of(context).searchForAChat,
                        ),
                      ),
                    ),
            ),
            floatingActionButton: (AdaptivePageLayout.columnMode(context) ||
                    selectMode == SelectMode.share)
                ? null
                : SpeedDial(
                    child: Icon(Icons.add),
                    overlayColor: blackWhiteColor(context),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.people_outline),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        label: L10n.of(context).createNewGroup,
                        labelStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black),
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            AppRoute.defaultRoute(context, NewGroupView()),
                            (r) => r.isFirst),
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.person_add),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        label: L10n.of(context).newPrivateChat,
                        labelStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black),
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            AppRoute.defaultRoute(
                                context, NewPrivateChatView()),
                            (r) => r.isFirst),
                      ),
                    ],
                  ),
            body: StreamBuilder(
                stream: Matrix.of(context).client.onSync.stream,
                builder: (context, snapshot) {
                  return FutureBuilder<void>(
                    future: waitForFirstSync(context),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        List<Room> rooms =
                            List<Room>.from(Matrix.of(context).client.rooms);
                        rooms.removeWhere((Room room) =>
                            searchMode &&
                            !room.displayname.toLowerCase().contains(
                                searchController.text.toLowerCase() ?? ""));
                        if (rooms.isEmpty &&
                            (!searchMode || publicRoomsResponse == null)) {
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
                                    : L10n.of(context).startYourFirstChat),
                              ],
                            ),
                          );
                        }
                        final int publicRoomsCount =
                            (publicRoomsResponse?.publicRooms?.length ?? 0);
                        final int totalCount = rooms.length + publicRoomsCount;
                        return ListView.separated(
                            separatorBuilder: (BuildContext context, int i) =>
                                i == totalCount - publicRoomsCount
                                    ? Material(
                                        elevation: 2,
                                        child: ListTile(
                                          title: Text(
                                              L10n.of(context).publicRooms),
                                        ),
                                      )
                                    : Container(),
                            itemCount: totalCount + 1,
                            itemBuilder: (BuildContext context, int i) {
                              if (i == 0) {
                                return Matrix.of(context)
                                        .client
                                        .statusList
                                        .isEmpty
                                    ? Container()
                                    : PreferredSize(
                                        preferredSize: Size.fromHeight(89),
                                        child: Container(
                                          height: 81,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Matrix.of(context)
                                                .client
                                                .statusList
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, int i) =>
                                                    PresenceListItem(
                                                        Matrix.of(context)
                                                            .client
                                                            .statusList[i]),
                                          ),
                                        ),
                                      );
                              }
                              i--;
                              return i < rooms.length
                                  ? ChatListItem(
                                      rooms[i],
                                      activeChat:
                                          widget.activeChat == rooms[i].id,
                                    )
                                  : PublicRoomListItem(publicRoomsResponse
                                      .publicRooms[i - rooms.length]);
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }),
          );
        });
  }
}
