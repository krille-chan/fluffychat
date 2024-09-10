part of "client_extension.dart";

extension SpaceClientExtension on Client {
  List<Room> get _spacesImTeaching =>
      rooms.where((e) => e.isSpace && e.isRoomAdmin).toList();

  List<Room> get _spacesImStudyingIn =>
      rooms.where((e) => e.isSpace && !e.isRoomAdmin).toList();

  List<Room> get _spacesImIn => rooms.where((e) => e.isSpace).toList();

  PangeaRoomRules? get _lastUpdatedRoomRules => _spacesImTeaching
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
