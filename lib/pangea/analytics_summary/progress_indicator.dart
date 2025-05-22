import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final bool loading;
  final int points;
  final VoidCallback onTap;
  final ProgressIndicatorEnum indicator;
  final bool mini;

  const ProgressIndicatorBadge({
    super.key,
    required this.onTap,
    required this.indicator,
    required this.loading,
    required this.points,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: indicator.tooltip(context),
      child: PressableButton(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(15),
        onPressed: onTap,
        buttonHeight: 2.5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                size: 14,
                indicator.icon,
                color: indicator.color(context),
                weight: 1000,
              ),
              if (!mini) ...[
                const SizedBox(width: 4.0),
                Text(
                  indicator.tooltip(context),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: indicator.color(context),
                  ),
                ),
              ],
              const SizedBox(width: 4.0),
              !loading
                  ? Text(
                      points.toString(),
                      style: TextStyle(
                        fontSize: 12,
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
        ),
      ),
    );
  }
}
