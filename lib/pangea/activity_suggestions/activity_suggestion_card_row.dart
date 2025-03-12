import 'package:flutter/material.dart';

class ActivitySuggestionCardRow extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const ActivitySuggestionCardRow({
    required this.icon,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        spacing: 8.0,
        children: [
          Icon(
            icon,
            size: 16.0,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
