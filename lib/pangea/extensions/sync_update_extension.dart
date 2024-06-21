import 'package:matrix/matrix.dart';

extension MembershipUpdate on SyncUpdate {
  bool isMembershipUpdate(String userId) {
    return isMembershipUpdateByType(Membership.join, userId) ||
        isMembershipUpdateByType(Membership.leave, userId) ||
        isMembershipUpdateByType(Membership.invite, userId);
  }

  bool isMembershipUpdateByType(Membership type, String userId) {
    final List<SyncRoomUpdate>? updates = getRoomUpdates(type);
    if (updates?.isEmpty ?? true) {
      return false;
    }

    for (final SyncRoomUpdate update in updates!) {
      final List<dynamic>? events = getRoomUpdateEvents(type, update);
      if (hasMembershipUpdate(
        events,
        type.name,
        userId,
      )) {
        return true;
      }
    }
    return false;
  }

  List<SyncRoomUpdate>? getRoomUpdates(Membership type) {
    switch (type) {
      case Membership.join:
        return rooms?.join?.values.toList();
      case Membership.leave:
        return rooms?.leave?.values.toList();
      case Membership.invite:
        return rooms?.invite?.values.toList();
      default:
        return null;
    }
  }

  bool isSpaceChildUpdate(String activeSpaceId) {
    if (rooms?.join?.isEmpty ?? true) {
      return false;
    }
    for (final update in rooms!.join!.entries) {
      final String spaceId = update.key;
      final List<MatrixEvent>? timelineEvents = update.value.timeline?.events;
      final bool isUpdate = timelineEvents != null &&
          spaceId == activeSpaceId &&
          timelineEvents.any((event) => event.type == EventTypes.SpaceChild);
      if (isUpdate) return true;
    }
    return false;
  }
}

List<dynamic>? getRoomUpdateEvents(Membership type, SyncRoomUpdate update) {
  switch (type) {
    case Membership.join:
      return (update as JoinedRoomUpdate).timeline?.events;
    case Membership.leave:
      return (update as LeftRoomUpdate).timeline?.events;
    case Membership.invite:
      return (update as InvitedRoomUpdate).inviteState;
    default:
      return null;
  }
}

bool hasMembershipUpdate(
  List<dynamic>? events,
  String membershipType,
  String userId,
) {
  if (events == null) {
    return false;
  }
  return events.any(
    (event) =>
        event.type == EventTypes.RoomMember &&
        event.stateKey == userId &&
        event.content['membership'] == membershipType,
  );
}
