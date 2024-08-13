import 'dart:async';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/constants/game_constants.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/models/game_state_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

/// Create a timer that counts down to the given time
/// Default duration is 180 seconds
class RoundTimer extends StatefulWidget {
  final ChatController controller;
  const RoundTimer({
    super.key,
    required this.controller,
  });

  @override
  RoundTimerState createState() => RoundTimerState();
}

class RoundTimerState extends State<RoundTimer> {
  int currentSeconds = 0;
  Timer? timer;
  StreamSubscription? stateSubscription;

  @override
  void initState() {
    super.initState();

    final roundStartTime = widget.controller.currentRound?.currentRoundStart;
    if (roundStartTime != null) {
      final roundDuration = DateTime.now().difference(roundStartTime).inSeconds;
      if (roundDuration > GameConstants.timerMaxSeconds) return;

      currentSeconds = roundDuration;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        currentSeconds++;
        if (currentSeconds >= GameConstants.timerMaxSeconds) {
          t.cancel();
        }
        setState(() {});
      });
    }

    stateSubscription = Matrix.of(context)
        .client
        .onRoomState
        .stream
        .where(isRoundUpdate)
        .listen(onRoundUpdate);
  }

  bool isRoundUpdate(update) {
    return update.roomId == widget.controller.room.id &&
        update.state is Event &&
        (update.state as Event).type == PangeaEventTypes.storyGame;
  }

  void onRoundUpdate(update) {
    final GameModel gameState = GameModel.fromJson(
      (update.state as Event).content,
    );
    final startTime = gameState.currentRoundStartTime;
    final endTime = gameState.previousRoundEndTime;

    if (startTime == null && endTime == null) return;
    timer?.cancel();
    timer = null;

    // if this update is the start of a round
    if (startTime != null) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        currentSeconds++;
        if (currentSeconds >= GameConstants.timerMaxSeconds) {
          t.cancel();
        }
        setState(() {});
      });
      return;
    }

    // if this update is the end of a round
    currentSeconds = 0;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    stateSubscription?.cancel();
    stateSubscription = null;

    timer?.cancel();
    timer = null;
  }

  int get remainingTime => GameConstants.timerMaxSeconds - currentSeconds;

  String get timerText =>
      '${(remainingTime ~/ 60).toString().padLeft(2, '0')}: ${(remainingTime % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 126, 22, 14),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(timerText),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: widget.currentRound.timer == null
                  //       ? widget.currentRound.startRound
                  //       : null,
                  //   icon: Icon(
                  //     widget.currentRound.timer != null
                  //         ? Icons.pause_circle
                  //         : Icons.play_circle,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
