import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/routes.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/theme_builder.dart';
import '../config/app_config.dart';
import '../utils/custom_scroll_behaviour.dart';
import 'matrix.dart';

class FluffyChatApp extends StatefulWidget {
  final Widget? testWidget;
  final List<Client> clients;
  final Map<String, String>? queryParameters;
  static GlobalKey<VRouterState> routerKey = GlobalKey<VRouterState>();
  const FluffyChatApp({
    Key? key,
    this.testWidget,
    required this.clients,
    this.queryParameters,
  }) : super(key: key);

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  @override
  FluffyChatAppState createState() => FluffyChatAppState();
}

class FluffyChatAppState extends State<FluffyChatApp> {
  bool? columnMode;
  String? _initialUrl;

  @override
  void initState() {
    super.initState();
    _initialUrl =
        widget.clients.any((client) => client.isLogged()) ? '/rooms' : '/home';
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, themeMode, primaryColor) => LayoutBuilder(
        builder: (context, constraints) {
          final isColumnMode =
              FluffyThemes.isColumnModeByWidth(constraints.maxWidth);
          if (isColumnMode != columnMode) {
            Logs().v('Set Column Mode = $isColumnMode');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _initialUrl = FluffyChatApp.routerKey.currentState?.url;
                columnMode = isColumnMode;
                FluffyChatApp.routerKey = GlobalKey<VRouterState>();
              });
            });
          }
          return VRouter(
            key: FluffyChatApp.routerKey,
            title: AppConfig.applicationName,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: FluffyThemes.buildTheme(Brightness.light, primaryColor),
            darkTheme: FluffyThemes.buildTheme(Brightness.dark, primaryColor),
            scrollBehavior: CustomScrollBehavior(),
            logs: kReleaseMode ? VLogs.none : VLogs.info,
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            initialUrl: _initialUrl ?? '/',
            routes: AppRoutes(columnMode ?? false).routes,
            builder: (context, child) => Matrix(
              context: context,
              router: FluffyChatApp.routerKey,
              clients: widget.clients,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
