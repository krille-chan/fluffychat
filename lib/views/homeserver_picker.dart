import 'dart:math';

import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/sign_up.dart';
import 'package:flutter/material.dart';

class HomeserverPicker extends StatelessWidget {
  Future<void> _setHomeserverAction(BuildContext context) async {
    final homeserver = await SimpleDialogs(context).enterText(
        titleText: L10n.of(context).enterYourHomeserver,
        hintText: Matrix.defaultHomeserver,
        prefixText: 'https://');
    if (homeserver?.isEmpty ?? true) return;
    _checkHomeserverAction(homeserver, context);
  }

  void _checkHomeserverAction(String homeserver, BuildContext context) async {
    if (!homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
        Matrix.of(context).client.checkServer(homeserver));
    if (success != false) {
      await Navigator.of(context).push(AppRoute(SignUp()));
    }
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
                child: Image.asset('assets/fluffychat-banner.png'),
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
                        Matrix.defaultHomeserver, context),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Opacity(
                  opacity: 0.75,
                  child: Text(
                    L10n.of(context).byDefaultYouWillBeConnectedTo(
                        Matrix.defaultHomeserver),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
