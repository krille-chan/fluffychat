import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension AnalyticsClientExtension on Client {
  /// Get the logged in user's analytics room matching
  /// a given langCode. If not present, create it.
  Future<Room?> getMyAnalyticsRoom(LanguageModel lang) async {
    final Room? analyticsRoom = analyticsRoomLocal(lang);
    if (analyticsRoom != null) return analyticsRoom;
    return _makeAnalyticsRoom(lang);
  }

  /// Get local analytics room for a given langCode and
  /// optional userId (if not specified, uses current user).
  /// If user is invited to the room, joins the room.
  Room? analyticsRoomLocal([LanguageModel? lang, String? userIdParam]) {
    lang ??= MatrixState.pangeaController.languageController.userL2;

    if (lang == null) {
      debugger(when: kDebugMode);
      return null;
    }

    final Room? analyticsRoom = rooms.firstWhereOrNull((e) {
      return e.isAnalyticsRoom &&
          e.isAnalyticsRoomOfUser(userIdParam ?? userID!) &&
          e.isMadeForLang(lang!.langCodeShort);
    });
    if (analyticsRoom != null &&
        analyticsRoom.membership == Membership.invite) {
      debugger(when: kDebugMode);
      analyticsRoom.join().onError(
            (error, stackTrace) => ErrorHandler.logError(
              e: error,
              s: stackTrace,
              data: {
                "langCode": lang!.langCodeShort,
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
  Future<Room?> _makeAnalyticsRoom(LanguageModel lang) async {
    if (userID == null || userID == BotName.byEnvironment) {
      return null;
    }

    final String roomID = await createRoom(
      creationContent: {
        'type': PangeaRoomTypes.analytics,
        ModelKey.langCode: lang.langCodeShort,
      },
      name: "$userID ${lang.langCodeShort} Analytics",
      topic: "This room stores learning analytics for $userID.",
      preset: CreateRoomPreset.publicChat,
      visibility: Visibility.private,
    );
    if (getRoomById(roomID) == null) {
      // Wait for room actually appears in sync
      await waitForRoomInSync(roomID, join: true);
    }

    addAnalyticsRoomsToSpaces();
    return getRoomById(roomID)!;
  }

  /// Get all my analytics rooms
  List<Room> get allMyAnalyticsRooms => rooms
      .where(
        (e) => e.isAnalyticsRoomOfUser(userID!),
      )
      .toList();

  /// Update the join rules of all analytics rooms to 'knock'.
  Future<void> updateAnalyticsRoomJoinRules() async {
    if (prevBatch == null) await onSync.stream.first;
    if (userID == null || userID == BotName.byEnvironment) return;
    final Random random = Random();

    for (final analyticsRoom in allMyAnalyticsRooms) {
      if (!isLogged()) return;
      if (analyticsRoom.joinRules == JoinRules.knock) continue;

      await analyticsRoom.setJoinRules(JoinRules.knock);
      await Future.delayed(Duration(seconds: random.nextInt(10)));
    }
  }

  /// Space admins join analytics rooms in spaces via the space hierarchy,
  /// so other members of the space need to add their analytics rooms to the space.
  Future<void> addAnalyticsRoomsToSpaces() async {
    if (userID == null || userID == BotName.byEnvironment) return;
    final spaces = rooms
        .where(
          (room) => room.isSpace && room.membership == Membership.join,
        )
        .toList();

    final Random random = Random();
    for (final space in spaces) {
      if (userID == null || !space.canSendEvent(EventTypes.SpaceChild)) return;
      final List<Room> roomsNotAdded = allMyAnalyticsRooms.where((room) {
        return !space.spaceChildren.any((child) => child.roomId == room.id);
      }).toList();

      if (roomsNotAdded.isEmpty) continue;

      for (final analyticsRoom in roomsNotAdded) {
        if (userID == null) return;
        try {
          await space.setSpaceChild(analyticsRoom.id);
        } catch (e, s) {
          ErrorHandler.logError(
            e: e,
            s: s,
            data: {
              "spaceID": space.id,
              "analyticsRoomID": analyticsRoom.id,
              "userID": userID,
            },
          );
        }
      }

      // add a delay before checking the next space to prevent overloading the server
      final delay = random.nextInt(10);
      debugPrint(
        "added ${roomsNotAdded.length} rooms to space ${space.id}, delay: $delay",
      );
      await Future.delayed(Duration(seconds: delay));
    }
  }

  /// Check if sync update includes newly joined room. Used by the
  /// GetAnalyticsController to add analytics rooms to newly joined spaces.
  bool isJoinSpaceSyncUpdate(SyncUpdate update) {
    if (update.rooms?.join == null) return false;
    return update.rooms!.join!.values
        .where(
          (e) =>
              e.state != null &&
              e.state!.any(
                (e) =>
                    e.type == EventTypes.RoomCreate &&
                    e.content['type'] == 'm.space',
              ),
        )
        .isNotEmpty;
  }
}
