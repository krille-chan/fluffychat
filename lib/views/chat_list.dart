import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/list_items/public_room_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toast/toast.dart';
import 'package:uni_links/uni_links.dart';

import '../components/dialogs/simple_dialogs.dart';
import '../components/theme_switcher.dart';
import '../components/adaptive_page_layout.dart';
import '../components/list_items/chat_list_item.dart';
import '../components/matrix.dart';
import '../i18n/i18n.dart';
import '../utils/app_route.dart';
import '../utils/url_launcher.dart';
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
  bool searchMode = false;
  StreamSubscription sub;
  final TextEditingController searchController = TextEditingController();
  SelectMode selectMode = SelectMode.normal;
  Timer coolDown;
  PublicRoomsResponse publicRoomsResponse;
  bool loadingPublicRooms = false;
  String searchServer;

  Future<bool> waitForFirstSync(BuildContext context) async {
    Client client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    sub ??= client.onSync.stream
        .listen((s) => mounted ? setState(() => null) : null);
    return true;
  }

  @override
  void initState() {
    searchController.addListener(() {
      coolDown?.cancel();
      coolDown = Timer(Duration(seconds: 1), () async {
        setState(() => loadingPublicRooms = true);
        final newPublicRoomsResponse =
            await Matrix.of(context).tryRequestWithErrorToast(
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
                    roomId: searchController.text),
              );
            }
          }
        });
      });
      setState(() => null);
    });
    initUniLinks();
    super.initState();
  }

  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _onUniLinksub;

  Future<void> initUniLinks() async {
    if (kIsWeb) return;
    _onUniLinksub ??= getLinksStream().listen(
      (String initialLink) {
        try {
          if (initialLink?.isEmpty ?? true) return;
          if (initialLink.startsWith("https://matrix.to/#/")) {
            UrlLauncher(context, initialLink).openMatrixToUrl();
          }
        } on PlatformException {
          debugPrint("initUniLinks failed during platform exception");
        }
      },
      onError: (error) => Toast.show(
          I18n.of(context).oopsSomethingWentWrong + " " + error.toString(),
          context,
          duration: 5),
    );
  }

  @override
  void dispose() {
    sub?.cancel();
    searchController.removeListener(
      () => setState(() => null),
    );
    _intentDataStreamSubscription?.cancel();
    _onUniLinksub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).shareContent != null) {
      selectMode = SelectMode.share;
    } else if (selectMode == SelectMode.share) {
      setState(() => selectMode = SelectMode.normal);
    }
    return Scaffold(
      appBar: AppBar(
        title: searchMode
            ? TextField(
                autofocus: true,
                autocorrect: false,
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: I18n.of(context).searchForAChat,
                ),
              )
            : Text(
                selectMode == SelectMode.share
                    ? I18n.of(context).share
                    : I18n.of(context).fluffychat,
              ),
        leading: searchMode
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  publicRoomsResponse = null;
                  loadingPublicRooms = false;
                  searchMode = false;
                }),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: searchMode
            ? <Widget>[
                if (loadingPublicRooms)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.domain),
                  onPressed: () async {
                    final String newSearchServer = await SimpleDialogs(context)
                        .enterText(
                            titleText: I18n.of(context).changeTheServer,
                            labelText: I18n.of(context).changeTheServer,
                            hintText: Matrix.of(context).client.userID.domain,
                            prefixText: "https://");
                    if (newSearchServer?.isNotEmpty ?? false) {
                      searchServer = newSearchServer;
                    }
                  },
                )
              ]
            : <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() => searchMode = true),
                ),
                if (selectMode == SelectMode.share)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Matrix.of(context).shareContent = null;
                      setState(() => selectMode = SelectMode.normal);
                    },
                  ),
                if (selectMode == SelectMode.normal)
                  PopupMenuButton(
                    onSelected: (String choice) {
                      switch (choice) {
                        case "settings":
                          Navigator.of(context).pushAndRemoveUntil(
                            AppRoute.defaultRoute(
                              context,
                              SettingsView(),
                            ),
                            (r) => r.isFirst,
                          );
                          break;
                        case "archive":
                          Navigator.of(context).pushAndRemoveUntil(
                            AppRoute.defaultRoute(
                              context,
                              Archive(),
                            ),
                            (r) => r.isFirst,
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "archive",
                        child: Text(I18n.of(context).archive),
                      ),
                      PopupMenuItem<String>(
                        value: "settings",
                        child: Text(I18n.of(context).settings),
                      ),
                    ],
                  ),
              ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        overlayColor: blackWhiteColor(context),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.people_outline),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: I18n.of(context).createNewGroup,
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                AppRoute.defaultRoute(context, NewGroupView()),
                (r) => r.isFirst),
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: I18n.of(context).newPrivateChat,
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                AppRoute.defaultRoute(context, NewPrivateChatView()),
                (r) => r.isFirst),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: waitForFirstSync(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Room> rooms = List<Room>.from(Matrix.of(context).client.rooms);
            rooms.removeWhere((Room room) =>
                searchMode &&
                !room.displayname
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase() ?? ""));
            if (rooms.isEmpty && (!searchMode || publicRoomsResponse == null)) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      searchMode ? Icons.search : Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.grey,
                    ),
                    Text(searchMode
                        ? I18n.of(context).noRoomsFound
                        : I18n.of(context).startYourFirstChat),
                  ],
                ),
              );
            }
            final int publicRoomsCount =
                (publicRoomsResponse?.publicRooms?.length ?? 0);
            final int totalCount = rooms.length + publicRoomsCount;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int i) =>
                  i == totalCount - publicRoomsCount - 1
                      ? Material(
                          elevation: 2,
                          child: ListTile(
                            title: Text("Public Rooms:"),
                          ),
                        )
                      : Divider(indent: 70, height: 1),
              itemCount: totalCount,
              itemBuilder: (BuildContext context, int i) => i < rooms.length
                  ? ChatListItem(
                      rooms[i],
                      activeChat: widget.activeChat == rooms[i].id,
                    )
                  : PublicRoomListItem(
                      publicRoomsResponse.publicRooms[i - rooms.length]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
