import 'package:matrix/matrix.dart';

extension RoomFromPublicRoomsChunk on PublicRoomsChunk {
  Room createRoom(Client client) {
    final room = Room(
      id: roomId,
      client: client,
      prev_batch: '',
      membership: Membership.leave,
    );
    if (guestCanJoin) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.GuestAccess,
          content: {'guest_access': 'can_join'},
          senderId: '',
        ),
      );
    }
    if (worldReadable) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.HistoryVisibility,
          content: {'history_visibility': 'world_readable'},
          senderId: '',
        ),
      );
    }
    if (avatarUrl != null) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.RoomAvatar,
          content: {'url': avatarUrl.toString()},
          senderId: '',
        ),
      );
    }
    if (canonicalAlias != null) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.RoomCanonicalAlias,
          content: {'alias': canonicalAlias},
          senderId: '',
        ),
      );
    }
    if (joinRule != null) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.RoomJoinRules,
          content: {'join_rule': joinRule},
          senderId: '',
        ),
      );
    }
    room.summary.mInvitedMemberCount = numJoinedMembers;

    room.setState(
      StrippedStateEvent(
        stateKey: '',
        type: EventTypes.RoomCreate,
        content: {if (roomType != null) 'type': roomType},
        senderId: '',
      ),
    );

    if (name != null) {
      room.setState(
        StrippedStateEvent(
          stateKey: '',
          type: EventTypes.RoomName,
          content: {'name': name},
          senderId: '',
        ),
      );
    }
    return room;
  }
}
