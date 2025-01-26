part of "pangea_room_extension.dart";

extension RoomInformationRoomExtension on Room {
  Future<int> get _numNonAdmins async {
    return (await requestParticipants())
        .where(
          (e) =>
              e.powerLevel < SpaceConstants.powerLevelOfAdmin &&
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

  Future<bool> get _botIsInRoom async {
    final List<User> participants = await requestParticipants();
    return participants.any(
      (User user) => user.id == BotName.byEnvironment,
    );
  }

  bool get _isBotDM => botOptions?.mode == BotMode.directChat;

  bool _isAnalyticsRoomOfUser(String userId) =>
      isAnalyticsRoom && isMadeByUser(userId);

  bool get _isAnalyticsRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      PangeaRoomTypes.analytics;
}
