import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:flutter/material.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final int? points;
  final VoidCallback onTap;
  final ProgressIndicatorEnum progressIndicator;
  final bool loading;

  const ProgressIndicatorBadge({
    super.key,
    required this.points,
    required this.onTap,
    required this.progressIndicator,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: progressIndicator.tooltip(context),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              progressIndicator.icon,
              color: progressIndicator.color(context),
            ),
            const SizedBox(width: 5),
            !loading
                ? Text(
                    points?.toString() ?? '0',
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
