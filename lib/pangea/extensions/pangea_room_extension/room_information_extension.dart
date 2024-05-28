part of "pangea_room_extension.dart";

extension RoomInformationRoomExtension on Room {
  DateTime? get _creationTime =>
      getState(EventTypes.RoomCreate)?.originServerTs;

  String? get _creatorId => getState(EventTypes.RoomCreate)?.senderId;

  String get _domainString =>
      AppConfig.defaultHomeserver.replaceAll("matrix.", "");

  bool _isChild(String roomId) =>
      isSpace && spaceChildren.any((room) => room.roomId == roomId);

  bool _isFirstOrSecondChild(String roomId) {
    return isSpace &&
        (spaceChildren.any((room) => room.roomId == roomId) ||
            spaceChildren
                .where((sc) => sc.roomId != null)
                .map((sc) => client.getRoomById(sc.roomId!))
                .any(
                  (room) =>
                      room != null &&
                      room.isSpace &&
                      room.spaceChildren.any((room) => room.roomId == roomId),
                ));
  }

  bool get _isExchange =>
      isSpace &&
      languageSettingsStateEvent == null &&
      pangeaRoomRulesStateEvent != null;

  bool get _isDirectChatWithoutMe =>
      isDirectChat && !getParticipants().any((e) => e.id == client.userID);

  bool _isMadeForLang(String langCode) {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) == langCode ||
        creationContent?.tryGet<String>(ModelKey.oldLangCode) == langCode;
  }

  Future<bool> get _isBotRoom async {
    final List<User> participants = await requestParticipants();
    return participants.any(
      (User user) => user.id == BotName.byEnvironment,
    );
  }

  Future<bool> get _isBotDM async =>
      (await isBotRoom) && getParticipants().length == 2;

  bool get _isLocked {
    if (isDirectChat) return false;
    if (!isSpace) {
      if (eventsDefaultPowerLevel == null) return false;
      return (eventsDefaultPowerLevel ?? 0) >=
          ClassDefaultValues.powerLevelOfAdmin;
    }
    int joinedRooms = 0;
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room?.isLocked == false) {
        return false;
      }
      if (room != null) {
        joinedRooms += 1;
      }
    }
    return joinedRooms > 0 ? true : false;
  }

  bool get _isPangeaClass => isSpace && languageSettingsStateEvent != null;

  bool _isAnalyticsRoomOfUser(String userId) =>
      isAnalyticsRoom && isMadeByUser(userId);

  bool get _isAnalyticsRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      PangeaRoomTypes.analytics;
}
