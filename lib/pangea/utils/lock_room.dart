import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';

Future<void> lockRoom(Room room, Client client) async {
  room.isSpace ? await lockSpace(room, client) : await lockChat(room, client);
}

Future<void> unlockRoom(Room room, Client client) async {
  room.isSpace
      ? await unlockSpace(room, client)
      : await unlockChat(room, client);
}

Future<void> lockChat(Room room, Client client) async {
  if (!room.canChangePowerLevel) {
    return;
  }
  final Map<String, dynamic> powerLevelsContent = Map<String, dynamic>.from(
    room.getState(EventTypes.RoomPowerLevels)!.content,
  );

  powerLevelsContent['events_default'] = 100;
  if (!powerLevelsContent.containsKey('events')) {
    powerLevelsContent['events'] = Map<String, dynamic>.from({});
  }
  powerLevelsContent['events'][EventTypes.SpaceChild] = 100;

  await room.client.setRoomStateWithKey(
    room.id,
    EventTypes.RoomPowerLevels,
    '',
    powerLevelsContent,
  );
}

Future<void> unlockChat(Room room, Client client) async {
  if (!room.canChangePowerLevel) {
    return;
  }
  final Map<String, dynamic> powerLevelsContent = Map<String, dynamic>.from(
    room.getState(EventTypes.RoomPowerLevels)!.content,
  );

  powerLevelsContent['events_default'] = 0;
  powerLevelsContent['events'][EventTypes.SpaceChild] = 0;

  await room.client.setRoomStateWithKey(
    room.id,
    EventTypes.RoomPowerLevels,
    '',
    powerLevelsContent,
  );
}

Future<void> lockSpace(Room space, Client client) async {
  for (final spaceChild in space.spaceChildren) {
    if (spaceChild.roomId == null) continue;
    Room? child = client.getRoomById(spaceChild.roomId!);
    if (child == null) {
      try {
        await client.joinRoom(spaceChild.roomId!);
        await client.waitForRoomInSync(spaceChild.roomId!, join: true);
        child = client.getRoomById(spaceChild.roomId!);
      } catch (err) {
        await client.leaveRoom(spaceChild.roomId!);
        continue;
      }
    }
    if (child == null || child.isArchived || child.isAnalyticsRoom) continue;
    child.isSpace
        ? await lockSpace(child, client)
        : await lockChat(child, client);
  }
  await lockChat(space, client);
}

Future<void> unlockSpace(Room space, Client client) async {
  for (final spaceChild in space.spaceChildren) {
    if (spaceChild.roomId == null) continue;
    final Room? child = client.getRoomById(spaceChild.roomId!);
    if (child == null || child.isArchived || child.isAnalyticsRoom) continue;
    child.isSpace
        ? await unlockSpace(child, client)
        : await unlockChat(child, client);
  }
  await unlockChat(space, client);
}
