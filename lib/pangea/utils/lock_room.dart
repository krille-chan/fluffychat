import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/join_all_space_chats.dart';
import 'package:matrix/matrix.dart';

Future<void> unlockChat(Room room, Client client) async {
  final Map<String, dynamic> powerLevelsContent = Map<String, dynamic>.from(
    room.getState(EventTypes.RoomPowerLevels)!.content,
  );

  powerLevelsContent['events_default'] = 0;
  powerLevelsContent['events'][EventTypes.spaceChild] = 0;

  await room.client.setRoomStateWithKey(
    room.id,
    EventTypes.RoomPowerLevels,
    '',
    powerLevelsContent,
  );
}

Future<void> lockChat(Room room, Client client) async {
  final Map<String, dynamic> powerLevelsContent = Map<String, dynamic>.from(
    room.getState(EventTypes.RoomPowerLevels)!.content,
  );
  powerLevelsContent['events_default'] = 100;
  powerLevelsContent['events'][EventTypes.spaceChild] = 100;

  await room.client.setRoomStateWithKey(
    room.id,
    EventTypes.RoomPowerLevels,
    '',
    powerLevelsContent,
  );
}

Future<void> lockSpace(Room space, Client client) async {
  final List<Room> children = await joinAllSpaceChats(space, client);
  for (final Room child in children) {
    await lockChat(child, client);
  }
  await lockChat(space, client);
}

Future<void> unlockSpace(Room space, Client client) async {
  final List<Room?> children = space.spaceChildren
      .map((child) => client.getRoomById(child.roomId!))
      .toList();
  for (final Room? child in children) {
    if (child != null) {
      await unlockChat(child, client);
    }
  }
  await unlockChat(space, client);
}

Future<void> toggleLockRoom(Room? room, Client client) async {
  if (room == null || !room.isRoomAdmin) return;
  if (!room.isSpace) {
    room.locked ? await unlockChat(room, client) : await lockChat(room, client);
    return;
  }
  room.locked ? await unlockSpace(room, client) : await lockSpace(room, client);
}
