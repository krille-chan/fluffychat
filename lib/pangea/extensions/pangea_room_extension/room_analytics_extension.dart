part of "pangea_room_extension.dart";

extension AnalyticsRoomExtension on Room {
  /// Join analytics rooms in space.
  /// Allows teachers to join analytics rooms without being invited.
  Future<void> _joinAnalyticsRoomsInSpace() async {
    try {
      if (!isSpace) {
        debugger(when: kDebugMode);
        return;
      }

      if (!isRoomAdmin) return;
      final spaceHierarchy = await client.getSpaceHierarchy(
        id,
        maxDepth: 1,
      );

      final List<String> analyticsRoomIds = spaceHierarchy.rooms
          .where((r) => r.roomType == PangeaRoomTypes.analytics)
          .map((r) => r.roomId)
          .toList();

      await Future.wait(
        analyticsRoomIds.map(
          (roomID) => joinSpaceChild(roomID).catchError((err, s) {
            debugPrint("Failed to join analytics room $roomID in space $id");
            ErrorHandler.logError(
              e: err,
              m: "Failed to join analytics room $roomID in space $id",
              s: s,
            );
          }),
        ),
      );
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
      );
      return;
    }
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

    if (!canSendEvent(EventTypes.SpaceChild)) return;
    if (spaceChildren.any((sc) => sc.roomId == analyticsRoom.id)) return;

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

  /// Add analytics room to all spaces the user is a student in (1 analytics room to all spaces).
  /// Enables teachers to join student analytics rooms via space hierarchy.
  /// Will not always work, as there may be spaces where students don't have permission to add chats,
  /// but allows teachers to join analytics rooms without being invited.
  void _addAnalyticsRoomToSpaces() {
    if (!isAnalyticsRoomOfUser(client.userID!)) return;
    Future.wait(
      client.spacesImAStudentIn
          .where((space) => !space.spaceChildren.any((sc) => sc.roomId == id))
          .map((space) => space.addAnalyticsRoomToSpace(this)),
    );
  }

  /// Add all the user's analytics rooms to 1 space.
  void _addAnalyticsRoomsToSpace() {
    Future.wait(
      client.allMyAnalyticsRooms.map((room) => addAnalyticsRoomToSpace(room)),
    );
  }

  /// Invite teachers of 1 space to 1 analytics room
  Future<void> _inviteSpaceTeachersToAnalyticsRoom(Room analyticsRoom) async {
    if (!isSpace) return;
    if (!analyticsRoom.participantListComplete) {
      await analyticsRoom.requestParticipants();
    }

    final List<User> participants = analyticsRoom.getParticipants();
    final List<User> uninvitedTeachers = teachersLocal
        .where((teacher) => !participants.contains(teacher))
        .toList();

    Future.wait(
      uninvitedTeachers.map(
        (teacher) => analyticsRoom.invite(teacher.id).catchError((err, s) {
          ErrorHandler.logError(
            e: err,
            m: "Failed to invite teacher ${teacher.id} to analytics room ${analyticsRoom.id}",
            s: s,
          );
        }),
      ),
    );
  }

  /// Invite all the user's teachers to 1 analytics room.
  /// Handles case when students cannot add analytics room to space
  /// so teacher is still able to get analytics data for this student.
  void _inviteTeachersToAnalyticsRoom() {
    if (client.userID == null || !isAnalyticsRoomOfUser(client.userID!)) return;
    Future.wait(
      client.spacesImAStudentIn.map(
        (space) => inviteSpaceTeachersToAnalyticsRoom(this),
      ),
    );
  }

  /// Invite teachers of 1 space to all users' analytics rooms
  void _inviteSpaceTeachersToAnalyticsRooms() {
    Future.wait(
      client.allMyAnalyticsRooms.map(
        (room) => inviteSpaceTeachersToAnalyticsRoom(room),
      ),
    );
  }

  Future<AnalyticsEvent?> _getLastAnalyticsEvent(
    String type,
    String userId,
  ) async {
    final List<Event> events = await getEventsBySender(
      type: type,
      sender: userId,
      count: 10,
    );
    if (events.isEmpty) return null;
    final Event event = events.first;
    AnalyticsEvent? analyticsEvent;
    switch (type) {
      case PangeaEventTypes.summaryAnalytics:
        analyticsEvent = SummaryAnalyticsEvent(event: event);
      case PangeaEventTypes.construct:
        analyticsEvent = ConstructAnalyticsEvent(event: event);
    }
    return analyticsEvent;
  }

  Future<DateTime?> _analyticsLastUpdated(String type, String userId) async {
    final lastEvent = await _getLastAnalyticsEvent(type, userId);
    return lastEvent?.event.originServerTs;
  }

  Future<List<AnalyticsEvent>?> _getAnalyticsEvents({
    required String type,
    required String userId,
    DateTime? since,
  }) async {
    final List<Event> events = await getEventsBySender(
      type: type,
      sender: userId,
      since: since,
    );
    final List<AnalyticsEvent> analyticsEvents = [];
    for (final Event event in events) {
      switch (type) {
        case PangeaEventTypes.summaryAnalytics:
          analyticsEvents.add(SummaryAnalyticsEvent(event: event));
          break;
        case PangeaEventTypes.construct:
          analyticsEvents.add(ConstructAnalyticsEvent(event: event));
          break;
      }
    }

    return analyticsEvents;
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

  Future<String?> sendSummaryAnalyticsEvent(
    List<RecentMessageRecord> records,
  ) async {
    final SummaryAnalyticsModel analyticsModel = SummaryAnalyticsModel(
      messages: records,
    );
    final String? eventId = await sendEvent(
      analyticsModel.toJson(),
      type: PangeaEventTypes.summaryAnalytics,
    );
    return eventId;
  }

  Future<String?> sendConstructsEvent(
    List<OneConstructUse> uses,
  ) async {
    final ConstructAnalyticsModel constructsModel = ConstructAnalyticsModel(
      uses: uses,
    );

    final String? eventId = await sendEvent(
      constructsModel.toJson(),
      type: PangeaEventTypes.construct,
    );
    return eventId;
  }
}
