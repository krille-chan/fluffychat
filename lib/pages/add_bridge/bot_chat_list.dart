import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/pages/chat/chat.dart';
import 'package:tawkie/pages/chat_list/chat_list_item.dart';
import 'package:tawkie/widgets/matrix.dart';

class BotChatListPage extends StatefulWidget {
  final List<String> botUserIds;

  const BotChatListPage({super.key, required this.botUserIds});

  @override
  State<BotChatListPage> createState() => _BotChatListPageState();
}

class _BotChatListPageState extends State<BotChatListPage> {
  Future<List<Room>>? _roomsFuture;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    setState(() {
      _roomsFuture = Future.delayed(
        Duration.zero,
        () => Matrix.of(context)
            .client
            .rooms
            .where(
                (room) => widget.botUserIds.contains(room.directChatMatrixID))
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.chatBotRoomsTitle),
      ),
      body: FutureBuilder<List<Room>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${L10n.of(context)!.err_} ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(L10n.of(context)!.chatBotRoomsNotFound));
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, i) {
                final room = rooms[i];
                return ChatListItem(rooms[i],
                    key: Key('chat_list_item_${rooms[i].id}'), onTap: () {
                  // Handle tap on a bot conversation
                  openChatRoom(room, context);
                }, onLongPress: (context) {
                  // Handle long press to delete the room
                  _onChatLongPress(room, context);
                });
              },
            );
          }
        },
      ),
    );
  }

  // Method to handle chat tap
  void openChatRoom(Room room, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatPage(
                roomId: room.id,
              )),
    );
  }

  // Method to handle chat long press
  void _onChatLongPress(Room room, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(L10n.of(context)!.leaveTheConvDesc),
          actions: <Widget>[
            TextButton(
              child: Text(L10n.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(L10n.of(context)!.leave),
              onPressed: () async {
                Navigator.of(context).pop();
                await showFutureLoadingDialog(
                    context: context, future: () => _leaveRoom(room));
              },
            ),
          ],
        );
      },
    );
  }

  // Method to leave the room
  Future<void> _leaveRoom(Room room) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await room.leave();
      await Future.delayed(
          const Duration(seconds: 1)); // Delay to ensure the room is left
      // Reload rooms after leaving one
      _loadRooms();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.leaveTheConvSuccess),
        ),
      );
    } catch (e) {
      // Log the error
      if (kDebugMode) {
        print('Error leaving the room: $e');
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.tryAgain),
        ),
      );
    }
  }
}
