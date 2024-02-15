import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:tawkie/pages/add_bridge/service/bot_bridge_connection.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/widgets/notifier_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewConnection extends StatefulWidget {
  final BotBridgeConnection botBridgeConnection;
  final SocialNetwork network;
  final Function(bool success) onConnectionResult; // Callback function

  const WebViewConnection(
      {super.key,
      required this.botBridgeConnection,
      required this.network,
      required this.onConnectionResult});

  @override
  State<WebViewConnection> createState() => _WebViewConnectionState();
}

class _WebViewConnectionState extends State<WebViewConnection> {
  late WebViewController _controller;
  final cookieManager = WebviewCookieManager();

  @override
  void initState() {
    super.initState();
    _loadLinkedInLoginPage();
  }

  Future<void> _loadLinkedInLoginPage() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            // Reset the flag when a new page starts loading
            setState(() {
              url = "https://www.linkedin.com/login/";
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("https://www.linkedin.com/feed/")) {
              _getCookies();
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.linkedin.com/login/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
        ],
      ),
    );
  }

  String formatCookies(List<Cookie> cookies) {
    return cookies.map((cookie) {
      return '${cookie.name}="${cookie.value}"';
    }).join('; ');
  }

  void _getCookies() async {
    final gotCookies =
        await cookieManager.getCookies('https://www.linkedin.com/feed/');
    final formattedCookieString = formatCookies(gotCookies);

    final connectionStateModel =
        Provider.of<ConnectionStateModel>(context, listen: false);

    bool success = false; // Initialize success flag

    try {
      // Attempt to create bridge
      final result = await widget.botBridgeConnection.createBridgeLinkedin(
          context, formattedCookieString, connectionStateModel, widget.network);
      success = result == 'success'; // Set success flag based on result
    } catch (e) {
      Logs().v('Error creating LinkedIn bridge: $e');
    }

    // Close the current page
    Navigator.pop(context);

    // Call callback function with success result
    widget.onConnectionResult(success);
  }
}
