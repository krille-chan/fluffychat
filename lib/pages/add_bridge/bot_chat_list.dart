import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/avatar.dart';

class BotChatListPage extends StatelessWidget {
  final List<String> botUserIds; // List of bot user IDs

  const BotChatListPage({super.key, required this.botUserIds});

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final rooms = client.rooms.where((room) {
      // Filter rooms to include only those with bot users
      final participants = room.getParticipants();
      return botUserIds
          .any((botId) => participants.any((user) => user.id == botId));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations avec les bots'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, i) {
          final room = rooms[i];
          return ListTile(
            leading: Avatar(
              mxContent: room.avatar,
              name: room.name,
            ),
            title: Text(room.name ?? 'Unknown Room'),
            subtitle: Text(room.lastEvent?.text ?? 'No messages'),
            onTap: () {
              // Handle tap on a bot conversation
              _onChatTap(room, context);
            },
          );
        },
      ),
    );
  }

  // Method to show popup menu
  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        PopupMenuItem(
          value: 'see_bots',
          child: Text('Voir les bots'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (value == 'see_bots') {
          _handleSeeBots(context);
        }
      }
    });
  }

  // Method to handle menu item selection
  void _handleSeeBots(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voir les bots selected'),
      ),
    );
  }

  // Method to handle chat tap
  void _onChatTap(Room room, BuildContext context) {
    // Implement your navigation to the chat page here
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
