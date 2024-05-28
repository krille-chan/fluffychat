part of "pangea_room_extension.dart";

extension ClassAndExchangeSettingsRoomExtension on Room {
  DateTime? get _rulesUpdatedAt {
    if (!isSpace) return null;
    return pangeaRoomRulesStateEvent?.originServerTs ?? creationTime;
  }

  String get _classCode {
    if (!isSpace) {
      for (final Room potentialClassRoom in pangeaSpaceParents) {
        if (potentialClassRoom.isPangeaClass) {
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
      final Event? currentPower = getState(EventTypes.RoomPowerLevels);
      final Map<String, dynamic>? currentPowerContent =
          currentPower?.content["events"] as Map<String, dynamic>?;
      final spaceChildPower = currentPowerContent?[EventTypes.spaceChild];
      final studentAnalyticsPower =
          currentPowerContent?[PangeaEventTypes.studentAnalyticsSummary];

      if ((spaceChildPower == null || studentAnalyticsPower == null) &&
          currentPowerContent != null) {
        currentPowerContent["events"][EventTypes.spaceChild] = 0;
        currentPowerContent["events"]
            [PangeaEventTypes.studentAnalyticsSummary] = 0;

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

  DateTime? get _classSettingsUpdatedAt {
    if (!isSpace) return null;
    return languageSettingsStateEvent?.originServerTs ?? creationTime;
  }

  /// the pangeaClass event is listed an importantStateEvent so, if event exists,
  /// it's already local. If it's an old class and doesn't, then the class_controller
  /// should automatically migrate during this same session, when the space is first loaded
  ClassSettingsModel? get _classSettings {
    try {
      if (!isSpace) {
        return null;
      }
      final Map<String, dynamic>? content = languageSettingsStateEvent?.content;
      if (content != null) {
        final ClassSettingsModel classSettings =
            ClassSettingsModel.fromJson(content);
        return classSettings;
      }
      return null;
    } catch (err, s) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "Error in classSettings",
          data: {"room": toJson()},
        ),
      );
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }

  Event? get _languageSettingsStateEvent =>
      getState(PangeaEventTypes.classSettings);

  Event? get _pangeaRoomRulesStateEvent => getState(PangeaEventTypes.rules);

  ClassSettingsModel? get _firstLanguageSettings =>
      classSettings ??
      firstParentWithState(PangeaEventTypes.classSettings)?.classSettings;
}
