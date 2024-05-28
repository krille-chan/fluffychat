part of "client_extension.dart";

extension ClassesAndExchangesClientExtension on Client {
  List<Room> get _classes => rooms.where((e) => e.isPangeaClass).toList();

  List<Room> get _classesImTeaching => rooms
      .where(
        (e) =>
            e.isPangeaClass &&
            e.ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin,
      )
      .toList();

  Future<List<Room>> get _classesAndExchangesImTeaching async {
    final allSpaces = rooms.where((room) => room.isSpace);
    for (final Room space in allSpaces) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              (e.isPangeaClass || e.isExchange) &&
              e.ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  List<Room> get _classesImIn => rooms
      .where(
        (e) =>
            e.isPangeaClass &&
            e.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin,
      )
      .toList();

  Future<List<Room>> get _classesAndExchangesImStudyingIn async {
    for (final Room space in rooms.where((room) => room.isSpace)) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              (e.isPangeaClass || e.isExchange) &&
              e.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  List<Room> get _classesAndExchangesImIn =>
      rooms.where((e) => e.isPangeaClass || e.isExchange).toList();

  Future<PangeaRoomRules?> get _lastUpdatedRoomRules async =>
      (await _classesAndExchangesImTeaching)
          .where((space) => space.rulesUpdatedAt != null)
          .sorted(
            (a, b) => b.rulesUpdatedAt!.compareTo(a.rulesUpdatedAt!),
          )
          .firstOrNull
          ?.pangeaRoomRules;

  ClassSettingsModel? get _lastUpdatedClassSettings => classesImTeaching
      .where((space) => space.classSettingsUpdatedAt != null)
      .sorted(
        (a, b) =>
            b.classSettingsUpdatedAt!.compareTo(a.classSettingsUpdatedAt!),
      )
      .firstOrNull
      ?.classSettings;
}
