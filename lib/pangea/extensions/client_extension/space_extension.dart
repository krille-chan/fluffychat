part of "client_extension.dart";

extension SpaceClientExtension on Client {
  Future<List<Room>> get _spacesImTeaching async {
    final allSpaces = rooms.where((room) => room.isSpace);
    for (final Room space in allSpaces) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              (e.isSpace) &&
              e.ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  Future<List<Room>> get _spacesImStudyingIn async {
    final List<Room> joinedSpaces = rooms
        .where(
          (room) => room.isSpace && room.membership == Membership.join,
        )
        .toList();

    for (final Room space in joinedSpaces) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              e.isSpace &&
              e.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  List<Room> get _spacesImIn => rooms.where((e) => e.isSpace).toList();

  Future<PangeaRoomRules?> get _lastUpdatedRoomRules async =>
      (await _spacesImTeaching)
          .where((space) => space.rulesUpdatedAt != null)
          .sorted(
            (a, b) => b.rulesUpdatedAt!.compareTo(a.rulesUpdatedAt!),
          )
          .firstOrNull
          ?.pangeaRoomRules;

  // LanguageSettingsModel? get _lastUpdatedLanguageSettings => rooms
  //     .where((room) => room.isSpace && room.languageSettingsUpdatedAt != null)
  //     .sorted(
  //       (a, b) => b.languageSettingsUpdatedAt!
  //           .compareTo(a.languageSettingsUpdatedAt!),
  //     )
  //     .firstOrNull
  //     ?.languageSettings;
}
