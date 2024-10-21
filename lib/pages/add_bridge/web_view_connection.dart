import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/utils/webview_scripts.dart';
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
  bool _linkedinBridgeCreated =
      false; // Variable to track if the Linkedin bridge has been created

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
    _isDisposed = true;
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

  // Whether the social network is FB Messenger
  bool _isMessenger() {
    return widget.network.name == 'Facebook Messenger';
  }

  // Add custom style to the login page to make it more user-friendly
  Future<void> _addCustomStyle() async {
    if (_isMessenger() && _webViewController != null) {
      await _webViewController!
          .evaluateJavascript(source: getCombinedScriptMessenger());
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionState =
        Provider.of<ConnectionStateModel>(context, listen: false);

    // Set custom user agent to increase credibility and *confusion*
    // Messenger will not display the login fields if we use a mobile user-agent
    final userAgent = _isMessenger()
        // Chrome on Windows 10
        ? 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
        // Chrome on Galaxy S9
        : 'Mozilla/5.0 (Linux; Android 14; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.6478.122 Mobile Safari/537.36';

    final InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent: userAgent,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.network.name,
        ),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialSettings: settings,
        initialUrlRequest: URLRequest(
          url: WebUri(widget.network.urlLogin!),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          if (_isDisposed) return; // Prevent further operations if disposed
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          final urlString = url?.toString();
          // Check the URL when the page finishes loading
          switch (widget.network.name) {
            case "Facebook Messenger":
              final successfullyRedirected = !_facebookBridgeCreated &&
                  url != null &&
                  urlString != widget.network.urlLogin! &&
                  widget.network.urlRedirectPattern?.hasMatch(urlString!) == true;

              if (successfullyRedirected) {
                await _closeWebView();

                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Facebook bridge as created
                    _facebookBridgeCreated = true;

                    await widget.controller.startBridgeLogin(context,
                        cookieManager, connectionState, widget.network);
                  },
                );
              } else {
                // assume login page
                await _addCustomStyle();
              }
              break;

            case "Instagram":
              if (!_instagramBridgeCreated &&
                  url != null &&
                  urlString != widget.network.urlLogin! &&
                  widget.network.urlRedirectPattern?.hasMatch(urlString!) == true) {
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

            case "Linkedin":
              if (!_linkedinBridgeCreated &&
                  url != null &&
                  widget.network.urlRedirectPattern?.hasMatch(urlString!) == true) {
                // Close the WebView
                await _closeWebView();
                await showCustomLoadingDialog(
                  context: context,
                  future: () async {
                    // Mark the Instagram bridge as created
                    _linkedinBridgeCreated = true;

                    await widget.controller.createBridgeLinkedin(context,
                        cookieManager, connectionState, widget.network);
                  },
                );
              }
              break;
            // Other network
          }

          if (widget.network.connected && !_isDisposed) {
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
