// Package imports:
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'error_handler.dart';

Future<void> deleteRoom(String? roomID, Client client) async {
  if (roomID == null) {
    ErrorHandler.logError(
      m: "in deleteRoomAction with null pangeaClassRoomID",
      s: StackTrace.current,
    );
    return;
  }

  final Room? room = client.getRoomById(roomID);
  if (room == null) {
    ErrorHandler.logError(
      m: "failed to fetch room with roomID $roomID",
      s: StackTrace.current,
    );
    return;
  }

  try {
    await room.join();
  } catch (err) {
    ErrorHandler.logError(
      m: "failed to join room with roomID $roomID",
      s: StackTrace.current,
    );
    return;
  }

  List<User> members;
  try {
    members = await room.requestParticipants();
  } catch (err) {
    ErrorHandler.logError(
      m: "failed to fetch members for room with roomID $roomID",
      s: StackTrace.current,
    );
    return;
  }

  final List<User> otherAdmins = [];
  for (final User member in members) {
    final String memberID = member.id;
    final int memberPowerLevel = room.getPowerLevelByUserId(memberID);
    if (memberID == client.userID) continue;
    if (memberPowerLevel >= ClassDefaultValues.powerLevelOfAdmin) {
      otherAdmins.add(member);
      continue;
    }
    try {
      await room.kick(memberID);
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to kick user $memberID from room with id $roomID. Error: $err",
        s: StackTrace.current,
      );
      continue;
    }
  }

  if (otherAdmins.isNotEmpty && room.canSendEvent(EventTypes.RoomJoinRules)) {
    try {
      await client.setRoomStateWithKey(
        roomID,
        EventTypes.RoomJoinRules,
        "",
        {"join_rules": "invite"},
      );
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to update student create room permissions. error: $err, roomId: $roomID",
        s: StackTrace.current,
      );
    }
  }

  try {
    await room.leave();
  } catch (err) {
    ErrorHandler.logError(
      m: "Failed to leave room with id $roomID. Error: $err",
      s: StackTrace.current,
    );
  }
}
