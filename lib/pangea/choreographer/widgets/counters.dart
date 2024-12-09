import 'package:fluffychat/pangea/constants/choreo_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../config/app_config.dart';

class Counter extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const Counter({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      // textStyle: BotStyle.text(context, setColor: false),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final int correct;
  final int incorrect;
  final int yellow;
  final int custom;
  const CounterDisplay({
    super.key,
    required this.correct,
    required this.incorrect,
    required this.yellow,
    required this.custom,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Counter(
          count: custom,
          label: L10n.of(context).customInputFeedbackChoice,
          // color: Theme.of(context).brightness == Brightness.dark
          //     ? AppConfig.primaryColorLight
          //     : AppConfig.primaryColor,
          color: AppConfig.primaryColor,
        ),
        Counter(
          count: correct,
          label: L10n.of(context).greenFeedback,
          color: ChoreoConstants.green,
        ),
        Counter(
          color: ChoreoConstants.yellow,
          label: L10n.of(context).yellowFeedback,
          count: yellow,
        ),
        Counter(
          count: incorrect,
          label: L10n.of(context).redFeedback,
          color: ChoreoConstants.red,
        ),
      ],
    );
  }
}
