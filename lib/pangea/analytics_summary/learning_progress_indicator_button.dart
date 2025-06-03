import 'package:flutter/material.dart';

import 'package:fluffychat/widgets/hover_builder.dart';

class HoverButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final BorderRadius? borderRadius;
  final double hoverOpacity;

  const HoverButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.hoverOpacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: HoverBuilder(
        builder: (context, hovered) {
          return GestureDetector(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                color: hovered
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha((hoverOpacity * 255).round())
                    : Colors.transparent,
                borderRadius: borderRadius ?? BorderRadius.circular(36.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 4.0,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
