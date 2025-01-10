import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';

part "client_analytics_extension.dart";
part "general_info_extension.dart";

extension PangeaClient on Client {
// analytics

  /// Get the logged in user's analytics room matching
  /// a given langCode. If not present, create it.
  Future<Room?> getMyAnalyticsRoom(String langCode) async =>
      await _getMyAnalyticsRoom(langCode);

  /// Get local analytics room for a given langCode and
  /// optional userId (if not specified, uses current user).
  /// If user is invited to the room, joins the room.
  Room? analyticsRoomLocal(String langCode, [String? userIdParam]) =>
      _analyticsRoomLocal(langCode, userIdParam);

  List<Room> get allMyAnalyticsRooms => _allMyAnalyticsRooms;

  /// Update the visibility of all analytics rooms to private (do they don't show in search
  /// results) and set the join rules to public (so they come through in space hierarchy response)
  Future<void> updateAnalyticsRoomVisibility() async =>
      _updateAnalyticsRoomVisibility();

  /// Space admins join analytics rooms in spaces via the space hierarchy,
  /// so other members of the space need to add their analytics rooms to the space.
  Future<void> addAnalyticsRoomsToSpaces() async =>
      _addAnalyticsRoomsToSpaces();

  bool isJoinSpaceSyncUpdate(SyncUpdate update) =>
      _isJoinSpaceSyncUpdate(update);

// general_info

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
