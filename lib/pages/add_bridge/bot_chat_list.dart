import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/pages/chat_list/chat_list_item.dart';
import 'package:tawkie/widgets/matrix.dart';

class BotChatListPage extends StatelessWidget {
  final List<String> botUserIds;

  const BotChatListPage({super.key, required this.botUserIds});

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms = Matrix.of(context)
        .client
        .rooms
        .where((room) => botUserIds.contains(room.directChatMatrixID))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations avec les bots'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, i) {
          final room = rooms[i];
          return ChatListItem(rooms[i],
              key: Key('chat_list_item_${rooms[i].id}'), onTap: () {
            // Handle tap on a bot conversation
            _onChatTap(room, context);
          });
        },
      ),
    );
  }

  // Method to handle chat tap
  void _onChatTap(Room room, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }
}

// Dummy ChatPage class to navigate to when a chat is tapped
class ChatPage extends StatelessWidget {
  final Room room;

  const ChatPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name ?? 'Chat'),
      ),
      body: Center(
        child: Text('Chat with ${room.name}'),
      ),
    );
  }
}
