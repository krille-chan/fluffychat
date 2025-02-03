import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/animated_level_dart.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';

class LevelBar extends StatefulWidget {
  final LevelBarDetails details;
  final ProgressBarDetails progressBarDetails;

  const LevelBar({
    super.key,
    required this.details,
    required this.progressBarDetails,
  });

  @override
  LevelBarState createState() => LevelBarState();
}

class LevelBarState extends State<LevelBar> {
  double prevWidth = 0;
  double get width =>
      widget.progressBarDetails.totalWidth * widget.details.widthMultiplier;

  @override
  void didUpdateWidget(covariant LevelBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.details.currentPoints != widget.details.currentPoints) {
      setState(() => prevWidth = width);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLevelBar(
      height: widget.progressBarDetails.height,
      beginWidth: prevWidth,
      endWidth: width,
      primaryColor: AppConfig.gold,
      highlightColor: AppConfig.goldLight,
    );
  }
}
