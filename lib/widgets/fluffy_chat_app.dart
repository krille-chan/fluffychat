import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/routes.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/theme_builder.dart';
import '../config/app_config.dart';
import '../utils/custom_scroll_behaviour.dart';
import 'matrix.dart';

class FluffyChatApp extends StatefulWidget {
  final Widget? testWidget;
  final String? pincode;
  final Future<List<Client>> clientsFuture;
  final SharedPreferences store;

  const FluffyChatApp({
    super.key,
    this.testWidget,
    this.pincode,
    required this.clientsFuture,
    required this.store,
  });

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  // Router must be outside of build method so that hot reload does not reset
  // the current path.
  static final GoRouter router = GoRouter(routes: AppRoutes.routes);

  @override
  State<FluffyChatApp> createState() => _FluffyChatAppState();
}

class _FluffyChatAppState extends State<FluffyChatApp> {
  List<Client>? clients;
  bool isMigratingDatabase = false;

  Future<List<Client>> loadClient() async {
    return clients ??= await widget.clientsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, themeMode, primaryColor) => MaterialApp.router(
        title: AppConfig.applicationName,
        themeMode: themeMode,
        theme: FluffyThemes.buildTheme(context, Brightness.light, primaryColor),
        darkTheme:
            FluffyThemes.buildTheme(context, Brightness.dark, primaryColor),
        scrollBehavior: CustomScrollBehavior(),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        routerConfig: FluffyChatApp.router,
        builder: (context, child) => FutureBuilder(
          future: loadClient(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) {
              final error = snapshot.error;
              final label = error != null
                  ? L10n.of(context)!.reportErrorDescription
                  : L10n.of(context)!.databaseMigrationTitle;
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (error == null)
                        Image.asset(
                          'assets/logo.png',
                          width: 64,
                          height: 64,
                        )
                      else
                        const Text('😭', style: TextStyle(fontSize: 100)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: FluffyThemes.columnWidth,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: error == null ? 20 : 16,
                              color: error == null
                                  ? null
                                  : Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (error != null)
                        OutlinedButton.icon(
                          onPressed: () =>
                              ErrorReporter(context, 'INITIALIZATION ERROR')
                                  .onErrorCallback(
                            error,
                            snapshot.stackTrace,
                            OkCancelResult.ok,
                          ),
                          label: Text(L10n.of(context)!.reportError),
                          icon: const Icon(Icons.favorite),
                        ),
                      if (error == null)
                        const CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                    ],
                  ),
                ),
              );
            }
            return AppLockWidget(
              pincode: widget.pincode,
              clients: data,
              // Need a navigator above the Matrix widget for
              // displaying dialogs
              child: Navigator(
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => Matrix(
                    clients: data,
                    store: widget.store,
                    child: widget.testWidget ?? child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
