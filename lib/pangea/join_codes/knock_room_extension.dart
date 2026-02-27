import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/join_codes/knocked_rooms_model.dart';

extension KnockRoomExtension on Room {
  bool get hasKnocked => client.hasKnockedRoom(id);

  Future<void> joinKnockedRoom() async {
    await join();
    await client.onJoinKnockedRoom(id);
  }
}

extension KnockClientExtension on Client {
  KnockedRoomsModel get _knockedRooms {
    final data = accountData[PangeaEventTypes.knockedRooms];
    if (data != null) {
      return KnockedRoomsModel.fromJson(data.content);
    }
    return const KnockedRoomsModel();
  }

  Future<void> _setKnockedRooms(KnockedRoomsModel model) async {
    final prevModel = _knockedRooms;
    if (model == prevModel) {
      Logs().w('Knocked rooms model is the same as previous, skipping write.');
      Logs().w('Model: ${model.toJson()}');
      Logs().w('Previous Model: ${prevModel.toJson()}');
      return;
    }

    await setAccountData(
      userID!,
      PangeaEventTypes.knockedRooms,
      model.toJson(),
    );

    final updatedModel = _knockedRooms;
    if (model == updatedModel) {
      try {
        await onSync.stream
            .firstWhere((sync) => sync.accountData != null)
            .timeout(Duration(seconds: 10));
      } catch (e, s) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            'client_user_id': userID,
            'expected_ids': model.toJson(),
            'updated_ids': updatedModel.toJson(),
          },
          level: e is TimeoutException
              ? SentryLevel.warning
              : SentryLevel.error,
        );
      }
    }
  }

  Future<String> knockAndRecordRoom(
    String roomIdOrAlias, {
    List<String>? via,
    String? reason,
  }) async {
    final resp = await knockRoom(roomIdOrAlias, via: via, reason: reason);
    final updatedModel = _knockedRooms.copyWithKnockedRoom(roomIdOrAlias);
    await _setKnockedRooms(updatedModel);
    return resp;
  }

  Future<void> onJoinKnockedRoom(String roomId) async {
    final updatedModel = _knockedRooms.copyWithAcceptedInviteRoom(roomId);
    await _setKnockedRooms(updatedModel);
  }

  bool hasKnockedRoom(String roomId) {
    return _knockedRooms.knockedRoomIds.contains(roomId);
  }

  bool hasEverKnockedRoom(String roomId) {
    return hasKnockedRoom(roomId) ||
        _knockedRooms.acceptedInviteRoomIds.contains(roomId);
  }

  List<String> get knockedRoomIds => _knockedRooms.knockedRoomIds;
}
