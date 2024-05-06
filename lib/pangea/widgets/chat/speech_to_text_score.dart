import 'package:flutter/material.dart';

class SpeechToTextScoreWidget extends StatefulWidget {
  final int score;
  const SpeechToTextScoreWidget({super.key, required this.score});

  @override
  SpeechToTextScoreWidgetState createState() => SpeechToTextScoreWidgetState();
}

class SpeechToTextScoreWidgetState extends State<SpeechToTextScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          'Score: ${widget.score}',
          key: ValueKey<int>(widget.score),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
