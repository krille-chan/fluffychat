import 'dart:async';

import 'package:flutter/material.dart';

/// Create a timer that counts down to the given time
/// Default duration is 180 seconds
class RoundTimer extends StatefulWidget {
  final int timerMaxSeconds;

  const RoundTimer({
    super.key,
    this.timerMaxSeconds = 180,
  });

  @override
  RoundTimerState createState() => RoundTimerState();
}

class RoundTimerState extends State<RoundTimer> {
  int currentSeconds = 0;
  Timer? _timer;
  bool isTiming = false;

  void resetTimer() {
    setState(() {
      currentSeconds = 0;
    });
  }

  String get timerText =>
      '${((widget.timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((widget.timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds = 1000]) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentSeconds++;
        if (currentSeconds >= widget.timerMaxSeconds) timer.cancel();
      });
    });
    setState(() {
      isTiming = true;
    });
  }

  stopTimeout() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      isTiming = false;
    });
  }

  @override
  void initState() {
    startTimeout();
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
