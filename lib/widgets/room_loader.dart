import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/room_from_public_rooms_chunk.dart';
import 'package:fluffychat/widgets/matrix.dart';

class RoomLoader extends StatelessWidget {
  final String roomId;
  final PublicRoomsChunk? chunk;
  final Widget Function(BuildContext context, Room room) builder;

  const RoomLoader({
    required this.roomId,
    required this.builder,
    this.chunk,
    super.key,
  });

  static final Map<String, Future<Room>> _roomLoaders = {};

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final existingRoom = client.getRoomById(roomId);

    if (existingRoom != null) {
      return builder(context, existingRoom);
    }

    final chunk = this.chunk;
    if (chunk != null) {
      return builder(context, chunk.createRoom(client));
    }

    final roomLoader =
        _roomLoaders[roomId] ??= client.getRoomState(roomId).then((states) {
      final room = Room(
        id: roomId,
        client: client,
        prev_batch: '',
        membership: Membership.leave,
      );
      states.forEach(room.setState);
      return room;
    });

    return FutureBuilder(
      key: ValueKey(roomId),
      future: roomLoader,
      builder: (context, snapshot) {
        final room = snapshot.data;
        if (room != null) return builder(context, room);
        final error = snapshot.error;
        if (error != null) {
          return Scaffold(
            appBar: AppBar(
              leading: Center(
                child: BackButton(onPressed: Navigator.of(context).pop),
              ),
            ),
            body: Center(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off_outlined),
                  Text(error.toLocalizedString(context)),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: Center(
              child: BackButton(onPressed: Navigator.of(context).pop),
            ),
          ),
          body: const Center(
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
