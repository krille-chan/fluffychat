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
  final String adminName = BotName.byEnvironment;

  final ChatController controller;
  final Completer<void> roundCompleter = Completer<void>();
  late DateTime createdAt;
  RoundTimer timer;
  DateTime? startTime;
  DateTime? endTime;
  RoundState state = RoundState.notStarted;
  StreamSubscription? syncSubscription;
  final List<String> userMessageIDs = [];
  final List<String> botMessageIDs = [];

  GameRoundModel({
    required this.controller,
    required this.timer,
  }) {
    createdAt = DateTime.now();
    syncSubscription ??= client.onSync.stream.listen(_handleSync);
  }

  void _handleSync(SyncUpdate update) {
    final newMessages = update
        .messages(controller.room)
        .where((msg) => msg.originServerTs.isAfter(createdAt))
        .toList();

    final botMessages =
        newMessages.where((msg) => msg.senderId == adminName).toList();
    final userMessages =
        newMessages.where((msg) => msg.senderId != adminName).toList();

    final hasNewBotMessage = botMessages.any(
      (msg) => !botMessageIDs.contains(msg.eventId),
    );

    if (hasNewBotMessage) {
      if (state == RoundState.notStarted) {
        startRound();
      } else if (state == RoundState.inProgress) {
        endRound();
        return;
      }
    }

    if (state == RoundState.inProgress) {
      for (final message in botMessages) {
        if (!botMessageIDs.contains(message.eventId)) {
          botMessageIDs.add(message.eventId);
        }
      }

      for (final message in userMessages) {
        if (!userMessageIDs.contains(message.eventId)) {
          userMessageIDs.add(message.eventId);
        }
      }
    }
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
    controller.roundTimerStateKey.currentState?.startTimer();
  }

  void endRound() {
    debugPrint(
      "ending round, user message IDs: $userMessageIDs, bot message IDs: $botMessageIDs",
    );
    endTime = DateTime.now();
    state = RoundState.completed;
    controller.roundTimerStateKey.currentState?.resetTimer();
    syncSubscription?.cancel();
    roundCompleter.complete();
  }

  void dispose() {
    syncSubscription?.cancel();
  }
}
