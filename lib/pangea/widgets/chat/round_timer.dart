import 'dart:async';

import 'package:flutter/material.dart';

/// Create a timer that counts down to the given time
/// Default duration is 180 seconds
class RoundTimer extends StatefulWidget {
  final int timerMaxSeconds;
  final Duration roundDuration;

  const RoundTimer({
    super.key,
    this.timerMaxSeconds = 180,
    this.roundDuration = const Duration(seconds: 1),
  });

  @override
  RoundTimerState createState() => RoundTimerState();
}

class RoundTimerState extends State<RoundTimer> {
  int currentSeconds = 0;
  Timer? _timer;
  bool isTiming = false;
  Duration? duration;
  int timerMaxSeconds = 180;

  void resetTimer({Duration? roundDuration, int? roundLength}) {
    if (_timer != null) {
      _timer!.cancel();
      isTiming = false;
    }
    if (roundDuration != null) {
      duration = roundDuration;
    }
    if (roundLength != null) {
      timerMaxSeconds = roundLength;
    }
    setState(() {
      currentSeconds = 0;
    });
  }

  int get remainingTime => timerMaxSeconds - currentSeconds;

  String get timerText =>
      '${(remainingTime ~/ 60).toString().padLeft(2, '0')}: ${(remainingTime % 60).toString().padLeft(2, '0')}';

  startTimer() {
    _timer = Timer.periodic(duration ?? widget.roundDuration, (timer) {
      setState(() {
        currentSeconds++;
        if (currentSeconds >= timerMaxSeconds) timer.cancel();
      });
    });
    setState(() {
      isTiming = true;
    });
  }

  stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      isTiming = false;
    });
  }

  @override
  void initState() {
    duration = widget.roundDuration;
    timerMaxSeconds = widget.timerMaxSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 126, 22, 14),
      child: Padding(
        padding: const EdgeInsets.all(
          5,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(timerText),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       onPressed: isTiming ? stopTimeout : startTimeout,
              //       icon: Icon(isTiming ? Icons.pause_circle : Icons.play_circle),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
