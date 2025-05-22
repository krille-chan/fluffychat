import 'package:flutter/material.dart';

import 'package:fluffychat/widgets/hover_builder.dart';

class LearningProgressIndicatorButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const LearningProgressIndicatorButton({
    super.key,
    required this.onPressed,
    required this.child,
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
                    ? Theme.of(context).colorScheme.primary.withAlpha(50)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(36.0),
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
