import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/widgets/future_loading_dialog_custom.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'model/social_network.dart';

class WebViewConnection extends StatefulWidget {
  final BotController controller;
  final SocialNetwork network;
  final Function(bool success) onConnectionResult; // Callback function

  const WebViewConnection({
    super.key,
    required this.controller,
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
  void initState() {
    super.initState();
    _clearCookies();
  }

  Future<void> _clearCookies() async {
    await cookieManager.clearCookies();
  }

  @override
  void dispose() {
    if (_webViewController != null && mounted) {
      _webViewController!
          .loadUrl(urlRequest: URLRequest(url: WebUri('about:blank')));
      _webViewController!.dispose();
    }
    _isDisposed = true; // Mark widget disposed
    super.dispose();
  }

  Future<void> _closeWebView() async {
    if (_webViewController != null && mounted) {
      await _webViewController!
          .loadUrl(urlRequest: URLRequest(url: WebUri('about:blank')));
      _webViewController!.dispose();
      _webViewController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionState =
        Provider.of<ConnectionStateModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.network.name,
        ),
      ),
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
          switch (widget.network.name) {
            case "Facebook Messenger":
              if (!_facebookBridgeCreated &&
                  url != null &&
                  url.toString() != widget.network.urlLogin! &&
                  url.toString().contains(widget.network.urlRedirect!)) {
                // Close the WebView
                await _closeWebView();

                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Facebook bridge as created
                    _facebookBridgeCreated = true;

                    await widget.controller.createBridgeMeta(context,
                        cookieManager, connectionState, widget.network);
                  },
                );
              }
              break;

            case "Instagram":
              if (!_instagramBridgeCreated &&
                  url != null &&
                  url.toString() != widget.network.urlLogin! &&
                  url.toString().contains(widget.network.urlRedirect!)) {
                // Close the WebView
                await _closeWebView();
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Instagram bridge as created
                    _instagramBridgeCreated = true;

                    await widget.controller.createBridgeMeta(context,
                        cookieManager, connectionState, widget.network);
                  },
                );
              }
              break;
            // Other network
          }

          if (widget.network.connected == true && !_isDisposed) {
            // Close the current page
            await _closeWebView();

            // Close the current page
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
