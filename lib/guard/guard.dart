import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluffychat/widgets/matrix.dart';

FutureOr<String?> powerLevelRedirect(
  BuildContext context,
  GoRouterState state, {
  int minPowerLevel = 100,
  String? fallbackRoute,
  String noRoomRedirect = '/rooms',
  String notLoggedRedirect = '/homeserver',
}) {
  final roomId = state.pathParameters['roomid'];
  if (roomId == null) return noRoomRedirect;

  final client = Matrix.of(context).client;
  final room = client.getRoomById(roomId);
  if (room == null) return noRoomRedirect;

  final userId = client.userID;
  if (userId == null) return notLoggedRedirect;

  final powerLevel = room.getPowerLevelByUserId(userId);

  if (powerLevel < minPowerLevel) {
    return fallbackRoute ?? '/rooms/$roomId';
  }

  return null;
}
