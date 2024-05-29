import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/widgets/future_loading_dialog_custom.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'model/social_network.dart';
import 'service/bot_bridge_connection.dart';

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
  bool _isDisposed = false; // Variable to track widget status
  bool _facebookBridgeCreated =
      false; // Variable to track if the Facebook bridge has been created
  bool _instagramBridgeCreated =
      false; // Variable to track if the Instagram bridge has been created

  @override
  void dispose() {
    if (_webViewController != null && mounted) {
      _webViewController!.dispose();
    }
    _isDisposed = true; // Mark widget disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState =
        Provider.of<ConnectionStateModel>(context, listen: false);

    return Scaffold(
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          userAgent:
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(widget.network.urlLogin!),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          // Check the URL when the page finishes loading

          String result = ""; // Variable to store the result of the connection

          switch (widget.network.name) {
            case "Facebook Messenger":
              if (!_facebookBridgeCreated &&
                  url != null &&
                  url.toString().contains(widget.network.urlRedirect!)) {
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Facebook bridge as created
                    _facebookBridgeCreated = true;

                    result = await widget.botBridgeConnection
                        .createBridgeFacebook(context, cookieManager,
                            connectionState, widget.network);
                  },
                );
              }

              if (result == "success" && !_isDisposed) {
                // Close the current page
                if (_webViewController != null) {
                  _webViewController!.dispose();
                }

                // Close the current page
                Navigator.pop(context);

                // Call callback function with success result
                widget.onConnectionResult(true);
              }
              break;

            case "Instagram":
              if (!_instagramBridgeCreated &&
                  url != null &&
                  url.toString() == widget.network.urlRedirect!) {
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Instagram bridge as created
                    _instagramBridgeCreated = true;

                    result = await widget.botBridgeConnection
                        .createBridgeInstagram(context, cookieManager,
                            connectionState, widget.network);
                  },
                );
              }

              if (result == "success" && !_isDisposed) {
                // Close the current page
                if (_webViewController != null) {
                  _webViewController!.dispose();
                }

                // Close the current page
                Navigator.pop(context);

                // Call callback function with success result
                widget.onConnectionResult(true);
              }
              break;

            case "Linkedin":
              if (url != null &&
                  url.toString().contains(widget.network.urlRedirect!)) {
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
