import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/views/sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'components/matrix.dart';
import 'views/chat_list.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.white),
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "FluffyChat",
      child: Builder(
        builder: (BuildContext context) => MaterialApp(
          title: 'FluffyChat',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xFF5625BA),
            backgroundColor: Colors.white,
            secondaryHeaderColor: Color(0xFFECECF2),
            scaffoldBackgroundColor: Colors.white,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              //elevation: 1,
              textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('de'), // German
          ],
          locale: kIsWeb
              ? Locale(html.window.navigator.language.split("-").first)
              : null,
          home: FutureBuilder<LoginState>(
            future: Matrix.of(context).client.onLoginStateChanged.stream.first,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (Matrix.of(context).client.isLogged()) return ChatListView();
              return SignUp();
            },
          ),
        ),
      ),
    );
  }
}
