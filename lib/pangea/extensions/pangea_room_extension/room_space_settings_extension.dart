part of "pangea_room_extension.dart";

extension SpaceRoomExtension on Room {
  DateTime? get _rulesUpdatedAt {
    if (!isSpace) return null;
    return pangeaRoomRulesStateEvent?.originServerTs ?? creationTime;
  }

  String get _classCode {
    if (!isSpace) {
      for (final Room potentialClassRoom in pangeaSpaceParents) {
        if (potentialClassRoom.isSpace) {
          return potentialClassRoom.classCode;
        }
      }
      return "Not in a class!";
    }
    final roomJoinRules = getState(EventTypes.RoomJoinRules, "");
    if (roomJoinRules != null) {
      final accessCode = roomJoinRules.content.tryGet(ModelKey.accessCode);
      if (accessCode is String) {
        return accessCode;
      }
    }
    return noClassCode;
  }

  void _checkClass() {
    if (!isSpace) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(message: "calling room.students with non-class room"),
      );
    }
  }

  List<User> get _students {
    checkClass();
    return isSpace
        ? getParticipants()
            .where(
              (e) =>
                  e.powerLevel < ClassDefaultValues.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : getParticipants();
  }

  Future<List<User>> get _teachers async {
    checkClass();
    final List<User> participants = await requestParticipants();
    return isSpace
        ? participants
            .where(
              (e) =>
                  e.powerLevel == ClassDefaultValues.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : participants;
  }

  /// Synchronous version of _teachers. Does not request participants, so this list may not be complete.
  List<User> get _teachersLocal {
    if (!isSpace) return [];
    return getParticipants()
        .where(
          (e) =>
              e.powerLevel == ClassDefaultValues.powerLevelOfAdmin &&
              e.id != BotName.byEnvironment,
        )
        .toList();
  }

  /// If the user is an admin of this space, and the space's
  /// m.space.child power level hasn't yet been set, so it to 0
  Future<void> _setClassPowerLevels() async {
    try {
      if (!isRoomAdmin) return;
      final dynamic currentPower = getState(EventTypes.RoomPowerLevels);
      if (currentPower is! Event?) return;

      final currentPowerContent =
          currentPower?.content["events"] as Map<String, dynamic>?;
      final spaceChildPower = currentPowerContent?[EventTypes.SpaceChild];

      if (spaceChildPower == null && currentPowerContent != null) {
        currentPowerContent[EventTypes.SpaceChild] = 0;
        currentPower!.content["events"] = currentPowerContent;

        await client.setRoomStateWithKey(
          id,
          EventTypes.RoomPowerLevels,
          currentPower.stateKey ?? "",
          currentPower.content,
        );
      }
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s, data: toJson());
    }
  }

  Event? get _pangeaRoomRulesStateEvent {
    final dynamic roomRules = getState(PangeaEventTypes.rules);
    if (roomRules is Event) {
      return roomRules;
    }
    return null;
  }

  Future<List<LanguageModel>> _targetLanguages() async {
    await requestParticipants();
    final students = _students;

    final Map<LanguageModel, int> langCounts = {};
    final List<Room> allRooms = client.rooms;
    for (final User student in students) {
      for (final Room room in allRooms) {
        if (!room.isAnalyticsRoomOfUser(student.id)) continue;
        final String? langCode = room.madeForLang;
        if (langCode == null ||
            langCode.isEmpty ||
            langCode == LanguageKeys.unknownLanguage) {
          continue;
        }
        final LanguageModel? lang = PangeaLanguage.byLangCode(langCode);
        if (lang == null) continue;
        langCounts[lang] ??= 0;
        langCounts[lang] = langCounts[lang]! + 1;
      }
    }
    // get a list of language models, sorted
    // by the number of students who are learning that language
    return langCounts.entries.map((entry) => entry.key).toList()
      ..sort(
        (a, b) => langCounts[b]!.compareTo(langCounts[a]!),
      );
  }

  // DateTime? get _languageSettingsUpdatedAt {
  //   if (!isSpace) return null;
  //   return languageSettingsStateEvent?.originServerTs ?? creationTime;
  // }

  /// the pangeaClass event is listed an importantStateEvent so, if event exists,
  /// it's already local. If it's an old class and doesn't, then the class_controller
  /// should automatically migrate during this same session, when the space is first loaded
  // LanguageSettingsModel? get _languageSettings {
  //   try {
  //     if (!isSpace) {
  //       return null;
  //     }
  //     final Map<String, dynamic>? content = languageSettingsStateEvent?.content;
  //     if (content != null) {
  //       final LanguageSettingsModel languageSettings =
  //           LanguageSettingsModel.fromJson(content);
  //       return languageSettings;
  //     }
  //     return null;
  //   } catch (err, s) {
  //     Sentry.addBreadcrumb(
  //       Breadcrumb(
  //         message: "Error in languageSettings",
  //         data: {"room": toJson()},
  //       ),
  //     );
  //     ErrorHandler.logError(e: err, s: s);
  //     return null;
  //   }
  // }

  // Event? get _languageSettingsStateEvent {
  //   final dynamic languageSettings =
  //       getState(PangeaEventTypes.languageSettings);
  //   if (languageSettings is Event) {
  //     return languageSettings;
  //   }
  //   return null;
  // }

  // LanguageSettingsModel? get _firstLanguageSettings =>
  //     languageSettings ??
  //     firstParentWithState(PangeaEventTypes.languageSettings)?.languageSettings;
}
