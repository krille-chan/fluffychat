import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/controllers/base_controller.dart';

class ClassController extends BaseController {
  late PangeaController _pangeaController;

  ClassController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  static final GetStorage _aliasStorage = GetStorage('alias_storage');

  void setActiveSpaceIdInChatListController(String? classId) {
    setState({"activeSpaceId": classId});
  }

  Future<void> joinCachedSpaceCode(BuildContext context) async {
    final String? classCode = _pangeaController.pStoreService.read(
      PLocalKey.cachedClassCodeToJoin,
      isAccountData: false,
    );

    final String? alias = _aliasStorage.read(PLocalKey.cachedAliasToJoin);

    if (classCode != null) {
      await joinClasswithCode(
        context,
        classCode,
      );

      await _pangeaController.pStoreService.delete(
        PLocalKey.cachedClassCodeToJoin,
        isAccountData: false,
      );
    } else if (alias != null) {
      await joinCachedRoomAlias(alias, context);
      await _aliasStorage.remove(PLocalKey.cachedAliasToJoin);
    }
  }

  Future<void> joinCachedRoomAlias(
    String alias,
    BuildContext context,
  ) async {
    if (alias.isEmpty) {
      context.go("/rooms");
      return;
    }

    final client = Matrix.of(context).client;
    if (!client.isLogged()) {
      await _aliasStorage.write(PLocalKey.cachedAliasToJoin, alias);
      context.go("/home");
      return;
    }

    Room? room = client.getRoomByAlias(alias) ?? client.getRoomById(alias);
    if (room != null) {
      room.isSpace
          ? context.push("/rooms/${room.id}/details")
          : context.go("/rooms/${room.id}");
      return;
    }

    final roomID = await client.joinRoom(alias);
    room = client.getRoomById(roomID);
    if (room == null) {
      await client.waitForRoomInSync(roomID);
      room = client.getRoomById(roomID);
      if (room == null) {
        context.go("/rooms");
        return;
      }
    }

    room.isSpace
        ? context.push("/rooms/${room.id}/details")
        : context.go("/rooms/${room.id}");
  }

  Future<void> joinClasswithCode(
    BuildContext context,
    String classCode, {
    String? notFoundError,
  }) async {
    final client = Matrix.of(context).client;
    final spaceID = await showFutureLoadingDialog<String?>(
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
          throw L10n.of(context).tooManyRequest;
        }
        if (knockResponse.statusCode != 200) {
          throw notFoundError ?? L10n.of(context).unableToFindClass;
        }

        final knockResult = jsonDecode(knockResponse.body);
        final foundClasses = List<String>.from(knockResult['rooms']);
        final alreadyJoined = List<String>.from(knockResult['already_joined']);

        final bool inFoundClass = foundClasses.isNotEmpty &&
            _pangeaController.matrixState.client.rooms.any(
              (room) => room.id == foundClasses.first,
            );

        if (alreadyJoined.isNotEmpty || inFoundClass) {
          context.push("/rooms/${alreadyJoined.first}/details");
          throw L10n.of(context).alreadyInClass;
        }

        if (foundClasses.isEmpty) {
          throw notFoundError ?? L10n.of(context).unableToFindClass;
        }

        final chosenClassId = foundClasses.first;
        await _pangeaController.pStoreService.save(
          PLocalKey.justInputtedCode,
          classCode,
          isAccountData: false,
        );
        return chosenClassId;
      },
    );

    if (spaceID.isError || spaceID.result == null) return;

    try {
      await client.joinRoomById(spaceID.result!);

      Room? room = client.getRoomById(spaceID.result!);
      if (room == null) {
        await _pangeaController.matrixState.client.waitForRoomInSync(
          spaceID.result!,
          join: true,
        );
        room = client.getRoomById(spaceID.result!);
        if (room == null) return;
      }

      final isFull = await room.leaveIfFull();
      if (isFull) {
        await showFutureLoadingDialog(
          context: context,
          future: () async => throw L10n.of(context).roomFull,
        );
        return;
      }

      GoogleAnalytics.joinClass(classCode);

      if (room.client.getRoomById(room.id)?.membership != Membership.join) {
        await room.client.waitForRoomInSync(room.id, join: true);
      }

      context.push("/rooms/${room.id}/details");
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "classCode": classCode,
        },
      );
    }

    // P-EPIC
    // prereq - server needs ability to invite to private room. how?
    // does server api have ability with admin token?
    // is application service needed?
    // BE - check class code and if class code is correct, invite student to room
    // FE - look for invite from room and automatically accept
  }
}
