part of "../extensions/pangea_room_extension.dart";

extension AnalyticsRoomExtension on Room {
  /// Get next n analytics rooms via the space hierarchy
  ///     If joined
  ///       If not in target language
  ///           If not created by user, leave
  ///       Else, add to list
  ///     Else
  ///       If room name does not match L2, skip
  ///       Join and wait for room in sync.
  ///     Repeat the same procedure as above.
  ///
  /// If not n analytics rooms in list, and nextBatch != null, repeat the above
  /// procedure with nextBatch until n analytics rooms are found or nextBatch == null
  ///
  /// Yield this list of rooms.
  /// Once analytics have been retrieved, leave analytics rooms not created by self.
  Stream<List<Room>> getNextAnalyticsRoomBatch(String userL2) async* {
    final List<SpaceRoomsChunk> rooms = [];
    String? nextBatch;
    int spaceHierarchyCalls = 0;
    int callsToServer = 0;

    while (spaceHierarchyCalls <= 5 &&
        (nextBatch != null || spaceHierarchyCalls == 0)) {
      spaceHierarchyCalls++;
      final resp = await _getNextBatch(nextBatch);
      callsToServer++;
      if (resp == null) return;

      rooms.addAll(resp.rooms);
      nextBatch = resp.nextBatch;

      final List<Room> roomsBatch = [];
      while (rooms.isNotEmpty) {
        // prevent rate-limiting
        if (callsToServer >= 5) {
          callsToServer = 0;
          await Future.delayed(const Duration(milliseconds: 7500));
        }

        final nextRoomChunk = rooms.removeAt(0);
        if (nextRoomChunk.roomType != PangeaRoomTypes.analytics) {
          continue;
        }

        final matchingRoom = client.rooms.firstWhereOrNull(
          (r) => r.id == nextRoomChunk.roomId,
        );

        final (analyticsRoom, calls) = matchingRoom != null
            ? await _handleJoinedAnalyticsRoom(matchingRoom, userL2)
            : await _handleUnjoinedAnalyticsRoom(nextRoomChunk, userL2);

        callsToServer += calls;
        if (analyticsRoom == null) continue;
        roomsBatch.add(analyticsRoom);

        if (roomsBatch.length >= 5) {
          final roomsBatchCopy = List<Room>.from(roomsBatch);
          roomsBatch.clear();
          yield roomsBatchCopy;
        }
      }

      yield roomsBatch;
    }
  }

  /// Return analytics room, given unjoined member of space hierarchy,
  /// if should get analytics for that room, and number of call made
  /// to the server to help prevent rate-limiting
  Future<(Room?, int)> _handleUnjoinedAnalyticsRoom(
    SpaceRoomsChunk chunk,
    String l2,
  ) async {
    int callsToServer = 0;
    final nameParts = chunk.name?.split(" ");
    if (nameParts != null && nameParts.length >= 2) {
      final roomLangCode = nameParts[1];
      if (roomLangCode != l2) return (null, callsToServer);
    }

    Room? analyticsRoom = await _joinAnalyticsRoomChunk(chunk);
    callsToServer++;

    if (analyticsRoom == null) return (null, callsToServer);
    final (room, calls) = await _handleJoinedAnalyticsRoom(analyticsRoom, l2);
    analyticsRoom = room;
    callsToServer += calls;

    return (analyticsRoom, callsToServer);
  }

  /// Return analytics room if should add to returned list
  /// and the number of calls made to the server (used to prevent rate-limiting)
  Future<(Room?, int)> _handleJoinedAnalyticsRoom(
    Room analyticsRoom,
    String l2,
  ) async {
    if (client.userID == null) return (null, 0);
    if (analyticsRoom.madeForLang != l2) {
      await _leaveNonTargetAnalyticsRoom(analyticsRoom, l2);
      return (null, 1);
    }
    return (analyticsRoom, 0);
  }

  Future<Room?> _joinAnalyticsRoomChunk(
    SpaceRoomsChunk chunk,
  ) async {
    final matchingRoom = client.rooms.firstWhereOrNull(
      (r) => r.id == chunk.roomId,
    );
    if (matchingRoom != null) return matchingRoom;

    try {
      final syncFuture = client.waitForRoomInSync(chunk.roomId, join: true);
      await client.joinRoom(chunk.roomId);
      await syncFuture;
      return client.getRoomById(chunk.roomId);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": chunk.roomId,
        },
      );
      return null;
    }
  }

  Future<void> _leaveNonTargetAnalyticsRoom(Room room, String userL2) async {
    if (client.userID == null ||
        room.isMadeByUser(client.userID!) ||
        room.madeForLang == userL2) {
      return;
    }

    try {
      await room.leave();
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": room.id,
        },
      );
    }
  }

  Future<GetSpaceHierarchyResponse?> _getNextBatch(String? nextBatch) async {
    try {
      final resp = await client.getSpaceHierarchy(
        id,
        from: nextBatch,
        limit: 100,
        maxDepth: 1,
      );
      return resp;
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "spaceID": id,
          "nextBatch": nextBatch,
        },
      );
      return null;
    }
  }

  Future<DateTime?> analyticsLastUpdated(String userId) async {
    final List<Event> events =
        await getRoomAnalyticsEvents(count: 1, userID: userId);
    if (events.isEmpty) return null;
    return events.first.originServerTs;
  }

  Future<List<ConstructAnalyticsEvent>?> getAnalyticsEvents({
    required String userId,
    DateTime? since,
  }) async {
    final events = await getRoomAnalyticsEvents(userID: userId);
    final List<ConstructAnalyticsEvent> analyticsEvents = [];
    for (final Event event in events) {
      analyticsEvents.add(ConstructAnalyticsEvent(event: event));
    }

    return analyticsEvents;
  }

  String? get madeForLang {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) ??
        creationContent?.tryGet<String>(ModelKey.oldLangCode);
  }

  bool isMadeForLang(String langCode) {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) == langCode ||
        creationContent?.tryGet<String>(ModelKey.oldLangCode) == langCode;
  }

  /// Sends construct events to the server.
  ///
  /// The [uses] parameter is a list of [OneConstructUse] objects representing the
  /// constructs to be sent. To prevent hitting the maximum event size, the events
  /// are chunked into smaller lists. Each chunk is sent as a separate event.
  Future<void> sendConstructsEvent(
    List<OneConstructUse> uses,
  ) async {
    // It's possible that the user has no info to send yet, but to prevent trying
    // to load the data over and over again, we'll sometimes send an empty event to
    // indicate that we have checked and there was no data.
    if (uses.isEmpty) {
      final constructsModel = ConstructAnalyticsModel(uses: []);
      await sendEvent(
        constructsModel.toJson(),
        type: PangeaEventTypes.construct,
      );
      return;
    }

    // these events can get big, so we chunk them to prevent hitting the max event size.
    // go through each of the uses being sent and add them to the current chunk until
    // the size (in bytes) of the current chunk is greater than the max event size, then
    // start a new chunk until all uses have been added.
    final List<List<OneConstructUse>> useChunks = [];
    List<OneConstructUse> currentChunk = [];
    int currentChunkSize = 0;

    for (final use in uses) {
      // get the size, in bytes, of the json representation of the use
      final json = use.toJson();
      final jsonString = jsonEncode(json);
      final jsonSizeInBytes = utf8.encode(jsonString).length;

      // If this use would tip this chunk over the size limit,
      // add it to the list of all chunks and start a new chunk.
      //
      // I tested with using the maxPDUSize constant, but the events
      // were still too large. 50000 seems to be a safe number of bytes.
      if (currentChunkSize + jsonSizeInBytes > (maxPDUSize - 10000)) {
        useChunks.add(currentChunk);
        currentChunk = [];
        currentChunkSize = 0;
      }

      // add this use to the current chunk
      currentChunk.add(use);
      currentChunkSize += jsonSizeInBytes;
    }

    if (currentChunk.isNotEmpty) {
      useChunks.add(currentChunk);
    }

    for (final chunk in useChunks) {
      final constructsModel = ConstructAnalyticsModel(uses: chunk);
      await sendEvent(
        constructsModel.toJson(),
        type: PangeaEventTypes.construct,
      );
    }
  }
}
