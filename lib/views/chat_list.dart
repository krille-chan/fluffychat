import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/new_group_dialog.dart';
import 'package:fluffychat/components/dialogs/new_private_chat_dialog.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
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
          child: Icon(Icons.chat, size: 100, color: Color(0xFF5625BA)),
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
  StreamSubscription sub;

  Future<bool> waitForFirstSync(BuildContext context) async {
    Client client = Matrix.of(context).client;
    if (client.prevBatch?.isEmpty ?? true) {
      await client.onFirstSync.stream.first;
    }
    sub ??= client.onSync.stream.listen((s) => setState(() => null));
    return true;
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversations",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            onSelected: (String choice) {
              switch (choice) {
                case "settings":
                  Navigator.of(context).push(
                    AppRoute.defaultRoute(
                      context,
                      SettingsView(),
                    ),
                  );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        backgroundColor: Color(0xFF5625BA),
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
            child: Icon(Icons.chat_bubble_outline),
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
            List<Room> rooms = Matrix.of(context).client.rooms;
            return ListView.builder(
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
