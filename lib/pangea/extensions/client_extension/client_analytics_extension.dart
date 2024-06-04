part of "client_extension.dart";

extension AnalyticsClientExtension on Client {
  // get analytics room matching targetlanguage
  // if not present, create it and invite teachers of that language
  // set description to let people know what the hell it is
  Future<Room> _getMyAnalyticsRoom(String langCode) async {
    await roomsLoading;
    // ensure room state events (room create,
    // to check for analytics type) are loaded
    for (final room in rooms) {
      if (room.partial) await room.postLoad();
    }

    final Room? analyticsRoom = analyticsRoomLocal(langCode);

    if (analyticsRoom != null) return analyticsRoom;

    return _makeAnalyticsRoom(langCode);
  }

  //note: if langCode is null and user has >1 analyticsRooms then this could
  //return the wrong one. this is to account for when an exchange might not
  //be in a class.
  Room? _analyticsRoomLocal(String? langCode, [String? userIdParam]) {
    final Room? analyticsRoom = rooms.firstWhereOrNull((e) {
      return e.isAnalyticsRoom &&
          e.isAnalyticsRoomOfUser(userIdParam ?? userID!) &&
          (langCode != null ? e.isMadeForLang(langCode) : true);
    });
    if (analyticsRoom != null &&
        analyticsRoom.membership == Membership.invite) {
      debugger(when: kDebugMode);
      analyticsRoom
          .join()
          .onError(
            (error, stackTrace) =>
                ErrorHandler.logError(e: error, s: stackTrace),
          )
          .then((value) => analyticsRoom.postLoad());
      return analyticsRoom;
    }
    return analyticsRoom;
  }

  Future<Room> _makeAnalyticsRoom(String langCode) async {
    final String roomID = await createRoom(
      creationContent: {
        'type': PangeaRoomTypes.analytics,
        ModelKey.langCode: langCode,
      },
      name: "$userID $langCode Analytics",
      topic: "This room stores learning analytics for $userID.",
      invite: [
        ...(await myTeachers).map((e) => e.id),
        // BotName.localBot,
        BotName.byEnvironment,
      ],
    );
    if (getRoomById(roomID) == null) {
      // Wait for room actually appears in sync
      await waitForRoomInSync(roomID, join: true);
    }

    final Room? analyticsRoom = getRoomById(roomID);

    // add this analytics room to all spaces so teachers can join them
    // via the space hierarchy
    await analyticsRoom?.addAnalyticsRoomToSpaces();

    // and invite all teachers to new analytics room
    await analyticsRoom?.inviteTeachersToAnalyticsRoom();
    return getRoomById(roomID)!;
  }

  // Get all my analytics rooms
  List<Room> get _allMyAnalyticsRooms => rooms
      .where(
        (e) => e.isAnalyticsRoomOfUser(userID!),
      )
      .toList();

  // migration function to change analytics rooms' vsibility to public
  // so they will appear in the space hierarchy
  Future<void> _updateAnalyticsRoomVisibility() async {
    final List<Future> makePublicFutures = [];
    for (final Room room in allMyAnalyticsRooms) {
      final visability = await getRoomVisibilityOnDirectory(room.id);
      if (visability != Visibility.public) {
        await setRoomVisibilityOnDirectory(
          room.id,
          visibility: Visibility.public,
        );
      }
    }
    await Future.wait(makePublicFutures);
  }

  Future<void> _updateMyLearningAnalyticsForAllClassesImIn([
    PLocalStore? storageService,
  ]) async {
    try {
      final List<Future<void>> updateFutures = [];
      for (final classRoom in classesAndExchangesImIn) {
        updateFutures
            .add(classRoom.updateMyLearningAnalyticsForClass(storageService));
      }
      await Future.wait(updateFutures);
    } catch (err, s) {
      if (kDebugMode) rethrow;
      // debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
    }
  }

  // Add all the users' analytics room to all the spaces the student studies in
  // So teachers can join them via space hierarchy
  // Will not always work, as there may be spaces where students don't have permission to add chats
  // But allows teachers to join analytics rooms without being invited
  Future<void> _addAnalyticsRoomsToAllSpaces() async {
    final List<Future> addFutures = [];
    for (final Room room in allMyAnalyticsRooms) {
      addFutures.add(room.addAnalyticsRoomToSpaces());
    }
    await Future.wait(addFutures);
  }

  // Invite teachers to all my analytics room
  // Handles case when students cannot add analytics room to space(s)
  // So teacher is still able to get analytics data for this student
  Future<void> _inviteAllTeachersToAllAnalyticsRooms() async {
    final List<Future> inviteFutures = [];
    for (final Room analyticsRoom in allMyAnalyticsRooms) {
      inviteFutures.add(analyticsRoom.inviteTeachersToAnalyticsRoom());
    }
    await Future.wait(inviteFutures);
  }

  // Join all analytics rooms in all spaces
  // Allows teachers to join analytics rooms without being invited
  Future<void> _joinAnalyticsRoomsInAllSpaces() async {
    final List<Future> joinFutures = [];
    for (final Room space in (await _classesAndExchangesImTeaching)) {
      joinFutures.add(space.joinAnalyticsRoomsInSpace());
    }
    await Future.wait(joinFutures);
  }

  // Join invited analytics rooms
  // Checks for invites to any student analytics rooms
  // Handles case of analytics rooms that can't be added to some space(s)
  Future<void> _joinInvitedAnalyticsRooms() async {
    for (final Room room in rooms) {
      if (room.membership == Membership.invite && room.isAnalyticsRoom) {
        try {
          await room.join();
        } catch (err) {
          debugPrint("Failed to join analytics room ${room.id}");
        }
      }
    }
  }

  // helper function to join all relevant analytics rooms
  // and set up those rooms to be joined by relevant teachers
  Future<void> _migrateAnalyticsRooms() async {
    await _updateAnalyticsRoomVisibility();
    await _addAnalyticsRoomsToAllSpaces();
    await _inviteAllTeachersToAllAnalyticsRooms();
    await _joinInvitedAnalyticsRooms();
    await _joinAnalyticsRoomsInAllSpaces();
  }
}
