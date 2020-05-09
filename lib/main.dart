import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/homeserver_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'l10n/l10n.dart';
import 'components/theme_switcher.dart';
import 'components/matrix.dart';
import 'views/chat_list.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(App());
}

class App extends StatelessWidget {
  final String platform = kIsWeb ? "Web" : Platform.operatingSystem;
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "FluffyChat $platform",
      child: Builder(
        builder: (BuildContext context) => ThemeSwitcherWidget(
          child: Builder(
            builder: (BuildContext context) => StyledToast(
              duration: Duration(seconds: 5),
              child: MaterialApp(
                title: 'FluffyChat',
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
                ],
                locale: kIsWeb
                    ? Locale(html.window.navigator.language.split("-").first)
                    : null,
                home: FutureBuilder<LoginState>(
                  future: Matrix.of(context)
                      .client
                      .onLoginStateChanged
                      .stream
                      .first,
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
      ),
    );
  }
}
