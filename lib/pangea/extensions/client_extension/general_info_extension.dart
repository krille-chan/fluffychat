part of "client_extension.dart";

extension GeneralInfoClientExtension on Client {
  Future<List<User>> get _myTeachers async {
    final List<User> teachers = [];
    final spaces = rooms.where((room) => room.isSpace);
    for (final classRoom in spaces) {
      for (final teacher in await classRoom.teachers) {
        // If person requesting list of teachers is a teacher in another classroom, don't add them to the list
        if (!teachers.any((e) => e.id == teacher.id) && userID != teacher.id) {
          teachers.add(teacher);
        }
      }
    }
    return teachers;
  }

  Future<Room> _getReportsDM(User teacher, Room space) async {
    final String roomId = await teacher.startDirectChat(
      enableEncryption: false,
    );
    space.setSpaceChild(
      roomId,
      suggested: false,
    );
    return getRoomById(roomId)!;
  }

  Future<bool> get _hasBotDM async {
    final List<Room> chats = rooms
        .where((room) => !room.isSpace && room.membership == Membership.join)
        .toList();

    for (final Room chat in chats) {
      if (await chat.isBotDM) return true;
    }
    return false;
  }

  Future<List<String>> _getEditHistory(
    String roomId,
    String eventId,
  ) async {
    final Room? room = getRoomById(roomId);
    final Event? editEvent = await room?.getEventById(eventId);
    final String? edittedEventId =
        editEvent?.content.tryGetMap('m.relates_to')?['event_id'];
    if (edittedEventId == null) return [];

    final Event? originalEvent = await room!.getEventById(edittedEventId);
    if (originalEvent == null) return [];

    final Timeline timeline = room.timeline ?? await room.getTimeline();
    final List<Event> editEvents = originalEvent
        .aggregatedEvents(
          timeline,
          RelationshipTypes.edit,
        )
        .sorted(
          (a, b) => b.originServerTs.compareTo(a.originServerTs),
        )
        .toList();
    editEvents.add(originalEvent);
    return editEvents.slice(1).map((e) => e.eventId).toList();
  }

  String? _powerLevelName(int powerLevel, L10n l10n) => {
        0: l10n.user,
        50: l10n.moderator,
        100: l10n.admin,
      }[powerLevel];

  /// Account data comes through in the first sync, so wait for that
  Future<void> _waitForAccountData() async {
    if (prevBatch == null) {
      await onSync.stream.first;
    }
  }
}
