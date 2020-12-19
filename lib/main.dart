// @dart=2.9
import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/homeserver_picker.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'components/matrix.dart';
import 'components/theme_switcher.dart';
import 'app_config.dart';
import 'views/chat_list.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  FlutterError.onError = (FlutterErrorDetails details) =>
      Zone.current.handleUncaughtError(details.exception, details.stack);
  runZonedGuarded(
    () => runApp(App()),
    SentryController.captureException,
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Matrix(
      child: Builder(
        builder: (BuildContext context) => ThemeSwitcherWidget(
          child: Builder(
              builder: (context) => MaterialApp(
                    title: '${AppConfig.applicationName}',
                    theme: ThemeSwitcherWidget.of(context).themeData,
                    localizationsDelegates: L10n.localizationsDelegates,
                    supportedLocales: L10n.supportedLocales,
                    locale: kIsWeb
                        ? Locale(
                            html.window.navigator.language.split('-').first)
                        : null,
                    home: FutureBuilder<LoginState>(
                      future: Matrix.of(context)
                          .client
                          .onLoginStateChanged
                          .stream
                          .first,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              FlushbarHelper.createError(
                                title: L10n.of(context).oopsSomethingWentWrong,
                                message: snapshot.error.toString(),
                              ).show(context));
                          return HomeserverPicker();
                        }
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
                  )),
        ),
      ),
    );
  }
}
