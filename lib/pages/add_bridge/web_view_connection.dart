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
      await _webViewController!.evaluateJavascript(
        source: """
      function declineCookies() {
        // Attempt to refuse the cookie prompts immediately using specific selectors
        var declineButton = document.querySelector('button[data-cookiebanner="accept_only_essential_button"]');
        if (declineButton) {
          declineButton.click();
        }

        var manageDialogAcceptButton = document.querySelector('button[data-testid="cookie-policy-manage-dialog-accept-button"]');
        if (manageDialogAcceptButton) {
          manageDialogAcceptButton.click();
        }
      }

      function applyCustomStyles() {
        // Adjust the login form elements for mobile
        var emailField = document.querySelector('input[name="email"]');
        if (emailField) {
          emailField.style.height = '70px';
          emailField.style.width = '80%';
          emailField.style.fontSize = '32px';
          emailField.style.padding = '14px';
          emailField.style.border = '2px solid #ccc';
          emailField.style.borderRadius = '8px';
          emailField.style.marginBottom = '20px';
        }
      
        var passField = document.querySelector('input[name="pass"]');
        if (passField) {
          passField.style.height = '70px';
          passField.style.width = '80%';
          passField.style.fontSize = '32px';
          passField.style.padding = '14px';
          passField.style.border = '2px solid #ccc';
          passField.style.borderRadius = '8px';
          passField.style.marginBottom = '20px';
        }
      
        var loginButton = document.querySelector('button[name="login"]');
        if (loginButton) {
          loginButton.style.height = '70px';
          loginButton.style.fontSize = '32px';
          loginButton.style.width = '80%';
          loginButton.style.marginTop = '22px';
          loginButton.style.padding = '14px';
          loginButton.style.border = 'none';
          loginButton.style.borderRadius = '8px';
          loginButton.style.backgroundColor = '#007bff';
          loginButton.style.color = '#fff';
        }

        // Hide the divs with specified classes
        var uiInputLabel = document.querySelector('.uiInputLabel.clearfix');
        if (uiInputLabel) {
          uiInputLabel.style.display = 'none';
        }

        var specificDiv = document.querySelector('._210n._7mqw');
        if (specificDiv) {
          specificDiv.style.display = 'none';
        }

        // Set height and width of img with class img
        var imgElement = document.querySelector('img.img');
        if (imgElement) {
          imgElement.setAttribute('style', 'height: 150px !important; width: 150px !important;');
        }
      }

      // Decline cookies immediately
      declineCookies();

      // Apply the custom styles after a short delay to ensure the page is fully loaded
      setTimeout(applyCustomStyles, 50);
    """,
      );
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
          // Check the URL when the page finishes loading
          switch (widget.network.name) {
            case "Facebook Messenger":
              final successfullyRedirected = !_facebookBridgeCreated &&
                  url != null &&
                  url.toString() != widget.network.urlLogin! &&
                  url.toString().contains(widget.network.urlRedirect!);

              if (successfullyRedirected) {
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
              } else {
                // assume login page
                await _addCustomStyle();
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

            case "Linkedin":
              if (!_linkedinBridgeCreated &&
                  url != null &&
                  url.toString().contains(widget.network.urlRedirect!)) {
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
