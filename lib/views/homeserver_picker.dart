import 'dart:math';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
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
  final TextEditingController _controller =
      TextEditingController(text: AppConfig.defaultHomeserver);

  void _checkHomeserverAction(BuildContext context) async {
    try {
      if (_domain.isEmpty) throw L10n.of(context).changeTheHomeserver;
      var homeserver = _domain;

      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }

      setState(() => _isLoading = true);
      await Matrix.of(context).client.checkHomeserver(homeserver);
      final loginTypes = await Matrix.of(context).client.requestLoginTypes();
      if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.password)) {
        await AdaptivePageLayout.of(context)
            .pushNamed(AppConfig.enableRegistration ? '/signup' : '/login');
      } else if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.sso)) {
        await AdaptivePageLayout.of(context).pushNamed('/sso');
      }
    } on String catch (e) {
      // ignore: unawaited_futures
      FlushbarHelper.createError(message: e).show(context);
    } catch (e) {
      // ignore: unawaited_futures
      FlushbarHelper.createError(
              message: (e as Object).toLocalizedString(context))
          .show(context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: max((MediaQuery.of(context).size.width - 600) / 2, 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarSearchField(
          prefixText: 'https://',
          hintText: L10n.of(context).enterYourHomeserver,
          searchController: _controller,
          suffix: Icon(Icons.edit_outlined),
          padding: padding,
          onChanged: (s) => _domain = s,
        ),
        elevation: 0,
      ),
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
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                FlatButton(
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
    );
  }
}
