import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/homeserver_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:sentry/sentry.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'components/matrix.dart';
import 'components/theme_switcher.dart';
import 'utils/famedlysdk_store.dart';
import 'views/chat_list.dart';

final sentry = SentryClient(dsn: '8591d0d863b646feb4f3dda7e5dcab38');

void captureException(error, stackTrace) async {
  debugPrint(error.toString());
  debugPrint(stackTrace.toString());
  final storage = Store();
  if (await storage.getItem('sentry') == 'true') {
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runZonedGuarded(
    () => runApp(App()),
    captureException,
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
              localizationsDelegates: L10n.localizationsDelegates,
              supportedLocales: L10n.supportedLocales,
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
