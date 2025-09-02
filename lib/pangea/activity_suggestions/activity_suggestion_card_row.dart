import 'package:flutter/material.dart';

class ActivitySuggestionCardRow extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final Widget child;
  final double? iconSize;

  const ActivitySuggestionCardRow({
    required this.child,
    this.icon,
    this.leading,
    this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        spacing: 12.0,
        children: [
          if (leading != null) leading!,
          if (icon != null)
            Icon(
              icon,
              size: iconSize ?? 24.0,
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
