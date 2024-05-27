part of "pangea_room_extension.dart";

extension PangeaRoom1 on Room {
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

  StudentAnalyticsEvent? _getStudentAnalyticsLocal(String studentId) {
    if (!isSpace) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "calling getStudentAnalyticsLocal on non-space room",
        s: StackTrace.current,
      );
      return null;
    }

    final Event? matrixEvent = getState(
      PangeaEventTypes.studentAnalyticsSummary,
      studentId,
    );

    return matrixEvent != null
        ? StudentAnalyticsEvent(event: matrixEvent)
        : null;
  }

  Future<StudentAnalyticsEvent?> _getStudentAnalytics(
    String studentId, {
    bool forcedUpdate = false,
  }) async {
    try {
      if (!isSpace) {
        debugger(when: kDebugMode);
        throw Exception("calling getStudentAnalyticsLocal on non-space room");
      }
      StudentAnalyticsEvent? localEvent = _getStudentAnalyticsLocal(studentId);

      if (localEvent == null) {
        await postLoad();
        localEvent = _getStudentAnalyticsLocal(studentId);
      }

      if (studentId == client.userID && localEvent == null) {
        final Event? matrixEvent = await _createStudentAnalyticsEvent();
        if (matrixEvent != null) {
          localEvent = StudentAnalyticsEvent(event: matrixEvent);
        }
      }

      return localEvent;
    } catch (err) {
      debugger(when: kDebugMode);
      rethrow;
    }
  }

  /// if [studentIds] is null, returns all students
  Future<List<StudentAnalyticsEvent?>> _getClassAnalytics([
    List<String>? studentIds,
  ]) async {
    await postLoad();
    await requestParticipants();
    final List<Future<StudentAnalyticsEvent?>> sassFutures = [];
    final List<String> filteredIds = students
        .where(
          (element) => studentIds == null || studentIds.contains(element.id),
        )
        .map((e) => e.id)
        .toList();
    for (final id in filteredIds) {
      sassFutures.add(
        getStudentAnalytics(
          id,
        ),
      );
    }
    return Future.wait(sassFutures);
  }

  ///   if [isSpace]
  ///     for all child chats, call _getChatAnalyticsGlobal and merge results
  ///   else
  ///     get analytics from pangea chat server
  ///     do any needed conversion work
  ///   save RoomAnalytics object to PangeaEventTypes.analyticsSummary event
  Future<Event?> _createStudentAnalyticsEvent() async {
    try {
      await postLoad();
      if (!pangeaCanSendEvent(PangeaEventTypes.studentAnalyticsSummary)) {
        ErrorHandler.logError(
          m: "null powerLevels in createStudentAnalytics",
          s: StackTrace.current,
        );
        return null;
      }
      if (client.userID == null) {
        debugger(when: kDebugMode);
        throw Exception("null userId in createStudentAnalytics");
      }

      final String eventId = await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.studentAnalyticsSummary,
        client.userID!,
        StudentAnalyticsSummary(
          // studentId: client.userID!,
          lastUpdated: DateTime.now(),
          messages: [],
        ).toJson(),
      );
      final Event? event = await getEventById(eventId);

      if (event == null) {
        debugger(when: kDebugMode);
        throw Exception(
          "null event after creation with eventId $eventId in createStudentAnalytics",
        );
      }
      return event;
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack, data: powerLevels);
      return null;
    }
  }

  ///   for each chat in class
  ///     get timeline back to january 15
  ///     get messages
  ///     discard timeline
  ///   save messages to StudentAnalyticsSummary
  Future<void> _updateMyLearningAnalyticsForClass([
    PLocalStore? storageService,
  ]) async {
    try {
      final String migratedAnalyticsKey =
          "MIGRATED_ANALYTICS_KEY${id.localpart}";

      if (storageService?.read(
            migratedAnalyticsKey,
            local: true,
          ) ??
          false) return;

      if (!isPangeaClass && !isExchange) {
        throw Exception(
          "In updateMyLearningAnalyticsForClass with room that is not not a class",
        );
      }

      if (client.userID == null) {
        debugger(when: kDebugMode);
        return;
      }

      final StudentAnalyticsEvent? myAnalEvent =
          await getStudentAnalytics(client.userID!);

      if (myAnalEvent == null) {
        debugPrint("null analytcs event for $id");
        if (pangeaCanSendEvent(PangeaEventTypes.studentAnalyticsSummary)) {
          // debugger(when: kDebugMode);
        }
        return;
      }

      final updateMessages = await _messageListForAllChildChats;
      updateMessages.removeWhere(
        (element) => myAnalEvent.content.messages.any(
          (e) => e.eventId == element.eventId,
        ),
      );
      myAnalEvent.bulkUpdate(updateMessages);

      await storageService?.save(
        migratedAnalyticsKey,
        true,
        local: true,
      );
    } catch (err, s) {
      if (kDebugMode) rethrow;
      // debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
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
}
