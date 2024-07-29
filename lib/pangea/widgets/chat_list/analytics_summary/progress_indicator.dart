import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:flutter/material.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final int? points;
  final VoidCallback onTap;
  final ProgressIndicatorEnum progressIndicator;

  const ProgressIndicatorBadge({
    super.key,
    required this.points,
    required this.onTap,
    required this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Tooltip(
        message: progressIndicator.tooltip(context),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  progressIndicator.icon,
                  color: progressIndicator.color(context),
                ),
                const SizedBox(width: 5),
                points != null
                    ? Text(
                        points.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const CircularProgressIndicator.adaptive(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
