part of "pangea_room_extension.dart";

extension SpaceRoomExtension on Room {
  String classCode(BuildContext context) {
    if (!isSpace) {
      for (final Room potentialClassRoom in pangeaSpaceParents) {
        if (potentialClassRoom.isSpace) {
          return SpaceRoomExtension(potentialClassRoom).classCode(context);
        }
      }
      return L10n.of(context).notInClass;
    }
    final roomJoinRules = getState(EventTypes.RoomJoinRules, "");
    if (roomJoinRules != null) {
      final accessCode = roomJoinRules.content.tryGet(ModelKey.accessCode);
      if (accessCode is String) {
        return accessCode;
      }
    }
    return L10n.of(context).noClassCode;
  }

  void checkClass() {
    if (!isSpace) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(message: "calling room.students with non-class room"),
      );
    }
  }

  Future<List<User>> get teachers async {
    checkClass();
    final List<User> participants = await requestParticipants();
    return isSpace
        ? participants
            .where(
              (e) =>
                  e.powerLevel == SpaceConstants.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : participants;
  }

  Event? get pangeaRoomRulesStateEvent {
    final dynamic roomRules = getState(PangeaEventTypes.rules);
    if (roomRules is Event) {
      return roomRules;
    }
    return null;
  }
}
