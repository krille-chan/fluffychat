import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/components/sentry_switch_list_tile.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../utils/localized_exception_extension.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  _HomeserverPickerState createState() => _HomeserverPickerState();
}

class _HomeserverPickerState extends State<HomeserverPicker> {
  bool _isLoading = false;
  String _domain = AppConfig.defaultHomeserver;

  void _checkHomeserverAction(BuildContext context) async {
    var homeserver = _domain;

    if (!homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    setState(() => _isLoading = true);

    // Look up well known
    try {
      final wellKnown = await MatrixApi(homeserver: Uri.parse(homeserver))
          .requestWellKnownInformations();
      homeserver = wellKnown.mHomeserver.baseUrl;
    } catch (e) {
      Logs().v('Found no well known information', e);
    }

    try {
      await Matrix.of(context)
          .client
          .checkHomeserver(homeserver, supportedLoginTypes: {
        AuthenticationTypes.password,
        if (PlatformInfos.isMobile) AuthenticationTypes.sso
      });
      final loginTypes = await Matrix.of(context).client.requestLoginTypes();
      if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.password)) {
        await AdaptivePageLayout.of(context)
            .pushNamed(AppConfig.enableRegistration ? '/signup' : '/login');
      } else if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.sso)) {
        await AdaptivePageLayout.of(context).pushNamed('/sso');
      }
    } catch (e) {
      // ignore: unawaited_futures
      FlushbarHelper.createError(
              title: L10n.of(context).noConnectionToTheServer,
              message: (e as Object).toLocalizedString(context))
          .show(context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _changeHomeserverAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changeTheHomeserver,
      textFields: [
        DialogTextField(
          keyboardType: TextInputType.url,
          prefixText: 'https://',
          hintText: AppConfig.defaultHomeserver,
        ),
      ],
    );
    if (input?.single?.isNotEmpty ?? false) {
      setState(() => _domain = input.single);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: max((MediaQuery.of(context).size.width - 600) / 2, 0),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: ListView(
            children: [
              Hero(
                tag: 'loginBanner',
                child: Image.asset('assets/banner.png'),
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
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  elevation: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        L10n.of(context).youWillBeConnectedTo(_domain),
                        style: TextStyle(fontSize: 16),
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          L10n.of(context).changeTheHomeserver,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () => _changeHomeserverAction(context),
                      ),
                    ],
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  FlatButton(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      L10n.of(context).privacy,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey,
                      ),
                    ),
                    onPressed: () => PlatformInfos.showDialog(context),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      L10n.of(context).about,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey,
                      ),
                    ),
                    onPressed: () => PlatformInfos.showDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  child: _isLoading
                      ? LinearProgressIndicator()
                      : Text(
                          L10n.of(context).connect.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  onPressed:
                      _isLoading ? null : () => _checkHomeserverAction(context),
                ),
              ),
            ),
            SentrySwitchListTile(),
          ],
        ),
      ),
    );
  }
}
