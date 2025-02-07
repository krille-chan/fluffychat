part of "pangea_room_extension.dart";

extension UserPermissionsRoomExtension on Room {
// If there are no other admins, and at least one non-admin, return true
  Future<bool> isOnlyAdmin() async {
    if (!isRoomAdmin) {
      return false;
    }
    final List<User> participants = await requestParticipants();

    return ((participants
                .where(
                  (e) =>
                      e.powerLevel == SpaceConstants.powerLevelOfAdmin &&
                      e.id != BotName.byEnvironment,
                )
                .toList()
                .length) ==
            1) &&
        (participants
                .where(
                  (e) =>
                      e.powerLevel < SpaceConstants.powerLevelOfAdmin &&
                      e.id != BotName.byEnvironment,
                )
                .toList())
            .isNotEmpty;
  }

  bool isMadeByUser(String userId) =>
      getState(EventTypes.RoomCreate)?.senderId == userId;

  //if the user is an admin of the room or any immediate parent of the room
  //Question: check parents of parents?
  //check logic
  bool get isSpaceAdmin {
    if (isSpace) return isRoomAdmin;

    for (final parent in pangeaSpaceParents) {
      if (parent.isRoomAdmin) {
        return true;
      }
    }
    for (final parent in pangeaSpaceParents) {
      for (final parent2 in parent.pangeaSpaceParents) {
        if (parent2.isRoomAdmin) {
          return true;
        }
      }
    }
    return false;
  }

  bool isUserRoomAdmin(String userId) => getParticipants().any(
        (e) =>
            e.id == userId && e.powerLevel == SpaceConstants.powerLevelOfAdmin,
      );

  bool get isRoomAdmin => ownPowerLevel == SpaceConstants.powerLevelOfAdmin;

  // Overriding the default canSendEvent to check power levels
  bool pangeaCanSendEvent(String eventType) {
    final powerLevelsMap = getState(EventTypes.RoomPowerLevels)?.content;
    if (powerLevelsMap == null) return 0 <= ownPowerLevel;
    final pl = powerLevelsMap
            .tryGetMap<String, dynamic>('events')
            ?.tryGet<int>(eventType) ??
        100;
    return ownPowerLevel >= pl;
  }
}
