import 'dart:developer';

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

import '../utils/p_store.dart';

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
    for (final Room space in rooms.where((room) => room.isSpace)) {
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
        if (!teachers.any((e) => e.id == teacher.id)) {
          teachers.add(teacher);
        }
      }
    }
    return teachers;
  }

  Future<void> updateMyLearningAnalyticsForAllClassesImIn([
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
      visibility: Visibility.private,
      roomAliasName: "${userID!.localpart}_${langCode}_analytics",
    );
    if (getRoomById(roomID) == null) {
      // Wait for room actually appears in sync
      await waitForRoomInSync(roomID, join: true);
    }

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
}
