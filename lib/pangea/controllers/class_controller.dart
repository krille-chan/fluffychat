import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
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
      for (final room in _pangeaController
          .matrixState.client.classesAndExchangesImTeaching) {
        classFixes.add(room.setClassPowerlLevels());
      }
      await Future.wait(classFixes);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  void checkForClassCodeAndSubscription(BuildContext context) {
    final String? classCode = _pangeaController.pStoreService.read(
      PLocalKey.cachedClassCodeToJoin,
      addClientIdToKey: false,
    );

    if (classCode != null) {
      _pangeaController.pStoreService.delete(
        PLocalKey.cachedClassCodeToJoin,
        addClientIdToKey: false,
      );
      joinClasswithCode(
        context,
        classCode,
      ).onError(
        (error, stackTrace) =>
            ClassCodeUtil.messageSnack(context, ErrorCopy(context, error).body),
      );
    } else {
      try {
        //question for gabby: why do we need this in two places?
        if (!_pangeaController.subscriptionController.isSubscribed) {
          _pangeaController.subscriptionController.showPaywall(context);
        }
      } catch (err) {
        debugger(when: kDebugMode);
      }
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
      ClassCodeUtil.messageSnack(context, L10n.of(context)!.unableToFindClass);
      return;
    }

    if (Matrix.of(context)
        .client
        .rooms
        .any((room) => room.id == classChunk.roomId)) {
      setActiveSpaceIdInChatListController(classChunk.roomId);
      ClassCodeUtil.messageSnack(context, L10n.of(context)!.alreadyInClass);
      return;
    }
    await _pangeaController.matrixState.client.joinRoom(classChunk.roomId);

    setActiveSpaceIdInChatListController(classChunk.roomId);

    GoogleAnalytics.joinClass(classCode);

    ClassCodeUtil.messageSnack(
      context,
      L10n.of(context)!.welcomeToYourNewClass,
    );

    context.go("/rooms");
    return;
    // P-EPIC
    // prereq - server needs ability to invite to private room. how?
    // does server api have ability with admin token?
    // is application service needed?
    // BE - check class code and if class code is correct, invite student to room
    // FE - look for invite from room and automatically accept
  }
}
