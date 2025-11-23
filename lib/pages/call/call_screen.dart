/// Element Call screen with WebView and Widget API integration.
library;

import 'dart:async';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';

import '../../utils/callkit/call_store.dart';
import '../../utils/callkit/group_call.dart';
import '../../utils/element_call/call_connection_state.dart';

const baseUrl = 'https://call.element.io';
const parentUrl = 'https://call.element.io';

/// Element Call screen.
class CallScreen extends StatefulWidget {
  final String roomId;

  const CallScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late Room? room;
  InAppWebViewController? _webViewController;
  GroupCall? _groupCall;
  bool _isLoading = true;
  String? _error;
  final bool _isClosing = false;

  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    room = Matrix.of(context).client.getRoomById(widget.roomId);
    if (room == null) {
      return;
    }

    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      Logs().i('CallScreen: Initializing call for room ${room!.id}');

      // Get or create GroupCall from CallStore
      _groupCall = CallStore.instance.getOrCreateCall(
        room: room!,
        client: room!.client,
        autoReconnect: false,
        baseUrl: baseUrl,
        parentUrl: parentUrl,
      );

      // Listen to connection state changes
      _connectionStateSubscription =
          _groupCall!.onConnectionStateChanged.listen(
        _handleConnectionStateChanged,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e, stack) {
      Logs().e('CallScreen: Error initializing call', e, stack);
      setState(() {
        _error = 'Failed to initialize call: $e';
        _isLoading = false;
      });
    }
  }

  /// Handle connection state changes from GroupCall.
  void _handleConnectionStateChanged(CallConnectionState state) {
    Logs().i('CallScreen: Connection state changed: $state');

    if (state == CallConnectionState.disconnected) {
      // Call ended, close screen
      if (mounted && !_isClosing) {
        Logs().i('CallScreen: Call disconnected, closing screen');
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _joinCall() async {
    if (_webViewController == null || _groupCall == null) return;

    Logs().i('CallScreen: Joining call');

    try {
      await _groupCall!.join(
        webViewController: _webViewController!,
        skipLobby: true,
      );
    } catch (e, stack) {
      Logs().e('CallScreen: Error joining call', e, stack);
      setState(() {
        _error = 'Failed to join call: $e';
      });
    }
  }

  /// Check if a WebView error is fatal.
  bool _isFatalError(WebResourceError error, WebResourceRequest request) {
    final description = error.description.toLowerCase();

    // Ignore cache misses - they're normal during navigation
    if (description.contains('cache_miss') ||
        description.contains('err_cache_miss')) {
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
    Logs().i('CallScreen: Disposing');

    _connectionStateSubscription?.cancel();

    // Hangup call if we're leaving
    if (_groupCall != null) {
      _groupCall!.hangup().catchError((e) {
        Logs().e('CallScreen: Error hanging up', e);
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: Text(L10n.of(context).oopsSomethingWentWrong)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Call...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Call Error'),
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
      body: SafeArea(
        child: InAppWebView(
          initialData: InAppWebViewInitialData(
            data: '', // Will be loaded in onWebViewCreated
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
            Logs().w(
              'CallScreen: WebView error: ${error.description} for ${request.url}',
            );

            final isFatal = _isFatalError(error, request);

            if (isFatal) {
              Logs().e('CallScreen: Fatal error detected');
              _groupCall?.hangup();
            }
          },
          onRenderProcessGone: (controller, detail) {
            Logs().e('CallScreen: Render process crashed: ${detail.didCrash}');
            _groupCall?.hangup();
          },
          onReceivedServerTrustAuthRequest: kDebugMode
              ? (controller, challenge) async {
                  return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED,
                  );
                }
              : null,
          onWebViewCreated: (controller) async {
            Logs().i('CallScreen: WebView created');
            _webViewController = controller;

            // Load wrapper HTML with proper origin
            final wrapperHtml =
                await rootBundle.loadString('assets/widget_wrapper.html');
            await controller.loadData(
              data: wrapperHtml,
              baseUrl: WebUri(parentUrl),
              mimeType: 'text/html',
              encoding: 'utf-8',
            );
          },
          onLoadStop: (controller, url) async {
            Logs().i('CallScreen: WebView loaded: $url');

            Logs().i('CallScreen: Wrapper ready, joining call');
            await _joinCall();
          },
          onConsoleMessage: (controller, consoleMessage) {
            // Logs().v('CallScreen: WebView console: ${consoleMessage.message}');
          },
          onPermissionRequest: (controller, request) async {
            Logs().i('CallScreen: Permission request: ${request.resources}');

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
