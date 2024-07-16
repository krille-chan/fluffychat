import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

part "client_analytics_extension.dart";
part "general_info_extension.dart";
part "space_extension.dart";

extension PangeaClient on Client {
// analytics

  Future<Room> getMyAnalyticsRoom(String langCode) async =>
      await _getMyAnalyticsRoom(langCode);

  Room? analyticsRoomLocal(String? langCode, [String? userIdParam]) =>
      _analyticsRoomLocal(langCode, userIdParam);

  List<Room> get allMyAnalyticsRooms => _allMyAnalyticsRooms;

  Future<void> updateAnalyticsRoomVisibility() async =>
      await _updateAnalyticsRoomVisibility();

  Future<void> addAnalyticsRoomsToAllSpaces() async =>
      await _addAnalyticsRoomsToAllSpaces();

  Future<void> inviteAllTeachersToAllAnalyticsRooms() async =>
      await _inviteAllTeachersToAllAnalyticsRooms();

  Future<void> joinAnalyticsRoomsInAllSpaces() async =>
      await _joinAnalyticsRoomsInAllSpaces();

  Future<void> joinInvitedAnalyticsRooms() async =>
      await _joinInvitedAnalyticsRooms();

  Future<void> migrateAnalyticsRooms() async => await _migrateAnalyticsRooms();

  Future<Map<String, DateTime?>> allAnalyticsRoomsLastUpdated() async =>
      await _allAnalyticsRoomsLastUpdated();

  // spaces

  Future<List<Room>> get spacesImTeaching async => await _spacesImTeaching;

  Future<List<Room>> get chatsImAStudentIn async => await _chatsImAStudentIn;

  Future<List<Room>> get spaceImAStudentIn async => await _spacesImStudyingIn;

  List<Room> get spacesImIn => _spacesImIn;

  Future<PangeaRoomRules?> get lastUpdatedRoomRules async =>
      await _lastUpdatedRoomRules;

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

  String? powerLevelName(int powerLevel, L10n l10n) =>
      _powerLevelName(powerLevel, l10n);

  Future<void> waitForAccountData() async => await _waitForAccountData();
}
