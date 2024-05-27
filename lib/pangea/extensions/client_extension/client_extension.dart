import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../../utils/p_store.dart';

part "analytics_extension.dart";
part "classes_and_exchanges_extension.dart";
part "general_info_extension.dart";

extension PangeaClient on Client {
// analytics

  Future<Room> getMyAnalyticsRoom(String langCode) async =>
      await _getMyAnalyticsRoom(langCode);

  Room? analyticsRoomLocal(String? langCode, [String? userIdParam]) =>
      _analyticsRoomLocal(langCode, userIdParam);

  List<Room> get allMyAnalyticsRooms => _allMyAnalyticsRooms;

  Future<void> updateAnalyticsRoomVisibility() async =>
      await _updateAnalyticsRoomVisibility();

  Future<void> updateMyLearningAnalyticsForAllClassesImIn([
    PLocalStore? storageService,
  ]) async =>
      await _updateMyLearningAnalyticsForAllClassesImIn(storageService);

  Future<void> addAnalyticsRoomsToAllSpaces() async =>
      await _addAnalyticsRoomsToAllSpaces();

  Future<void> inviteAllTeachersToAllAnalyticsRooms() async =>
      await _inviteAllTeachersToAllAnalyticsRooms();

  Future<void> joinAnalyticsRoomsInAllSpaces() async =>
      await _joinAnalyticsRoomsInAllSpaces();

  Future<void> joinInvitedAnalyticsRooms() async =>
      await _joinInvitedAnalyticsRooms();

  Future<void> migrateAnalyticsRooms() async => await _migrateAnalyticsRooms();

  // classes_and_exchanges

  List<Room> get classes => _classes;

  List<Room> get classesImTeaching => _classesImTeaching;

  Future<List<Room>> get classesAndExchangesImTeaching async =>
      await _classesAndExchangesImTeaching;

  List<Room> get classesImIn => _classesImIn;

  Future<List<Room>> get classesAndExchangesImStudyingIn async =>
      await _classesAndExchangesImStudyingIn;

  List<Room> get classesAndExchangesImIn => _classesAndExchangesImIn;

  Future<PangeaRoomRules?> get lastUpdatedRoomRules async =>
      await _lastUpdatedRoomRules;

  ClassSettingsModel? get lastUpdatedClassSettings => _lastUpdatedClassSettings;

// general_info

  Future<List<String>> get teacherRoomIds async => await _teacherRoomIds;

  Future<List<User>> get myTeachers async => await _myTeachers;

  Future<Room> getReportsDM(User teacher, Room space) async =>
      await _getReportsDM(teacher, space);

  Future<bool> get hasBotDM async => await _hasBotDM;

  Future<List<String>> getEditHistory(
    String roomId,
    String eventId,
  ) async =>
      await _getEditHistory(roomId, eventId);
}
