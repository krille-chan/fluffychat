import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/widgets/pressable_button.dart';
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
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
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
                const SizedBox(width: 5),
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
      ),
    );
  }
}
