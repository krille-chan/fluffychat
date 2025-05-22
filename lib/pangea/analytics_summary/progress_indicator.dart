import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final bool loading;
  final int points;
  final ProgressIndicatorEnum indicator;

  const ProgressIndicatorBadge({
    super.key,
    required this.indicator,
    required this.loading,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: indicator.tooltip(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 18,
            indicator.icon,
            color: indicator.color(context),
            weight: 1000,
          ),
          const SizedBox(width: 6.0),
          !loading
              ? Text(
                  points.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: indicator.color(context),
                  ),
                )
              : const SizedBox(
                  height: 8,
                  width: 8,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
        ],
      ),
    );
  }
}
