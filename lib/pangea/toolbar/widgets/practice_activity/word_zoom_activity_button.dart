import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WordZoomActivityButton extends StatelessWidget {
  final Widget icon;
  final bool isSelected;
  final VoidCallback onPressed;

  final String? tooltip;
  final double? opacity;

  const WordZoomActivityButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
    this.tooltip,
    this.opacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = IconButton(
      onPressed: onPressed,
      icon: icon,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
      style: IconButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
            : null,
      ),
    );

    if (opacity != null) {
      buttonContent = Opacity(
        opacity: opacity!,
        child: buttonContent,
      );
    }

    if (tooltip != null) {
      buttonContent = Tooltip(
        message: tooltip!,
        child: buttonContent,
      );
    }

    return Badge(
      offset: kIsWeb ? null : const Offset(-1, 1),
      isLabelVisible: isSelected,
      label: SizedBox(
        height: 10,
        width: 10,
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close, size: 10),
          padding: const EdgeInsets.all(0.0),
        ),
      ),
      backgroundColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(0),
      child: buttonContent,
    );
  }
}
