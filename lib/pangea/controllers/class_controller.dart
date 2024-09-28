import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/space_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import '../utils/firebase_analytics.dart';
import 'base_controller.dart';

class ClassController extends BaseController {
  late PangeaController _pangeaController;

  ClassController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  setActiveSpaceIdInChatListController(String? classId) {
    setState({"activeSpaceId": classId});
  }

  /// For all the spaces that the user is teaching, set the power levels
  /// to enable all other users to add child rooms to the space.
  void fixClassPowerLevels() {
    Future.wait(
      _pangeaController.matrixState.client.spacesImTeaching.map(
        (space) => space.setClassPowerLevels().catchError((err, s) {
          ErrorHandler.logError(e: err, s: s);
        }),
      ),
    );
  }

  Future<void> checkForClassCodeAndSubscription(BuildContext context) async {
    final String? classCode = _pangeaController.pStoreService.read(
      PLocalKey.cachedClassCodeToJoin,
      isAccountData: false,
    );

    if (classCode != null) {
      await _pangeaController.pStoreService.delete(
        PLocalKey.cachedClassCodeToJoin,
        isAccountData: false,
      );
      await joinClasswithCode(
        context,
        classCode,
      ).onError(
        (error, stackTrace) =>
            SpaceCodeUtil.messageSnack(context, ErrorCopy(context, error).body),
      );
    }
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
        SpaceCodeUtil.messageSnack(
          context,
          L10n.of(context)!.unableToFindClass,
        );
        return;
      }

      if (_pangeaController.matrixState.client.rooms
          .any((room) => room.id == classChunk.roomId)) {
        setActiveSpaceIdInChatListController(classChunk.roomId);
        SpaceCodeUtil.messageSnack(context, L10n.of(context)!.alreadyInClass);
        return;
      }

      await _pangeaController.matrixState.client.joinRoom(classChunk.roomId);

      if (_pangeaController.matrixState.client.getRoomById(classChunk.roomId) ==
          null) {
        await _pangeaController.matrixState.client.waitForRoomInSync(
          classChunk.roomId,
          join: true,
        );
      }

      // If the room is full, leave
      final room =
          _pangeaController.matrixState.client.getRoomById(classChunk.roomId);
      if (room == null) {
        return;
      }
      final joinResult = await showFutureLoadingDialog(
        context: context,
        future: () async {
          if (await room.leaveIfFull()) {
            throw L10n.of(context)!.roomFull;
          }
        },
      );
      if (joinResult.error != null) {
        return;
      }

      setActiveSpaceIdInChatListController(classChunk.roomId);

      // add the user's analytics room to this joined space
      // so their teachers can join them via the space hierarchy
      final Room? joinedSpace =
          _pangeaController.matrixState.client.getRoomById(classChunk.roomId);

      // when possible, add user's analytics room the to space they joined
      joinedSpace?.addAnalyticsRoomsToSpace();

      // and invite the space's teachers to the user's analytics rooms
      joinedSpace?.inviteSpaceTeachersToAnalyticsRooms();
      GoogleAnalytics.joinClass(classCode);
      return;
    } catch (err) {
      SpaceCodeUtil.messageSnack(
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

    if (room.isSpace && room.isRoomAdmin && room.pangeaRoomRules == null) {
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
