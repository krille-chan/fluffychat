import 'dart:async';

enum RoundState { notStarted, inProgress, completed }

class GameRoundModel {
  static const Duration roundLength = Duration(minutes: 3);

  Timer? timer;
  DateTime? startTime;
  DateTime? endTime;
  RoundState state = RoundState.notStarted;

  GameRoundModel() {
    timer = Timer(roundLength, () => endRound());
    startTime = DateTime.now();
  }

  void startRound() {
    state = RoundState.inProgress;
    startTime = DateTime.now();
    timer = Timer(roundLength, () => endRound());
  }

  void endRound() {
    endTime = DateTime.now();
    state = RoundState.completed;
  }
}
