part of "pangea_room_extension.dart";

extension RoomInformationRoomExtension on Room {
  Future<int> get _numNonAdmins async {
    return (await requestParticipants())
        .where(
          (e) =>
              e.powerLevel < ClassDefaultValues.powerLevelOfAdmin &&
              e.id != BotName.byEnvironment,
        )
        .toList()
        .length;
  }

  DateTime? get _creationTime {
    final dynamic roomCreate = getState(EventTypes.RoomCreate);
    if (roomCreate is! Event) return null;
    return roomCreate.originServerTs;
  }

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

  bool get _isDirectChatWithoutMe =>
      isDirectChat && !getParticipants().any((e) => e.id == client.userID);

  // bool _isMadeForLang(String langCode) {
  //   final creationContent = getState(EventTypes.RoomCreate)?.content;
  //   return creationContent?.tryGet<String>(ModelKey.langCode) == langCode ||
  //       creationContent?.tryGet<String>(ModelKey.oldLangCode) == langCode;
  // }

  Future<bool> get _botIsInRoom async {
    final List<User> participants = await requestParticipants();
    return participants.any(
      (User user) => user.id == BotName.byEnvironment,
    );
  }

  Future<bool> get _isBotDM async => botOptions?.mode == BotMode.directChat;

  // bool get _isLocked {
  //   if (isDirectChat) return false;
  //   if (!isSpace) {
  //     if (eventsDefaultPowerLevel == null) return false;
  //     return (eventsDefaultPowerLevel ?? 0) >=
  //         ClassDefaultValues.powerLevelOfAdmin;
  //   }
  //   for (final child in spaceChildren) {
  //     if (child.roomId == null) continue;
  //     final Room? room = client.getRoomById(child.roomId!);
  //     if (room == null || room.isAnalyticsRoom || room.isArchived) continue;
  //     if (!room._isLocked) {
  //       return false;
  //     }
  //   }
  //   return (eventsDefaultPowerLevel ?? 0) >=
  //       ClassDefaultValues.powerLevelOfAdmin;
  // }

  bool _isAnalyticsRoomOfUser(String userId) =>
      isAnalyticsRoom && isMadeByUser(userId);

  bool get _isAnalyticsRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      PangeaRoomTypes.analytics;
}
