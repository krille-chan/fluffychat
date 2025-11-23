import 'dart:async';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';

import 'widget_transport.dart';

/// WebView-based transport for widget communication
class WebViewWidgetTransport implements WidgetTransport {
  WebViewWidgetTransport(this.webViewController);

  final InAppWebViewController webViewController;
  final StreamController<String> _incomingController =
      StreamController.broadcast();

  bool _disposed = false;

  /// Initialize transport by setting up JavaScript handler
  Future<void> initialize() async {
    // Add JavaScript handler for widget messages
    webViewController.addJavaScriptHandler(
      handlerName: 'matrixWidget',
      callback: (args) {
        if (_disposed) return;
        if (args.isNotEmpty) {
          final data = args[0];
          // Widget wrapper sends Map, convert to JSON string
          final message = data is String ? data : jsonEncode(data);
          Logs().v('WebViewWidgetTransport: Received from widget: $message');
          _incomingController.add(message);
        }
      },
    );
  }

  @override
  Stream<String> get incoming => _incomingController.stream;

  @override
  Future<void> send(String message) async {
    if (_disposed) return;

    Logs().v('WebViewWidgetTransport: Sending to widget: $message');

    // Parse JSON string to object and send to widget
    // Widget wrapper expects object, not JSON string
    await webViewController.evaluateJavascript(
      source: 'sendToWidget($message)',
    );
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _incomingController.close();
  }
}
