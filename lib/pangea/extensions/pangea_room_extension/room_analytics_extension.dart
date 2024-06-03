part of "pangea_room_extension.dart";

extension AnalyticsRoomExtension on Room {
  // Join analytics rooms in space
  // Allows teachers to join analytics rooms without being invited
  Future<void> _joinAnalyticsRoomsInSpace() async {
    if (!isSpace) {
      debugPrint("joinAnalyticsRoomsInSpace called on non-space room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "joinAnalyticsRoomsInSpace called on non-space room",
        ),
      );
      return;
    }

    // added delay because without it power levels don't load and user is not
    // recognized as admin
    await Future.delayed(const Duration(milliseconds: 500));
    await postLoad();

    if (!isRoomAdmin) {
      debugPrint("joinAnalyticsRoomsInSpace called by non-admin");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "joinAnalyticsRoomsInSpace called by non-admin",
        ),
      );
      return;
    }

    final spaceHierarchy = await client.getSpaceHierarchy(
      id,
      maxDepth: 1,
    );

    final List<String> analyticsRoomIds = spaceHierarchy.rooms
        .where(
          (r) => r.roomType == PangeaRoomTypes.analytics,
        )
        .map((r) => r.roomId)
        .toList();

    for (final String roomID in analyticsRoomIds) {
      try {
        await joinSpaceChild(roomID);
      } catch (err, s) {
        debugPrint("Failed to join analytics room $roomID in space $id");
        ErrorHandler.logError(
          e: err,
          m: "Failed to join analytics room $roomID in space $id",
          s: s,
        );
      }
    }
  }

  // check if analytics room exists for a given language code
  // and if not, create it
  Future<void> _ensureAnalyticsRoomExists() async {
    await postLoad();
    if (firstLanguageSettings?.targetLanguage == null) return;
    await client.getMyAnalyticsRoom(firstLanguageSettings!.targetLanguage);
  }

  // add 1 analytics room to 1 space
  Future<void> _addAnalyticsRoomToSpace(Room analyticsRoom) async {
    if (!isSpace) {
      debugPrint("addAnalyticsRoomToSpace called on non-space room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "addAnalyticsRoomToSpace called on non-space room",
        ),
      );
      return Future.value();
    }

    if (spaceChildren.any((sc) => sc.roomId == analyticsRoom.id)) return;
    if (canIAddSpaceChild(null)) {
      try {
        await setSpaceChild(analyticsRoom.id);
      } catch (err) {
        debugPrint(
          "Failed to add analytics room ${analyticsRoom.id} for student to space $id",
        );
        Sentry.addBreadcrumb(
          Breadcrumb(
            message: "Failed to add analytics room to space $id",
          ),
        );
      }
    }
  }

  // Add analytics room to all spaces the user is a student in (1 analytics room to all spaces)
  // So teachers can join them via space hierarchy
  // Will not always work, as there may be spaces where students don't have permission to add chats
  // But allows teachers to join analytics rooms without being invited
  Future<void> _addAnalyticsRoomToSpaces() async {
    if (!isAnalyticsRoomOfUser(client.userID!)) {
      debugPrint("addAnalyticsRoomToSpaces called on non-analytics room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "addAnalyticsRoomToSpaces called on non-analytics room",
        ),
      );
      return;
    }

    for (final Room space in (await client.classesAndExchangesImStudyingIn)) {
      if (space.spaceChildren.any((sc) => sc.roomId == id)) continue;
      await space.addAnalyticsRoomToSpace(this);
    }
  }

  // Add all analytics rooms to space
  // Similar to addAnalyticsRoomToSpaces, but all analytics room to 1 space
  Future<void> _addAnalyticsRoomsToSpace() async {
    await postLoad();
    final List<Room> allMyAnalyticsRooms = client.allMyAnalyticsRooms;
    for (final Room analyticsRoom in allMyAnalyticsRooms) {
      await addAnalyticsRoomToSpace(analyticsRoom);
    }
  }

  // invite teachers of 1 space to 1 analytics room
  Future<void> _inviteSpaceTeachersToAnalyticsRoom(Room analyticsRoom) async {
    if (!isSpace) {
      debugPrint(
        "inviteSpaceTeachersToAnalyticsRoom called on non-space room",
      );
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "inviteSpaceTeachersToAnalyticsRoom called on non-space room",
        ),
      );
      return;
    }
    if (!analyticsRoom.participantListComplete) {
      await analyticsRoom.requestParticipants();
    }
    final List<User> participants = analyticsRoom.getParticipants();
    for (final User teacher in (await teachers)) {
      if (!participants.any((p) => p.id == teacher.id)) {
        try {
          await analyticsRoom.invite(teacher.id);
        } catch (err, s) {
          debugPrint(
            "Failed to invite teacher ${teacher.id} to analytics room ${analyticsRoom.id}",
          );
          ErrorHandler.logError(
            e: err,
            m: "Failed to invite teacher ${teacher.id} to analytics room ${analyticsRoom.id}",
            s: s,
          );
        }
      }
    }
  }

  // Invite all teachers to 1 analytics room
  // Handles case when students cannot add analytics room to space
  // So teacher is still able to get analytics data for this student
  Future<void> _inviteTeachersToAnalyticsRoom() async {
    if (client.userID == null) {
      debugPrint("inviteTeachersToAnalyticsRoom called with null userId");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "inviteTeachersToAnalyticsRoom called with null userId",
        ),
      );
      return;
    }

    if (!isAnalyticsRoomOfUser(client.userID!)) {
      debugPrint("inviteTeachersToAnalyticsRoom called on non-analytics room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "inviteTeachersToAnalyticsRoom called on non-analytics room",
        ),
      );
      return;
    }

    for (final Room space in (await client.classesAndExchangesImStudyingIn)) {
      await space.inviteSpaceTeachersToAnalyticsRoom(this);
    }
  }

  // Invite teachers of 1 space to all users' analytics rooms
  Future<void> _inviteSpaceTeachersToAnalyticsRooms() async {
    for (final Room analyticsRoom in client.allMyAnalyticsRooms) {
      await inviteSpaceTeachersToAnalyticsRoom(analyticsRoom);
    }
  }

  Future<AnalyticsEvent?> _getLastAnalyticsEvent(
    String type,
  ) async {
    final Timeline timeline = await getTimeline();
    int requests = 0;
    Event? lastEvent = timeline.events.firstWhereOrNull(
      (event) => event.type == type,
    );

    while (requests < 10 && timeline.canRequestHistory && lastEvent == null) {
      await timeline.requestHistory();
      lastEvent = timeline.events.firstWhereOrNull(
        (event) => event.type == type,
      );
      requests++;
    }

    if (lastEvent == null) return null;

    switch (type) {
      case PangeaEventTypes.summaryAnalytics:
        return SummaryAnalyticsEvent(event: lastEvent);
      case PangeaEventTypes.construct:
        return ConstructAnalyticsEvent(event: lastEvent);
    }

    return null;
  }

  Future<AnalyticsEvent?> _getPrevAnalyticsEvent(
    AnalyticsEvent analyticsEvent,
  ) async {
    if (analyticsEvent.content.prevEventId == null) {
      return null;
    }
    final Event? prevEvent = await getEventById(
      analyticsEvent.content.prevEventId!,
    );
    if (prevEvent == null) return null;

    switch (analyticsEvent.event.type) {
      case PangeaEventTypes.summaryAnalytics:
        return SummaryAnalyticsEvent(event: prevEvent);
      case PangeaEventTypes.construct:
        return ConstructAnalyticsEvent(event: prevEvent);
    }

    return null;
  }

  Future<List<AnalyticsEvent>?> _getAnalyticsEvents({
    required String type,
    DateTime? since,
  }) async {
    final AnalyticsEvent? mostRecentEvent = await getLastAnalyticsEvent(type);
    if (mostRecentEvent == null) return null;
    final List<AnalyticsEvent> events = [mostRecentEvent];

    bool getAllEvents() =>
        since == null && events.last.content.prevEventId == null;

    bool reachedUpdated() =>
        since != null &&
        (events.last.content.lastUpdated?.isBefore(since) ?? true);

    while (getAllEvents() || !reachedUpdated()) {
      final AnalyticsEvent? prevEvent = await getPrevAnalyticsEvent(
        events.last,
      );
      if (prevEvent == null) break;
      events.add(prevEvent);
    }
    return events;
  }

  String? get _madeForLang {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) ??
        creationContent?.tryGet<String>(ModelKey.oldLangCode);
  }

  bool _isMadeForLang(String langCode) {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) == langCode ||
        creationContent?.tryGet<String>(ModelKey.oldLangCode) == langCode;
  }
}
