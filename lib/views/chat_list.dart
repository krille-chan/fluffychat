import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/new_group_dialog.dart';
import 'package:fluffychat/components/dialogs/new_private_chat_dialog.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/views/archive.dart';
import 'package:fluffychat/views/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

enum SelectMode { normal, multi_select, share }

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
    searchController.addListener(
      () => setState(() => null),
    );
    if (kIsWeb) {
      getSharedData();
    }
    super.initState();
  }

  StreamSubscription _intentDataStreamSubscription;

  void processSharedText(String text) {
    if (text?.isEmpty ?? true) return;
    if (text.startsWith("https://matrix.to/#/")) {
      UrlLauncher(context, text).openMatrixToUrl();
    } else {
      setState(() => Matrix.of(context).shareContent = {
            "msgtype": "m.text",
            "body": text,
          });
    }
  }

  void getSharedData() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen(processSharedText, onError: (err) {});
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then(processSharedText);
  }

  @override
  void dispose() {
    sub?.cancel();
    searchController.removeListener(
      () => setState(() => null),
    );
    _intentDataStreamSubscription?.cancel();
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
                onPressed: () => setState(() => searchMode = false),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: searchMode
            ? null
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
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.people_outline),
            backgroundColor: Colors.blue,
            label: I18n.of(context).createNewGroup,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext innerContext) => NewGroupDialog(),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            backgroundColor: Colors.green,
            label: I18n.of(context).newPrivateChat,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext innerContext) => NewPrivateChatDialog()),
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
            if (rooms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      searchMode ? Icons.search : Icons.add,
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
            return ListView.separated(
              separatorBuilder: (BuildContext context, int i) =>
                  Divider(indent: 70, height: 1),
              itemCount: rooms.length,
              itemBuilder: (BuildContext context, int i) => ChatListItem(
                rooms[i],
                activeChat: widget.activeChat == rooms[i].id,
              ),
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
