import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LearningProgressBar extends StatelessWidget {
  final int totalXP;
  const LearningProgressBar({
    required this.totalXP,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
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
