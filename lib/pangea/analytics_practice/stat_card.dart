import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String achievementText;
  final Widget child;
  final bool isAchievement;

  const StatCard({
    required this.icon,
    required this.text,
    required this.achievementText,
    required this.child,
    this.isAchievement = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isAchievement
        ? Color.alphaBlend(
            colorScheme.surface.withAlpha(170),
            AppConfig.goldLight,
          )
        : colorScheme.surfaceContainer;

    TextStyle? titleStyle = theme.textTheme.titleMedium;
    if (!isColumnMode) {
      titleStyle = theme.textTheme.bodyMedium;
    }
    titleStyle = titleStyle?.copyWith(fontWeight: FontWeight.bold);

    TextStyle? achievementStyle = theme.textTheme.titleSmall;
    if (!isColumnMode) {
      achievementStyle = theme.textTheme.bodySmall;
    }
    achievementStyle = achievementStyle?.copyWith(fontWeight: FontWeight.bold);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: titleStyle)),
              if (isAchievement) ...[
                const SizedBox(width: 8.0),
                Text(achievementText, style: achievementStyle),
              ],
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
