import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_bar/level_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_background.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';

// Provide an order list of level indicators, each with it's color
// and stream. Also provide an overall width and pointsPerLevel.

class ProgressBar extends StatefulWidget {
  final List<LevelBarDetails> levelBars;
  final double? height;

  const ProgressBar({
    super.key,
    required this.levelBars,
    this.height,
  });

  @override
  ProgressBarState createState() => ProgressBarState();
}

class ProgressBarState extends State<ProgressBar> {
  double width = 0;
  void setWidth(double newWidth) {
    if (width != newWidth) {
      setState(() => width = newWidth);
    }
  }

  get progressBarDetails => ProgressBarDetails(
        totalWidth: width,
        borderColor: Theme.of(context).colorScheme.primary.withAlpha(128),
        height: widget.height ?? 14,
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (width != constraints.maxWidth) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => setWidth(constraints.maxWidth),
          );
        }
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            ProgressBarBackground(details: progressBarDetails),
            for (final levelBar in widget.levelBars)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: LevelBar(
                  details: levelBar,
                  progressBarDetails: progressBarDetails,
                ),
              ),
          ],
        );
      },
    );
  }
}
