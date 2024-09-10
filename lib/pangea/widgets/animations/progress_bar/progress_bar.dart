import 'package:fluffychat/pangea/widgets/animations/progress_bar/level_bar.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_background.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_details.dart';
import 'package:flutter/material.dart';

// Provide an order list of level indicators, each with it's color
// and stream. Also provide an overall width and pointsPerLevel.

class ProgressBar extends StatelessWidget {
  final List<LevelBarDetails> levelBars;
  final ProgressBarDetails progressBarDetails;

  const ProgressBar({
    super.key,
    required this.levelBars,
    required this.progressBarDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ProgressBarBackground(details: progressBarDetails),
        for (final levelBar in levelBars)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: LevelBar(
              details: levelBar,
              progressBarDetails: progressBarDetails,
            ),
          ),
      ],
    );
  }
}
