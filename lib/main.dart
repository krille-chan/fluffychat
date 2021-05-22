// @dart=2.9
import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/config/routes.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:universal_html/html.dart' as html;

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

class FluffyChatApp extends StatelessWidget {
  final Widget testWidget;
  final Client testClient;
  static final GlobalKey<AdaptivePageLayoutState> _apl =
      GlobalKey<AdaptivePageLayoutState>();

  const FluffyChatApp({Key key, this.testWidget, this.testClient})
      : super(key: key);

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: FluffyThemes.light,
      dark: FluffyThemes.dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: '${AppConfig.applicationName}',
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        locale: kIsWeb
            ? Locale(html.window.navigator.language.split('-').first)
            : null,
        home: Builder(
          builder: (context) {
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
              context: context,
              apl: _apl,
              testClient: testClient,
              child: Builder(
                builder: (context) => AdaptivePageLayout(
                  key: _apl,
                  safeAreaOnColumnView: false,
                  onGenerateRoute: testWidget == null
                      ? FluffyRoutes(context).onGenerateRoute
                      : (_) => ViewData(mainView: (_) => testWidget),
                  dividerColor: Theme.of(context).dividerColor,
                  columnWidth: FluffyThemes.columnWidth,
                  dividerWidth: 1.0,
                  routeBuilder: (builder, settings) =>
                      Matrix.of(context).loginState == LoginState.logged &&
                              !{
                                '/',
                                '/search',
                                '/contacts',
                              }.contains(settings.name)
                          ? MaterialPageRoute(builder: builder)
                          : FadeRoute(page: builder(context)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
