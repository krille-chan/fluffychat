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
    Widget buttonContent = AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedBuilder(
          animation: Listenable.merge([ValueNotifier(isSelected)]),
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? 1.25 : 1.0,
              child: icon,
            );
          },
        ),
        iconSize: 24, // Keep this constant as scaling handles the size change
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
        visualDensity: VisualDensity.compact,
        // style: IconButton.styleFrom(
        //   backgroundColor: isSelected
        //       ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)
        //       : Colors.transparent,
        // ),
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

    return buttonContent;
  }
}
