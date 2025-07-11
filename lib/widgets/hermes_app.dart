

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';

import 'package:matrix/matrix.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/setting_keys.dart';

import 'package:hermes/l10n/l10n.dart';

import 'package:hermes/config/routes.dart';

import 'package:hermes/config/themes.dart';

import 'package:hermes/widgets/app_lock.dart';

import 'package:hermes/widgets/theme_builder.dart';

import 'package:hermes/config/setting_keys.dart';
import '../utils/custom_scroll_behaviour.dart';
import 'matrix.dart';

class BackIntent extends Intent {
  const BackIntent();
}

class BackAction extends Action<BackIntent> {
  @override
  Object? invoke(covariant BackIntent intent) {
    // Use a very obvious print statement
    final currentContext =
        primaryFocus?.context; // Try to get context from focus
    if (currentContext != null) {
      Navigator.maybePop(currentContext);
    }
    return null; // Action handled
  }
}

class HermesApp extends StatelessWidget {
  final Widget? testWidget;
  final List<Client> clients;
  final String? pincode;
  final SharedPreferences store;

  const HermesApp({
    super.key,
    this.testWidget,
    required this.clients,
    required this.store,
    this.pincode,
  });

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  // Router must be outside of build method so that hot reload does not reset
  // the current path.
  static final GoRouter router = GoRouter(
    routes: AppRoutes.routes,
    debugLogDiagnostics: true,
  );

  @override
  Widget build(BuildContext context) {
    final globalShortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.escape): const BackIntent(),
    };
    final globalActions = <Type, Action<Intent>>{
      BackIntent: BackAction(),
    };
    return ThemeBuilder(
      builder: (context, themeMode, primaryColor) => MaterialApp.router(
        title: AppSettings.applicationName.value,
        themeMode: themeMode,
        theme:
            PantheonThemes.buildTheme(context, Brightness.light, primaryColor),
        darkTheme:
            PantheonThemes.buildTheme(context, Brightness.dark, primaryColor),
        scrollBehavior: CustomScrollBehavior(),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        routerConfig: router,
        builder: (context, child) => Shortcuts(
          shortcuts: globalShortcuts,
          child: Actions(
            actions: globalActions,
            child: AppLockWidget(
              pincode: pincode,
              clients: clients,
              // Need a navigator above the Matrix widget for
              // displaying dialogs
              child: Matrix(
                clients: clients,
                store: store,
                child: testWidget ?? child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
