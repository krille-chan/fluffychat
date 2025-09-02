import 'package:flutter/material.dart';

class ActivityAnalyticsChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const ActivityAnalyticsChip(
    this.icon,
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        spacing: 4.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
