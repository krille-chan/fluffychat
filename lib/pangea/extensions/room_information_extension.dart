part of "pangea_room_extension.dart";

extension RoomInformationRoomExtension on Room {
  Future<int> get numNonAdmins async {
    return (await requestParticipants())
        .where(
          (e) =>
              e.powerLevel < SpaceConstants.powerLevelOfAdmin &&
              e.id != BotName.byEnvironment,
        )
        .toList()
        .length;
  }

  DateTime? get creationTime {
    final dynamic roomCreate = getState(EventTypes.RoomCreate);
    if (roomCreate is! Event) return null;
    return roomCreate.originServerTs;
  }

  String? get creatorId => getState(EventTypes.RoomCreate)?.senderId;

  bool isFirstOrSecondChild(String roomId) {
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

  Future<bool> get botIsInRoom async {
    final List<User> participants = await requestParticipants();
    return participants.any(
      (User user) => user.id == BotName.byEnvironment,
    );
  }

  bool get isBotDM => botOptions?.mode == BotMode.directChat;

  bool isAnalyticsRoomOfUser(String userId) =>
      isAnalyticsRoom && isMadeByUser(userId);

  bool get isAnalyticsRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      PangeaRoomTypes.analytics;
}
