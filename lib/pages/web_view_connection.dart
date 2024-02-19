import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/widgets/future_loading_dialog_custom.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'add_bridge/model/social_network.dart';
import 'add_bridge/service/bot_bridge_connection.dart';

class WebViewConnection extends StatefulWidget {
  final BotBridgeConnection botBridgeConnection;
  final SocialNetwork network;
  final Function(bool success) onConnectionResult; // Callback function

  const WebViewConnection({
    super.key,
    required this.botBridgeConnection,
    required this.network,
    required this.onConnectionResult,
  });

  @override
  State<WebViewConnection> createState() => _WebViewConnectionState();
}

class _WebViewConnectionState extends State<WebViewConnection> {
  InAppWebViewController? _webViewController;
  final cookieManager = WebviewCookieManager();

  @override
  Widget build(BuildContext context) {
    final connectionState =
        Provider.of<ConnectionStateModel>(context, listen: false);

    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://www.linkedin.com/login/"),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          // Check the URL when the page finishes loading

          String result = ""; // Variable to store the result of the connection

          switch (widget.network.name) {
            case "Linkedin":
              if (url != null &&
                  url.toString().contains("https://www.linkedin.com/feed/")) {
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    result = await widget.botBridgeConnection
                        .createBridgeLinkedin(context, cookieManager,
                            connectionState, widget.network);
                  },
                );
              }
              if (result == "success") {
                // Close the current page
                Navigator.pop(context);

                // Close the current page
                if (_webViewController != null) {
                  _webViewController!.dispose();
                }

                // Call callback function with success result
                widget.onConnectionResult(true);
              }
              break;
            // Other network
          }
        },
      ),
    );
  }
}
