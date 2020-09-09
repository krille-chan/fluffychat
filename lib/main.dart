import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/homeserver_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bot_toast/bot_toast.dart';

import 'l10n/l10n.dart';
import 'components/theme_switcher.dart';
import 'components/matrix.dart';
import 'views/chat_list.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:sentry/sentry.dart';
import 'package:localstorage/localstorage.dart';

final sentry = SentryClient(dsn: '8591d0d863b646feb4f3dda7e5dcab38');

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runZonedGuarded(
    () => runApp(App()),
    (error, stackTrace) async {
      final storage = LocalStorage('LocalStorage');
      await storage.ready;
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      if (storage.getItem('sentry') == true) {
        await sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    },
  );
}

class App extends StatelessWidget {
  final String platform = kIsWeb ? 'Web' : Platform.operatingSystem;
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: 'FluffyChat $platform',
      child: Builder(
        builder: (BuildContext context) => ThemeSwitcherWidget(
          child: Builder(
            builder: (BuildContext context) => MaterialApp(
              title: 'FluffyChat',
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              theme: ThemeSwitcherWidget.of(context).themeData,
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'), // English
                const Locale('de'), // German
                const Locale('hu'), // Hungarian
                const Locale('pl'), // Polish
                const Locale('fr'), // French
                const Locale('cs'), // Czech
                const Locale('es'), // Spanish
                const Locale('sk'), // Slovakian
                const Locale('gl'), // Galician
                const Locale('hr'), // Croatian
                const Locale('ja'), // Japanese
                const Locale('ru'), // Russian
                const Locale('uk'), // Ukrainian
                const Locale('hy'), // Armenian
                const Locale('tr'), // Turkish
                const Locale('zh_Hans'), // Chinese (Simplified)
              ],
              locale: kIsWeb
                  ? Locale(html.window.navigator.language.split('-').first)
                  : null,
              home: FutureBuilder<LoginState>(
                future:
                    Matrix.of(context).client.onLoginStateChanged.stream.first,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (Matrix.of(context).client.isLogged()) {
                    return ChatListView();
                  }
                  return HomeserverPicker();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
