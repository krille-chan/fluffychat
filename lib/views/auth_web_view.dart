import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthWebView extends StatefulWidget {
  final String authType;
  final String session;
  final Function onAuthDone;

  const AuthWebView(this.authType, this.session, this.onAuthDone);

  @override
  _AuthWebViewState createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final url = Matrix.of(context).client.homeserver.toString() +
        '/_matrix/client/r0/auth/${widget.authType}/fallback/web?session=${widget.session}';
    if (kIsWeb) launch(url);
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).authentication),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            AdaptivePageLayout.of(context).pop();
            widget.onAuthDone();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          if (_isLoading) LinearProgressIndicator(),
          Expanded(
            child: kIsWeb
                ? Center(child: Icon(Icons.link_outlined))
                : WebView(
                    onPageFinished: (_) => setState(() => _isLoading = false),
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
          ),
        ],
      ),
    );
  }
}
