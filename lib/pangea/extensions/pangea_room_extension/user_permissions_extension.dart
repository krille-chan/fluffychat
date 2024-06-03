part of "pangea_room_extension.dart";

extension UserPermissionsRoomExtension on Room {
  bool _isMadeByUser(String userId) =>
      getState(EventTypes.RoomCreate)?.senderId == userId;

  //if the user is an admin of the room or any immediate parent of the room
  //Question: check parents of parents?
  //check logic
  bool get _isSpaceAdmin {
    if (isSpace) return _isRoomAdmin;

    for (final parent in pangeaSpaceParents) {
      if (parent._isRoomAdmin) {
        return true;
      }
    }
    for (final parent in pangeaSpaceParents) {
      for (final parent2 in parent.pangeaSpaceParents) {
        if (parent2._isRoomAdmin) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isUserRoomAdmin(String userId) => getParticipants().any(
        (e) =>
            e.id == userId &&
            e.powerLevel == ClassDefaultValues.powerLevelOfAdmin,
      );

  bool _isUserSpaceAdmin(String userId) {
    if (isSpace) return isUserRoomAdmin(userId);

    for (final parent in pangeaSpaceParents) {
      if (parent.isUserRoomAdmin(userId)) {
        return true;
      }
    }
    return false;
  }

  bool get _isRoomOwner =>
      getState(EventTypes.RoomCreate)?.senderId == client.userID;

  bool get _isRoomAdmin =>
      ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin;

  bool get _showClassEditOptions => isSpace && isRoomAdmin;

  bool get _canDelete => isSpaceAdmin;

  bool _canIAddSpaceChild(Room? room) {
    if (!isSpace) {
      ErrorHandler.logError(
        m: "should not call canIAddSpaceChildren on non-space room",
        data: toJson(),
        s: StackTrace.current,
      );
      return false;
    }
    if (room != null && !room._isRoomAdmin) {
      return false;
    }
    if (!pangeaCanSendEvent(EventTypes.spaceChild) && !_isRoomAdmin) {
      return false;
    }
    if (room == null) {
      return isRoomAdmin || (pangeaRoomRules?.isCreateRooms ?? false);
    }
    if (room.isExchange) {
      return isRoomAdmin;
    }
    if (!room.isSpace) {
      return pangeaRoomRules?.isCreateRooms ?? false;
    }
    if (room.isPangeaClass) {
      ErrorHandler.logError(
        m: "should not call canIAddSpaceChild with class",
        data: room.toJson(),
        s: StackTrace.current,
      );
      return false;
    }
    return false;
  }

  bool get _canIAddSpaceParents =>
      _isRoomAdmin || pangeaCanSendEvent(EventTypes.spaceParent);

  //overriding the default canSendEvent to check power levels
  bool _pangeaCanSendEvent(String eventType) {
    final powerLevelsMap = getState(EventTypes.RoomPowerLevels)?.content;
    if (powerLevelsMap == null) return 0 <= ownPowerLevel;
    final pl = powerLevelsMap
            .tryGetMap<String, dynamic>('events')
            ?.tryGet<int>(eventType) ??
        100;
    return ownPowerLevel >= pl;
  }

  int? get _eventsDefaultPowerLevel => getState(EventTypes.RoomPowerLevels)
      ?.content
      .tryGet<int>('events_default');
}
