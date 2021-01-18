import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app_config.dart';

class SsoWebView extends StatefulWidget {
  @override
  _SsoWebViewState createState() => _SsoWebViewState();
}

class _SsoWebViewState extends State<SsoWebView> {
  bool _loading = false;
  String _error;

  void _login(BuildContext context, String token) async {
    setState(() => _loading = true);
    try {
      await Matrix.of(context).client.login(
            type: AuthenticationTypes.token,
            userIdentifierType: null,
            token: token,
            initialDeviceDisplayName: Matrix.of(context).clientName,
          );
    } catch (e, s) {
      Logs().e('Login with token failed', e, s);
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final url =
        '${Matrix.of(context).client.homeserver?.toString()}/_matrix/client/r0/login/sso/redirect?redirectUrl=${Uri.encodeQueryComponent(AppConfig.appId.toLowerCase() + '://sso')}';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).logInTo(Matrix.of(context).client.homeserver?.host ??
              L10n.of(context).oopsSomethingWentWrong),
        ),
      ),
      body: _error != null
          ? Center(child: Text(_error))
          : _loading
              ? Center(child: CircularProgressIndicator())
              : WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageStarted: (url) {
                    if (url.startsWith(AppConfig.appId.toLowerCase())) {
                      _login(context,
                          Uri.parse(url).queryParameters['loginToken']);
                    }
                  },
                ),
    );
  }
}
