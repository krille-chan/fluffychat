import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import '../utils/bot_name.dart';
import '../utils/firebase_analytics.dart';
import 'base_controller.dart';

class ClassController extends BaseController {
  late PangeaController _pangeaController;

  ClassController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  setActiveSpaceIdInChatListController(String classId) {
    setState(data: {"activeSpaceId": classId});
  }

  Future<void> fixClassPowerLevels() async {
    try {
      final List<Future<void>> classFixes = [];
      final teacherSpaces = await _pangeaController
          .matrixState.client.classesAndExchangesImTeaching;
      for (final room in teacherSpaces) {
        classFixes.add(room.setClassPowerLevels());
      }
      await Future.wait(classFixes);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  Future<void> checkForClassCodeAndSubscription(BuildContext context) async {
    final String? classCode = _pangeaController.pStoreService.read(
      PLocalKey.cachedClassCodeToJoin,
      addClientIdToKey: false,
      local: true,
    );

    if (classCode != null) {
      await _pangeaController.pStoreService.delete(
        PLocalKey.cachedClassCodeToJoin,
        addClientIdToKey: false,
        local: true,
      );
      await joinClasswithCode(
        context,
        classCode,
      ).onError(
        (error, stackTrace) =>
            ClassCodeUtil.messageSnack(context, ErrorCopy(context, error).body),
      );
    }
  }

  /// if not bot chat return
  /// if bot chat, get pangeaClassContext
  /// for all classes not in pangeaClassContext, add bot chat to that class
  /// PTODO - add analytics bot to all chats and have that do this work
  Future<List<Room>> addDirectChatsToClasses(Room room) async {
    if (!room.isDirectChat) return [];
    final List<String> existingParentsIds =
        room.pangeaSpaceParents.map((e) => e.id).toList();
    final List<Room> spaces =
        _pangeaController.matrixState.client.classesAndExchangesImIn;

    //make sure we have the latest participants
    await Future.wait(spaces.map((e) => e.requestParticipants()));

    //get spaces where,
    //other chat participant is the bot OR is in the space AND the chat is not
    final List<Room> spacesToAdd = spaces
        .where(
          (s) =>
              (room.directChatMatrixID == BotName.byEnvironment ||
                  s
                      .getParticipants()
                      .map(
                        (u) => u.id,
                      )
                      .contains(room.directChatMatrixID)) &&
              !existingParentsIds.contains(s.id),
        )
        .toList();

    //set the space child for each space
    return Future.wait(
      spacesToAdd.map((s) => s.setSpaceChild(room.id, suggested: true)),
    ).then((value) => spaces);
  }

  Future<void> joinClasswithCode(BuildContext context, String classCode) async {
    try {
      final QueryPublicRoomsResponse queryPublicRoomsResponse =
          await Matrix.of(context).client.queryPublicRooms(
                limit: 1,
                filter: PublicRoomQueryFilter(genericSearchTerm: classCode),
              );

      final PublicRoomsChunk? classChunk =
          queryPublicRoomsResponse.chunk.firstWhereOrNull((element) {
        return element.canonicalAlias?.replaceAll("#", "").split(":")[0] ==
            classCode;
      });

      if (classChunk == null) {
        ClassCodeUtil.messageSnack(
          context,
          L10n.of(context)!.unableToFindClass,
        );
        return;
      }

      if (_pangeaController.matrixState.client.rooms
          .any((room) => room.id == classChunk.roomId)) {
        setActiveSpaceIdInChatListController(classChunk.roomId);
        ClassCodeUtil.messageSnack(context, L10n.of(context)!.alreadyInClass);
        return;
      }
      await _pangeaController.matrixState.client.joinRoom(classChunk.roomId);
      setActiveSpaceIdInChatListController(classChunk.roomId);
      if (_pangeaController.matrixState.client.getRoomById(classChunk.roomId) ==
          null) {
        await _pangeaController.matrixState.client.waitForRoomInSync(
          classChunk.roomId,
          join: true,
        );
      }

      // add the user's analytics room to this joined space
      // so their teachers can join them via the space hierarchy
      final Room? joinedSpace =
          _pangeaController.matrixState.client.getRoomById(classChunk.roomId);

      // ensure that the user has an analytics room for this space's language
      await joinedSpace?.ensureAnalyticsRoomExists();

      // when possible, add user's analytics room the to space they joined
      await joinedSpace?.addAnalyticsRoomsToSpace();

      // and invite the space's teachers to the user's analytics rooms
      await joinedSpace?.inviteSpaceTeachersToAnalyticsRooms();
      GoogleAnalytics.joinClass(classCode);
      return;
    } catch (err) {
      ClassCodeUtil.messageSnack(
        context,
        ErrorCopy(context, err).body,
      );
    }
    // P-EPIC
    // prereq - server needs ability to invite to private room. how?
    // does server api have ability with admin token?
    // is application service needed?
    // BE - check class code and if class code is correct, invite student to room
    // FE - look for invite from room and automatically accept
  }

  Future<void> addMissingRoomRules(String? roomId) async {
    if (roomId == null) return;
    final Room? room = _pangeaController.matrixState.client.getRoomById(roomId);
    if (room == null) return;

    if (room.classSettings != null && room.pangeaRoomRules == null) {
      try {
        await _pangeaController.matrixState.client.setRoomStateWithKey(
          roomId,
          PangeaEventTypes.rules,
          '',
          PangeaRoomRules().toJson(),
        );
      } catch (err, stack) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(e: err, s: stack);
      }
    }
  }
}
