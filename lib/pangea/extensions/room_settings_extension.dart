part of "pangea_room_extension.dart";

extension RoomSettingsRoomExtension on Room {
  Future<void> updateRoomCapacity(int newCapacity) =>
      client.setRoomStateWithKey(
        id,
        PangeaEventTypes.capacity,
        '',
        {'capacity': newCapacity},
      );

  int? get capacity {
    final t = getState(PangeaEventTypes.capacity)?.content['capacity'];
    return t is int ? t : null;
  }

  BotOptionsModel? get botOptions {
    if (isSpace) return null;
    final stateEvent = getState(PangeaEventTypes.botOptions);
    if (stateEvent == null) return null;
    return BotOptionsModel.fromJson(stateEvent.content);
  }
}
