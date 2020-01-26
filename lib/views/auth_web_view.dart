import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthWebView extends StatelessWidget {
  final String authType;
  final String session;
  final Function onAuthDone;

  const AuthWebView(this.authType, this.session, this.onAuthDone);

  @override
  Widget build(BuildContext context) {
    final String url = Matrix.of(context).client.homeserver +
        "/_matrix/client/r0/auth/$authType/fallback/web?session=$session";
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).authentication),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop();
              onAuthDone();
            },
          )
        ],
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
