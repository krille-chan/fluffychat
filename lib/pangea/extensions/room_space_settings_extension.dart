part of "pangea_room_extension.dart";

extension SpaceRoomExtension on Room {
  String? get classCode {
    if (!isSpace) return null;
    final roomJoinRules = getState(EventTypes.RoomJoinRules, "");
    if (roomJoinRules != null) {
      final accessCode = roomJoinRules.content.tryGet(ModelKey.accessCode);
      if (accessCode is String) {
        return accessCode;
      }
    }
    return null;
  }

  void checkClass() {
    if (!isSpace) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(message: "calling room.students with non-class room"),
      );
    }
  }

  Future<List<User>> get teachers async {
    checkClass();
    final List<User> participants = await requestParticipants();
    return isSpace
        ? participants
            .where(
              (e) =>
                  e.powerLevel == SpaceConstants.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : participants;
  }
}
