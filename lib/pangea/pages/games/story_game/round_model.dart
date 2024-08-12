import 'dart:async';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/extensions/sync_update_extension.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/widgets/chat/round_timer.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

enum RoundState { notStarted, inProgress, completed }

class GameRoundModel {
  static const int timerMaxSeconds = 180;

  final ChatController controller;
  final Completer<void> roundCompleter = Completer<void>();
  late DateTime createdAt;
  RoundTimer timer;
  DateTime? startTime;
  DateTime? endTime;
  RoundState state = RoundState.notStarted;
  StreamSubscription? syncSubscription;
  final Set<String> messageIDs = {};

  GameRoundModel({
    required this.controller,
    required this.timer,
  }) {
    createdAt = DateTime.now();
    syncSubscription ??= client.onSync.stream.listen((update) {
      final newMessages = update.messages(controller.room);
      final botMessages = newMessages
          .where((msg) => msg.senderId == BotName.byEnvironment)
          .toList();

      if (botMessages.isNotEmpty &&
          botMessages.any(
            (msg) =>
                msg.originServerTs.isAfter(createdAt) &&
                !messageIDs.contains(msg.eventId),
          )) {
        if (state == RoundState.notStarted) {
          startRound();
        } else if (state == RoundState.inProgress) {
          endRound();
        }
      }

      for (final message in newMessages) {
        if (message.originServerTs.isAfter(createdAt) &&
            !messageIDs.contains(message.eventId) &&
            !message.eventId.startsWith("Pangea Chat")) {
          messageIDs.add(message.eventId);
        }
      }
    });
  }

  Client get client => controller.pangeaController.matrixState.client;

  bool get isCompleted => roundCompleter.isCompleted;

  void startRound() {
    debugPrint("starting round");
    state = RoundState.inProgress;
    startTime = DateTime.now();
    controller.roundTimerStateKey.currentState?.resetTimer(
      roundLength: timerMaxSeconds,
    );
  }

  void endRound() {
    debugPrint("ending round, message IDs: $messageIDs");
    endTime = DateTime.now();
    state = RoundState.completed;
    controller.roundTimerStateKey.currentState?.stopTimeout();
    syncSubscription?.cancel();
    roundCompleter.complete();
  }

  void dispose() {
    syncSubscription?.cancel();
  }
}
