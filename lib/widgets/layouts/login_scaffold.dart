import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

class LoginScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final bool enforceMobileMode;

  const LoginScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.enforceMobileMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMobileMode =
        enforceMobileMode || !FluffyThemes.isColumnMode(context);

    if (isMobileMode) {
      return Scaffold(
        key: const Key('LoginScaffold'),
        appBar: appBar,
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SafeArea(child: body),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerLow,
            theme.colorScheme.surfaceContainer,
            theme.colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Material(
            color: theme.colorScheme.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              side: BorderSide(
                color: theme.colorScheme.secondary,
                width: 2,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
            shadowColor: theme.appBarTheme.shadowColor,
            child: SizedBox(
              width: 480,
              height: 680,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                key: const Key('LoginScaffold'),
                appBar: appBar,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: body),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
