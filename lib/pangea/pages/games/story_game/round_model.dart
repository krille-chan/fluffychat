import 'dart:async';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/extensions/sync_update_extension.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

enum RoundState { notStarted, inProgress, completed }

class GameRoundModel {
  static const Duration roundLength = Duration(minutes: 3);

  final ChatController controller;
  Timer? timer;
  DateTime? startTime;
  DateTime? endTime;
  RoundState state = RoundState.notStarted;

  final Set<String> messageIDs = {};

  GameRoundModel({
    required this.controller,
  }) {
    client.onSync.stream.firstWhere((update) {
      final botEventIDs = update.botMessages(controller.roomId);
      return botEventIDs.isNotEmpty;
    }).then((_) => startRound());
  }

  Client get client => controller.pangeaController.matrixState.client;

  void startRound() {
    debugPrint("starting round");
    state = RoundState.inProgress;
    startTime = DateTime.now();
    timer = Timer(roundLength, () => endRound());
  }

  void endRound() {
    debugPrint("ending round");
    endTime = DateTime.now();
    state = RoundState.completed;
    timer?.cancel();
  }

  void dispose() {}
}
