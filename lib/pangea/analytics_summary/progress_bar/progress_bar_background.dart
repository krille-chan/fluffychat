import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';

class ProgressBarBackground extends StatelessWidget {
  final ProgressBarDetails details;

  const ProgressBarBackground({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: details.height,
      width: details.totalWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConfig.borderRadius),
        ),
        color: details.borderColor.withAlpha(50),
      ),
    );
  }
}
