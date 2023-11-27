// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/utils/error_handler.dart';

// Used in lock space. Handles case when child rooms return null from client.getRoomById
// Because the user hasn't joined them
Future<List<Room>> joinAllSpaceChats(Room space, Client client) async {
  final List<String> childrenIds =
      space.spaceChildren.map((x) => x.roomId!).toList();

  final List<Room> children = [];
  for (final String childId in childrenIds) {
    final Room? child = client.getRoomById(childId);
    if (child != null) {
      children.add(child);
    }
    // child may be null if the user is not in the room
    else {
      final Room? child = await tryGetRoomById(childId, client);
      if (child != null) {
        children.add(child);
      }
    }
  }
  return children;
}

Future<Room?> tryGetRoomById(String roomId, Client client) async {
  try {
    await client.joinRoomById(roomId);
  } catch (err) {
    // caused when chat has been archived
    debugPrint("Failed to join $roomId");
    return null;
  }
  await client.waitForRoomInSync(roomId);
  final Room? room = client.getRoomById(roomId);
  if (room != null) {
    return room;
  } else {
    ErrorHandler.logError(
      e: "Failed to fetch child room with id $roomId after joining",
      s: StackTrace.current,
    );
  }
  return null;
}
