// @dart=2.9
import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/config/routes.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/localized_exception_extension.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vrouter/vrouter.dart';

import 'widgets/layouts/wait_for_login.dart';
import 'widgets/lock_screen.dart';
import 'widgets/matrix.dart';
import 'config/themes.dart';
import 'config/app_config.dart';
import 'utils/matrix_sdk_extensions.dart/fluffy_client.dart';
import 'utils/platform_infos.dart';
import 'utils/background_push.dart';

void main() async {
  // Our background push shared isolate accesses flutter-internal things very early in the startup proccess
  // To make sure that the parts of flutter needed are started up already, we need to ensure that the
  // widget bindings are initialized already.
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) =>
      Zone.current.handleUncaughtError(details.exception, details.stack);

  if (PlatformInfos.isMobile) {
    BackgroundPush.clientOnly(FluffyClient());
  }

  runZonedGuarded(
    () => runApp(PlatformInfos.isMobile
        ? AppLock(
            builder: (args) => FluffyChatApp(),
            lockScreen: LockScreen(),
            enabled: false,
          )
        : FluffyChatApp()),
    SentryController.captureException,
  );
}

class FluffyChatApp extends StatefulWidget {
  final Widget testWidget;
  final Client testClient;

  const FluffyChatApp({Key key, this.testWidget, this.testClient})
      : super(key: key);

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  @override
  _FluffyChatAppState createState() => _FluffyChatAppState();
}

class _FluffyChatAppState extends State<FluffyChatApp> {
  final GlobalKey<MatrixState> _matrix = GlobalKey<MatrixState>();
  GlobalKey<VRouterState> _router;
  bool columnMode;
  String _initialUrl = '/';
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: FluffyThemes.light,
      dark: FluffyThemes.dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => LayoutBuilder(
        builder: (context, constraints) {
          var newColumns =
              (constraints.maxWidth / FluffyThemes.columnWidth).floor();
          if (newColumns > 3) newColumns = 3;
          columnMode ??= newColumns > 1;
          _router ??= GlobalKey<VRouterState>();
          if (columnMode != newColumns > 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _initialUrl = _router.currentState.url;
                columnMode = newColumns > 1;
                _router = GlobalKey<VRouterState>();
              });
            });
          }
          return VRouter(
            key: _router,
            title: '${AppConfig.applicationName}',
            theme: theme,
            darkTheme: darkTheme,
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            initialUrl: _initialUrl,
            locale: kIsWeb
                ? Locale(html.window.navigator.language.split('-').first)
                : null,
            routes: AppRoutes(columnMode, initialUrl: _initialUrl).routes,
            builder: (context, child) {
              LoadingDialog.defaultTitle = L10n.of(context).loadingPleaseWait;
              LoadingDialog.defaultBackLabel = L10n.of(context).close;
              LoadingDialog.defaultOnError =
                  (Object e) => e.toLocalizedString(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Theme.of(context).backgroundColor,
                    systemNavigationBarIconBrightness:
                        Theme.of(context).brightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light,
                  ),
                );
              });
              return Matrix(
                key: _matrix,
                context: context,
                router: _router,
                testClient: widget.testClient,
                child: WaitForInitPage(child),
              );
            },
          );
        },
      ),
    );
  }
}
