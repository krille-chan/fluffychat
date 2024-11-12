import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:flutter/material.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final bool loading;
  final int points;
  final VoidCallback onTap;
  final ProgressIndicatorEnum indicator;

  const ProgressIndicatorBadge({
    super.key,
    required this.onTap,
    required this.indicator,
    required this.loading,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: indicator.tooltip(context),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              indicator.icon,
              color: indicator.color(context),
            ),
            const SizedBox(width: 5),
            !loading
                ? Text(
                    points.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
