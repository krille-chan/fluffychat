part of "pangea_room_extension.dart";

extension UserPermissionsRoomExtension on Room {
  bool isMadeByUser(String userId) =>
      getState(EventTypes.RoomCreate)?.senderId == userId;

  bool get isRoomAdmin => ownPowerLevel == SpaceConstants.powerLevelOfAdmin;
}
