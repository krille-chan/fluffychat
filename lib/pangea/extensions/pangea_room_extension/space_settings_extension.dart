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

    return canonicalAlias.replaceAll(":$domainString", "").replaceAll("#", "");
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

  Future<void> _setClassPowerLevels() async {
    try {
      if (ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin) {
        return;
      }
      final dynamic currentPower = getState(EventTypes.RoomPowerLevels);
      if (currentPower is! Event?) {
        return;
      }
      final Map<String, dynamic>? currentPowerContent =
          currentPower?.content["events"] as Map<String, dynamic>?;
      final spaceChildPower = currentPowerContent?[EventTypes.SpaceChild];

      if (spaceChildPower == null && currentPowerContent != null) {
        currentPowerContent["events"][EventTypes.SpaceChild] = 0;

        await client.setRoomStateWithKey(
          id,
          EventTypes.RoomPowerLevels,
          currentPower?.stateKey ?? "",
          currentPowerContent,
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
