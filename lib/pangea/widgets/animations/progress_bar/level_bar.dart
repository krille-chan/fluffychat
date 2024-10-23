import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/animated_level_dart.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_details.dart';
import 'package:flutter/material.dart';

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

  @override
  void didUpdateWidget(covariant LevelBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.details.currentPoints != widget.details.currentPoints) {
      setState(() => prevWidth = widget.details.width);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLevelBar(
      height: widget.progressBarDetails.height,
      beginWidth: prevWidth,
      endWidth: widget.details.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConfig.borderRadius),
        ),
        color: widget.details.fillColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(5, 0),
          ),
        ],
      ),
    );
  }
}