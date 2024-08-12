import 'dart:async';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/extensions/sync_update_extension.dart';
import 'package:fluffychat/pangea/widgets/chat/round_timer.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

enum RoundState { notStarted, inProgress, completed }

class GameRoundModel {
  static const int timerMaxSeconds = 180;

  final ChatController controller;
  final Completer<void> roundCompleter = Completer<void>();
  RoundTimer timer;
  DateTime? startTime;
  DateTime? endTime;
  RoundState state = RoundState.notStarted;

  final Set<String> messageIDs = {};

  GameRoundModel({
    required this.controller,
    required this.timer,
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
    controller.roundTimerStateKey.currentState?.resetTimer(
      roundLength: timerMaxSeconds,
    );
  }

  void endRound() {
    debugPrint("ending round");
    endTime = DateTime.now();
    state = RoundState.completed;
    controller.roundTimerStateKey.currentState?.stopTimeout();
    roundCompleter.complete();
  }

  void dispose() {}
}
