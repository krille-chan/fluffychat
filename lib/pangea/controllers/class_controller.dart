import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

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

  Future<void> joinCachedSpaceCode(BuildContext context) async {
    final String? classCode = _pangeaController.pStoreService.read(
      PLocalKey.cachedClassCodeToJoin,
      isAccountData: false,
    );

    if (classCode != null) {
      await joinClasswithCode(
        context,
        classCode,
      );

      await _pangeaController.pStoreService.delete(
        PLocalKey.cachedClassCodeToJoin,
        isAccountData: false,
      );
    }
  }

  Future<void> joinClasswithCode(BuildContext context, String classCode) async {
    final client = Matrix.of(context).client;
    final space = await showFutureLoadingDialog<Room?>(
      context: context,
      future: () async {
        final knockResponse = await client.httpClient.post(
          Uri.parse(
            '${client.homeserver}/_synapse/client/pangea/v1/knock_with_code',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${client.accessToken}',
          },
          body: jsonEncode({'access_code': classCode}),
        );

        if (knockResponse.statusCode == 429) {
          throw L10n.of(context)!.tooManyRequest;
        }
        if (knockResponse.statusCode != 200) {
          throw L10n.of(context)!.unableToFindClass;
        }

        final knockResult = jsonDecode(knockResponse.body);
        final foundClasses = List<String>.from(knockResult['rooms']);
        final alreadyJoined = List<String>.from(knockResult['already_joined']);

        final bool inFoundClass = foundClasses.isNotEmpty &&
            _pangeaController.matrixState.client.rooms.any(
              (room) => room.id == foundClasses.first,
            );

        if (alreadyJoined.isNotEmpty || inFoundClass) {
          context.go("/rooms/${alreadyJoined.first}/details");
          throw L10n.of(context)!.alreadyInClass;
        }

        if (foundClasses.isEmpty) {
          throw L10n.of(context)!.unableToFindClass;
        }

        final chosenClassId = foundClasses.first;
        await _pangeaController.pStoreService.save(
          PLocalKey.justInputtedCode,
          classCode,
          isAccountData: false,
        );

        await client.joinRoomById(chosenClassId);
        _pangeaController.pStoreService.delete(PLocalKey.justInputtedCode);

        Room? room = client.getRoomById(chosenClassId);
        if (room == null) {
          await _pangeaController.matrixState.client.waitForRoomInSync(
            chosenClassId,
            join: true,
          );
          room = client.getRoomById(chosenClassId);
          if (room == null) return null;
        }
        return room;
      },
    );
    if (space.isError || space.result == null) return;
    final room = space.result!;
    await room.join();
    final isFull = await room.leaveIfFull();
    if (isFull) {
      await showFutureLoadingDialog(
        context: context,
        future: () async => throw L10n.of(context)!.roomFull,
      );
      return;
    }

    // when possible, add user's analytics room the to space they joined
    room.addAnalyticsRoomsToSpace();

    // and invite the space's teachers to the user's analytics rooms
    room.inviteSpaceTeachersToAnalyticsRooms();
    GoogleAnalytics.joinClass(classCode);

    if (room.client.getRoomById(room.id)?.membership != Membership.join) {
      await room.client.waitForRoomInSync(room.id, join: true);
    }

    context.go("/rooms/${room.id}/details");
    return;
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
