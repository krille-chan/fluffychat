import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/new_group_dialog.dart';
import 'package:fluffychat/components/dialogs/new_private_chat_dialog.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/archive.dart';
import 'package:fluffychat/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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

  Future<bool> waitForFirstSync(BuildContext context) async {
    Client client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    sub ??= client.onSync.stream.listen((s) => setState(() => null));
    return true;
  }

  @override
  void initState() {
    searchController.addListener(
      () => setState(() => null),
    );
    super.initState();
  }

  @override
  void dispose() {
    sub?.cancel();
    searchController.removeListener(
      () => setState(() => null),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchMode
            ? TextField(
                autofocus: true,
                autocorrect: false,
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for a chat",
                ),
              )
            : Text(
                "FluffyChat",
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
                    const PopupMenuItem<String>(
                      value: "archive",
                      child: Text('Archive'),
                    ),
                    const PopupMenuItem<String>(
                      value: "settings",
                      child: Text('Settings'),
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
            label: 'Create new group',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext innerContext) => NewGroupDialog(),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            backgroundColor: Colors.green,
            label: 'New private chat',
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
                        ? "No rooms found..."
                        : "Start your first chat :-)"),
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
