// @dart=2.9
import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/config/routes.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/lock_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'components/matrix.dart';
import 'config/themes.dart';
import 'app_config.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  FlutterError.onError = (FlutterErrorDetails details) =>
      Zone.current.handleUncaughtError(details.exception, details.stack);
  runZonedGuarded(
    () => runApp(PlatformInfos.isMobile
        ? AppLock(
            builder: (args) => App(),
            lockScreen: LockScreen(),
          )
        : App()),
    SentryController.captureException,
  );
}

class App extends StatelessWidget {
  static final GlobalKey<AdaptivePageLayoutState> _apl =
      GlobalKey<AdaptivePageLayoutState>();
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
          builder: (context) => Matrix(
            context: context,
            apl: _apl,
            child: Builder(
              builder: (context) => AdaptivePageLayout(
                key: _apl,
                onGenerateRoute: FluffyRoutes(context).onGenerateRoute,
                dividerColor: Theme.of(context).dividerColor,
                columnWidth: FluffyThemes.columnWidth,
                routeBuilder: (builder, settings) =>
                    Matrix.of(context).loginState == LoginState.logged
                        ? CupertinoPageRoute(builder: builder)
                        : FadeRoute(page: builder(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
