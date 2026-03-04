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

class AdaptiveDialogInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets padding;

  const AdaptiveDialogInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if ({TargetPlatform.iOS, TargetPlatform.macOS}.contains(theme.platform)) {
      return CupertinoButton(
        onPressed: onTap,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        color: theme.colorScheme.surfaceBright,
        padding: padding,
        child: child,
      );
    }
    return Material(
      color: theme.colorScheme.surfaceBright,
      borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class AdaptiveIconTextButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const AdaptiveIconTextButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Expanded(
      child: AdaptiveDialogInkWell(
        padding: EdgeInsets.all(8.0),
        onTap: onTap,
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(icon, color: color),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
