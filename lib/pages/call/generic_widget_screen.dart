/// Generic widget screen for any Matrix widget.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';

import '../../utils/widget_api/transport/webview_transport.dart';
import '../../utils/widget_api/widget_driver.dart';
import '../../utils/widget_api/widget_settings.dart';

/// Generic widget screen that can display any Matrix widget.
class GenericWidgetScreen extends StatefulWidget {
  final Room room;
  final Client client;
  final WidgetSettings settings;
  final VoidCallback? onClose;

  const GenericWidgetScreen({
    super.key,
    required this.room,
    required this.client,
    required this.settings,
    this.onClose,
  });

  @override
  State<GenericWidgetScreen> createState() => _GenericWidgetScreenState();
}

class _GenericWidgetScreenState extends State<GenericWidgetScreen> {
  InAppWebViewController? _webViewController;
  WidgetDriver? _driver;
  bool _isLoading = true;
  String? _error;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _initializeDriver() async {
    if (_webViewController == null) return;

    Logs().i('GenericWidgetScreen: Initializing widget driver for ${widget.settings.widgetId}');

    try {
      // Create transport
      final transport = WebViewWidgetTransport(_webViewController!);
      await transport.initialize();

      // Create driver
      _driver = WidgetDriver(
        settings: widget.settings,
        transport: transport,
        client: widget.client,
        room: widget.room,
        onClose: () {
          Logs().i('GenericWidgetScreen: Widget requested close');
          widget.onClose?.call();
          if (mounted) Navigator.of(context).pop();
        },
      );

      await _driver!.initialize();

      Logs().i('GenericWidgetScreen: Driver initialized');

      // Small delay to ensure driver listeners ready
      await Future.delayed(const Duration(milliseconds: 10));

      // Load widget URL directly (no wrapper needed for generic widgets)
      await _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(widget.settings.url)),
      );
    } catch (e, stack) {
      Logs().e('GenericWidgetScreen: Error initializing driver', e, stack);
      setState(() {
        _error = 'Failed to initialize widget driver: $e';
      });
    }
  }

  /// Handle widget death (crash/error).
  void _handleWidgetDeath() {
    if (_isClosing) return; // Prevent double-pop
    _isClosing = true;

    Logs().w('GenericWidgetScreen: Widget died');

    // Close screen
    widget.onClose?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Check if a WebView error is fatal.
  bool _isFatalError(WebResourceError error, WebResourceRequest request) {
    final description = error.description.toLowerCase();

    // Ignore cache misses - they're normal during navigation
    if (description.contains('cache_miss') || description.contains('err_cache_miss')) {
      return false;
    }

    // Ignore errors for sub-resources (images, config files, etc)
    if (request.isForMainFrame == false) {
      return false;
    }

    // Ignore aborted/cancelled requests
    if (description.contains('aborted') || description.contains('cancelled')) {
      return false;
    }

    // Only treat main frame navigation errors as fatal
    return request.isForMainFrame ?? false;
  }

  @override
  void dispose() {
    Logs().i('GenericWidgetScreen: Disposing');

    _driver?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading ${widget.settings.name ?? "Widget"}...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.settings.name ?? "Widget"} Error'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.settings.name ?? 'Widget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.settings.url),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            useHybridComposition: true,
            cacheEnabled: true,
            cacheMode: CacheMode.LOAD_DEFAULT,
          ),
          onReceivedError: (controller, request, error) {
            Logs().w('GenericWidgetScreen: WebView error: ${error.description} for ${request.url}');

            final isFatal = _isFatalError(error, request);

            if (isFatal) {
              Logs().e('GenericWidgetScreen: Fatal error detected, treating as widget death');
              _handleWidgetDeath();
            }
          },
          onRenderProcessGone: (controller, detail) {
            Logs().e('GenericWidgetScreen: Render process crashed: ${detail.didCrash}');
            _handleWidgetDeath();
          },
          onReceivedServerTrustAuthRequest: kDebugMode
              ? (controller, challenge) async {
                  return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED,
                  );
                }
              : null,
          onWebViewCreated: (controller) async {
            Logs().i('GenericWidgetScreen: WebView created');
            _webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            Logs().i('GenericWidgetScreen: WebView loaded: $url');
            await _initializeDriver();
          },
          onConsoleMessage: (controller, consoleMessage) {
            // Logs().v('GenericWidgetScreen: WebView console: ${consoleMessage.message}');
          },
          onPermissionRequest: (controller, request) async {
            Logs().i('GenericWidgetScreen: Permission request: ${request.resources}');

            // Auto-grant permissions based on widget type
            // For now, auto-grant for all widgets
            // In production, you might want to ask user
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
