import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LearningProgressBar extends StatelessWidget {
  final int level;
  final int totalXP;
  final double? height;

  const LearningProgressBar({
    required this.level,
    required this.totalXP,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      height: height,
      levelBars: [
        LevelBarDetails(
          fillColor: Theme.of(context).colorScheme.primary,
          currentPoints: totalXP,
          widthMultiplier:
              MatrixState.pangeaController.getAnalytics.levelProgress,
        ),
      ],
    );
  }
}
