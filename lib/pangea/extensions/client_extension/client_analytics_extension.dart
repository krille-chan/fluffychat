part of "client_extension.dart";

extension AnalyticsClientExtension on Client {
  /// Get the logged in user's analytics room matching
  /// a given langCode. If not present, create it.
  Future<Room?> _getMyAnalyticsRoom(String langCode) async {
    final Room? analyticsRoom = _analyticsRoomLocal(langCode);
    if (analyticsRoom != null) return analyticsRoom;
    return _makeAnalyticsRoom(langCode);
  }

  /// Get local analytics room for a given langCode and
  /// optional userId (if not specified, uses current user).
  /// If user is invited to the room, joins the room.
  Room? _analyticsRoomLocal(String langCode, [String? userIdParam]) {
    final Room? analyticsRoom = rooms.firstWhereOrNull((e) {
      return e.isAnalyticsRoom &&
          e.isAnalyticsRoomOfUser(userIdParam ?? userID!) &&
          e.isMadeForLang(langCode);
    });
    if (analyticsRoom != null &&
        analyticsRoom.membership == Membership.invite) {
      debugger(when: kDebugMode);
      analyticsRoom.join().onError(
            (error, stackTrace) => ErrorHandler.logError(
              e: error,
              s: stackTrace,
              data: {
                "langCode": langCode,
                "userIdParam": userIdParam,
              },
            ),
          );
      return analyticsRoom;
    }
    return analyticsRoom;
  }

  /// Creates an analytics room with the specified language code and returns the created room.
  /// Additionally, the room is added to the user's spaces and all teachers are invited to the room.
  ///
  /// If the room does not appear immediately after creation, this method waits for it to appear in sync.
  /// Returns the created [Room] object.
  Future<Room?> _makeAnalyticsRoom(String langCode) async {
    if (userID == null || userID == BotName.byEnvironment) {
      return null;
    }

    final String roomID = await createRoom(
      creationContent: {
        'type': PangeaRoomTypes.analytics,
        ModelKey.langCode: langCode,
      },
      name: "$userID $langCode Analytics",
      topic: "This room stores learning analytics for $userID.",
      invite: [
        ...(await myTeachers).map((e) => e.id),
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
    analyticsRoom?.addAnalyticsRoomToSpaces();

    // and invite all teachers to new analytics room
    analyticsRoom?.inviteTeachersToAnalyticsRoom();
    return getRoomById(roomID)!;
  }

  /// Get all my analytics rooms
  List<Room> get _allMyAnalyticsRooms => rooms
      .where(
        (e) => e.isAnalyticsRoomOfUser(userID!),
      )
      .toList();

  // migration function to change analytics rooms' vsibility to public
  // so they will appear in the space hierarchy
  Future<void> _updateAnalyticsRoomVisibility() async {
    if (userID == null || userID == BotName.byEnvironment) return;
    await Future.wait(
      allMyAnalyticsRooms.map((room) async {
        final visability = await getRoomVisibilityOnDirectory(room.id);
        if (visability != Visibility.public) {
          await setRoomVisibilityOnDirectory(
            room.id,
            visibility: Visibility.public,
          );
        }
      }),
    );
  }

  /// Add all the users' analytics room to all the spaces the user is studying in
  /// so teachers can join them via space hierarchy.
  /// Allows teachers to join analytics rooms without being invited.
  void _addAnalyticsRoomsToAllSpaces() {
    if (userID == null || userID == BotName.byEnvironment) return;
    for (final Room room in allMyAnalyticsRooms) {
      room.addAnalyticsRoomToSpaces();
    }
  }

  /// Invite teachers to all my analytics room.
  /// Handles case when students cannot add analytics room to space(s)
  /// so teacher is still able to get analytics data for this student
  void _inviteAllTeachersToAllAnalyticsRooms() {
    if (userID == null || userID == BotName.byEnvironment) return;
    for (final Room room in allMyAnalyticsRooms) {
      room.inviteTeachersToAnalyticsRoom();
    }
  }

  // Join all analytics rooms in all spaces
  // Allows teachers to join analytics rooms without being invited
  Future<void> _joinAnalyticsRoomsInAllSpaces() async {
    for (final Room space in _spacesImTeaching) {
      // Each call to joinAnalyticsRoomsInSpace calls getSpaceHierarchy, which has a
      // strict rate limit. So we wait a second between each call to prevent a 429 error.
      await Future.delayed(
        const Duration(seconds: 1),
        () => space.joinAnalyticsRoomsInSpace(),
      );
    }
  }

  /// Join invited analytics rooms.
  /// Checks for invites to any student analytics rooms.
  /// Handles case of analytics rooms that can't be added to some space(s).
  void _joinInvitedAnalyticsRooms() {
    Future.wait(
      rooms
          .where(
            (room) =>
                room.membership == Membership.invite && room.isAnalyticsRoom,
          )
          .map(
            (room) => room.join().catchError((err, s) {
              ErrorHandler.logError(
                e: err,
                s: s,
                data: {
                  "roomID": room.id,
                },
              );
            }),
          ),
    );
  }

  /// Helper function to join all relevant analytics rooms
  /// and set up those rooms to be joined by other users.
  void _migrateAnalyticsRooms() {
    _updateAnalyticsRoomVisibility().then((_) {
      _addAnalyticsRoomsToAllSpaces();
      _inviteAllTeachersToAllAnalyticsRooms();
      _joinInvitedAnalyticsRooms();
      _joinAnalyticsRoomsInAllSpaces();
    });
  }
}
