import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:tawkie/pages/login/login.dart';

class WebLogin extends StatefulWidget {
  final LoginController loginController;
  const WebLogin({Key? key, required this.loginController}) : super(key: key);

  @override
  State<WebLogin> createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri(
                'https://staging.tawkie.fr/panel/api/browser/getMatrixToken')),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          if (url != null) {
            final uri = Uri.parse(url.toString());
            final queryParameters = uri.queryParameters;
            final hasMt = queryParameters.containsKey('mt');
            final hasUn = queryParameters.containsKey('un');
            final hasSn = queryParameters.containsKey('sn');

            if (hasMt && hasSn) {
              final matrixToken = queryParameters['mt'];
              final serverName = queryParameters['sn'];

              await showFutureLoadingDialog(
                context: context,
                future: () => widget.loginController
                    .matrixLogin(matrixToken!, serverName!),
              );
            }
          }
        },
      ),
    );
  }
}
