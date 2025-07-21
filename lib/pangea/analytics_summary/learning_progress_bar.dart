import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LearningProgressBar extends StatelessWidget {
  final int level;
  final int totalXP;
  final double? height;
  final bool loading;

  const LearningProgressBar({
    required this.level,
    required this.totalXP,
    required this.loading,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        alignment: Alignment.center,
        height: height,
        child: const LinearProgressIndicator(
          color: AppConfig.goldLight,
        ),
      );
    }
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
