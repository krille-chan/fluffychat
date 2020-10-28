import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeserverPicker extends StatelessWidget {
  Future<void> _setHomeserverAction(BuildContext context) async {
    final homeserver = await SimpleDialogs(context).enterText(
        titleText: L10n.of(context).enterYourHomeserver,
        hintText: AppConfig.defaultHomeserver,
        prefixText: 'https://',
        keyboardType: TextInputType.url);
    if (homeserver?.isEmpty ?? true) return;
    _checkHomeserverAction(homeserver, context);
  }

  void _checkHomeserverAction(String homeserver, BuildContext context) async {
    if (await SentryController.getSentryStatus() == null || true) {
      await SentryController.toggleSentryAction(context);
    }

    if (!homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
        checkHomeserver(homeserver, Matrix.of(context).client));
    if (success == true) {
      await Navigator.of(context).push(AppRoute(SignUp()));
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
                    applicationIcon:
                        Image.asset('assets/logo.png', width: 100, height: 100),
                    applicationName: AppConfig.applicationName,
                  ),
                  child: Image.asset('assets/fluffychat-banner.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Spacer(),
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
              FlatButton(
                child: Text(
                  L10n.of(context).changeTheHomeserver,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => _setHomeserverAction(context),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
