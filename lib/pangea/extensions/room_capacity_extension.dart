part of "pangea_room_extension.dart";

extension RoomCapacityExtension on Room {
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
}
