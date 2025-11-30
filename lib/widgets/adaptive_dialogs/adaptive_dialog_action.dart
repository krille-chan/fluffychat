import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class AdaptiveDialogAction extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool autofocus;
  final Widget child;
  final bool bigButtons;
  final BorderRadius? borderRadius;

  static const BorderRadius topRadius = BorderRadius.only(
    topLeft: Radius.circular(AppConfig.borderRadius),
    topRight: Radius.circular(AppConfig.borderRadius),
    bottomLeft: Radius.circular(2),
    bottomRight: Radius.circular(2),
  );
  static const BorderRadius centerRadius = BorderRadius.all(Radius.circular(2));
  static const BorderRadius bottomRadius = BorderRadius.only(
    bottomLeft: Radius.circular(AppConfig.borderRadius),
    bottomRight: Radius.circular(AppConfig.borderRadius),
    topLeft: Radius.circular(2),
    topRight: Radius.circular(2),
  );

  const AdaptiveDialogAction({
    super.key,
    required this.onPressed,
    required this.child,
    this.autofocus = false,
    this.bigButtons = false,
    this.borderRadius,
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
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        borderRadius ??
                        BorderRadius.circular(AppConfig.borderRadius),
                  ),
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
