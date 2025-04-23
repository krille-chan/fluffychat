import 'package:flutter/material.dart';

class AutocorrectPopup extends StatelessWidget {
  final String originalText;
  final VoidCallback onUndo;

  const AutocorrectPopup({
    required this.originalText,
    required this.onUndo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Text(originalText),
          InkWell(
            onTap: onUndo,
            child: const Icon(Icons.replay, size: 12),
          ),
        ],
      ),
    );
  }
}
