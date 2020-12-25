import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class HomeserverPicker extends StatelessWidget {
  Future<void> _setHomeserverAction(BuildContext context) async {
    const prefix = 'https://';
    final homeserver = await showTextInputDialog(
      title: L10n.of(context).enterYourHomeserver,
      context: context,
      textFields: [
        DialogTextField(
          hintText: AppConfig.defaultHomeserver,
          prefixText: prefix,
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (homeserver?.single?.isEmpty ?? true) return;
    _checkHomeserverAction(prefix + homeserver.single, context);
  }

  void _checkHomeserverAction(String homeserver, BuildContext context) async {
    if (await SentryController.getSentryStatus() == null || true) {
      await SentryController.toggleSentryAction(context);
    }

    if (!homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    final success = await showFutureLoadingDialog(
        context: context,
        future: () => checkHomeserver(homeserver, Matrix.of(context).client));
    if (success.result == true) {
      await Navigator.of(context)
          .push(AppRoute(AppConfig.enableRegistration ? SignUp() : Login()));
    }
  }

  Future<bool> checkHomeserver(dynamic homeserver, Client client) async {
    await client.checkHomeserver(homeserver);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Hero(
                      tag: 'loginBanner',
                      child: InkWell(
                        onTap: () => showAboutDialog(
                          context: context,
                          children: [
                            RaisedButton(
                              child: Text(L10n.of(context).privacy),
                              onPressed: () => launch(AppConfig.privacyUrl),
                            )
                          ],
                          applicationIcon: Image.asset('assets/logo.png',
                              width: 100, height: 100),
                          applicationName: AppConfig.applicationName,
                        ),
                        child: Image.asset('assets/banner.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppConfig.applicationWelcomeMessage ??
                            L10n.of(context).welcomeText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Hero(
                tag: 'loginButton',
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: RaisedButton(
                    elevation: 7,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      L10n.of(context).connect.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () => _checkHomeserverAction(
                        AppConfig.defaultHomeserver, context),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Text(
                  L10n.of(context).byDefaultYouWillBeConnectedTo(
                      AppConfig.defaultHomeserver),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Wrap(
                children: [
                  if (AppConfig.allowOtherHomeservers)
                    FlatButton(
                      child: Text(
                        L10n.of(context).changeTheHomeserver,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => _setHomeserverAction(context),
                    ),
                  FlatButton(
                    child: Text(
                      L10n.of(context).privacy,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => launch(AppConfig.privacyUrl),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
