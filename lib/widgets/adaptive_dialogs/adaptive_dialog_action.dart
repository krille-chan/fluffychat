import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDialogAction extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool autofocus;
  final Widget child;
  final bool bigButtons;

  const AdaptiveDialogAction({
    super.key,
    required this.onPressed,
    required this.child,
    this.autofocus = false,
    this.bigButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (bigButtons) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: autofocus
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceBright,
                  foregroundColor: autofocus
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                ),
                onPressed: onPressed,
                autofocus: autofocus,
                child: child,
              ),
            ),
          );
        }
        return TextButton(
          onPressed: onPressed,
          autofocus: autofocus,
          child: child,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(
          onPressed: onPressed,
          isDefaultAction: autofocus,
          child: child,
        );
    }
  }
}
