import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

extension PangeaClient on Client {
  List<Room> get classes => rooms.where((e) => e.isPangeaClass).toList();

  List<Room> get classesImTeaching => rooms
      .where(
        (e) =>
            e.isPangeaClass &&
            e.ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin,
      )
      .toList();

  Future<List<Room>> get classesAndExchangesImTeaching async {
    final allSpaces = rooms.where((room) => room.isSpace);
    for (final Room space in allSpaces) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              (e.isPangeaClass || e.isExchange) &&
              e.ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  List<Room> get classesImIn => rooms
      .where(
        (e) =>
            e.isPangeaClass &&
            e.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin,
      )
      .toList();

  Future<List<Room>> get classesAndExchangesImStudyingIn async {
    for (final Room space in rooms.where((room) => room.isSpace)) {
      if (space.getState(EventTypes.RoomPowerLevels) == null) {
        await space.postLoad();
      }
    }

    final spaces = rooms
        .where(
          (e) =>
              (e.isPangeaClass || e.isExchange) &&
              e.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin,
        )
        .toList();
    return spaces;
  }

  List<Room> get classesAndExchangesImIn =>
      rooms.where((e) => e.isPangeaClass || e.isExchange).toList();

  Future<List<String>> get teacherRoomIds async {
    final List<String> adminRoomIds = [];
    for (final Room adminSpace in (await classesAndExchangesImTeaching)) {
      adminRoomIds.add(adminSpace.id);
      final children = adminSpace.childrenAndGrandChildren;
      final List<String> adminSpaceRooms = children
          .where((e) => e.roomId != null)
          .map((e) => e.roomId!)
          .toList();
      adminRoomIds.addAll(adminSpaceRooms);
    }
    return adminRoomIds;
  }

  Future<List<User>> get myTeachers async {
    final List<User> teachers = [];
    for (final classRoom in classesAndExchangesImIn) {
      for (final teacher in await classRoom.teachers) {
        // If person requesting list of teachers is a teacher in another classroom, don't add them to the list
        if (!teachers.any((e) => e.id == teacher.id) && userID != teacher.id) {
          teachers.add(teacher);
        }
      }
    }
    return teachers;
  }

  // get analytics room matching targetlanguage
  // if not present, create it and invite teachers of that language
  // set description to let people know what the hell it is
  Future<Room> getMyAnalyticsRoom(String langCode) async {
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
  Room? analyticsRoomLocal(String? langCode, [String? userIdParam]) {
    final Room? analyticsRoom = rooms.firstWhereOrNull((e) {
      return e.isAnalyticsRoom &&
          e.isAnalyticsRoomOfUser(userIdParam ?? userID!) &&
          (langCode != null ? e.isMadeForLang(langCode) : true);
    });
    if (analyticsRoom != null &&
        analyticsRoom.membership == Membership.invite) {
      // debugger(when: kDebugMode);
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

  Future<Room> getReportsDM(User teacher, Room space) async {
    final String roomId = await teacher.startDirectChat(
      enableEncryption: false,
    );
    space.setSpaceChild(
      roomId,
      suggested: false,
    );
    return getRoomById(roomId)!;
  }

  Future<PangeaRoomRules?> get lastUpdatedRoomRules async =>
      (await classesAndExchangesImTeaching)
          .where((space) => space.rulesUpdatedAt != null)
          .sorted(
            (a, b) => b.rulesUpdatedAt!.compareTo(a.rulesUpdatedAt!),
          )
          .firstOrNull
          ?.pangeaRoomRules;

  ClassSettingsModel? get lastUpdatedClassSettings => classesImTeaching
      .where((space) => space.classSettingsUpdatedAt != null)
      .sorted(
        (a, b) =>
            b.classSettingsUpdatedAt!.compareTo(a.classSettingsUpdatedAt!),
      )
      .firstOrNull
      ?.classSettings;

  Future<bool> get hasBotDM async {
    final List<Room> chats = rooms
        .where((room) => !room.isSpace && room.membership == Membership.join)
        .toList();

    for (final Room chat in chats) {
      if (await chat.isBotDM) return true;
    }
    return false;
  }

  Future<List<String>> getEditHistory(
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

    final Timeline timeline = await room.getTimeline();
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

  // Get all my analytics rooms
  List<Room> get allMyAnalyticsRooms => rooms
      .where(
        (e) => e.isAnalyticsRoomOfUser(userID!),
      )
      .toList();

  // migration function to change analytics rooms' vsibility to public
  // so they will appear in the space hierarchy
  Future<void> updateAnalyticsRoomVisibility() async {
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

  // Add all the users' analytics room to all the spaces the student studies in
  // So teachers can join them via space hierarchy
  // Will not always work, as there may be spaces where students don't have permission to add chats
  // But allows teachers to join analytics rooms without being invited
  Future<void> addAnalyticsRoomsToAllSpaces() async {
    final List<Future> addFutures = [];
    for (final Room room in allMyAnalyticsRooms) {
      addFutures.add(room.addAnalyticsRoomToSpaces());
    }
    await Future.wait(addFutures);
  }

  // Invite teachers to all my analytics room
  // Handles case when students cannot add analytics room to space(s)
  // So teacher is still able to get analytics data for this student
  Future<void> inviteAllTeachersToAllAnalyticsRooms() async {
    final List<Future> inviteFutures = [];
    for (final Room analyticsRoom in allMyAnalyticsRooms) {
      inviteFutures.add(analyticsRoom.inviteTeachersToAnalyticsRoom());
    }
    await Future.wait(inviteFutures);
  }

  // Join all analytics rooms in all spaces
  // Allows teachers to join analytics rooms without being invited
  Future<void> joinAnalyticsRoomsInAllSpaces() async {
    final List<Future> joinFutures = [];
    for (final Room space in (await classesAndExchangesImTeaching)) {
      joinFutures.add(space.joinAnalyticsRoomsInSpace());
    }
    await Future.wait(joinFutures);
  }

  // Join invited analytics rooms
  // Checks for invites to any student analytics rooms
  // Handles case of analytics rooms that can't be added to some space(s)
  Future<void> joinInvitedAnalyticsRooms() async {
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
  Future<void> migrateAnalyticsRooms() async {
    await updateAnalyticsRoomVisibility();
    await addAnalyticsRoomsToAllSpaces();
    await inviteAllTeachersToAllAnalyticsRooms();
    await joinInvitedAnalyticsRooms();
    await joinAnalyticsRoomsInAllSpaces();
  }
}
