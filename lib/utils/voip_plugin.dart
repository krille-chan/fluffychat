import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/pages/dialer/dialer.dart';
import '../../utils/voip/user_media_manager.dart';

class VoipPlugin extends WidgetsBindingObserver implements WebRTCDelegate {
  VoipPlugin({required this.client, required this.context}) {
    voip = VoIP(client, this);
    try {
      Connectivity()
          .onConnectivityChanged
          .listen(_handleNetworkChanged)
          .onError((e) => _currentConnectivity = ConnectivityResult.none);
    } catch (e, s) {
      Logs().w('Could not subscribe network updates', e, s);
    }
    Connectivity()
        .checkConnectivity()
        .then((result) => _currentConnectivity = result)
        .catchError((e) => _currentConnectivity = ConnectivityResult.none);
    if (!kIsWeb) {
      final wb = WidgetsBinding.instance;
      wb?.addObserver(this);
      if (wb != null) {
        didChangeAppLifecycleState(wb.lifecycleState!);
      }
    }
  }

  final Client client;
  bool background = false;
  bool speakerOn = false;
  late VoIP voip;
  ConnectivityResult? _currentConnectivity;
  ValueChanged<CallSession>? onIncomingCall;
  OverlayEntry? overlayEntry;

  // hacky workaround: in order to have [Overlay.of] working on web, the context
  // mus explicitly be re-assigned
  //
  // hours wasted: 5
  BuildContext context;

  void _handleNetworkChanged(ConnectivityResult result) async {
    /// Got a new connectivity status!
    if (_currentConnectivity != result) {
      voip.calls.forEach((_, sess) {
        sess.restartIce();
      });
    }
    _currentConnectivity = result;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logs().v('AppLifecycleState = $state');
    background = !(state != AppLifecycleState.detached &&
        state != AppLifecycleState.paused);
  }

  void addCallingOverlay(
      BuildContext context, String callId, CallSession call) {
    if (overlayEntry != null) {
      Logs().w('[VOIP] addCallingOverlay: The call session already exists?');
      overlayEntry?.remove();
    }
    // Overlay.of(context) is broken on web
    // falling back on a dialog
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (context) => Calling(
          context: context,
          client: client,
          callId: callId,
          call: call,
          onClear: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder: (_) => Calling(
            context: context,
            client: client,
            callId: callId,
            call: call,
            onClear: () {
              overlayEntry?.remove();
              overlayEntry = null;
            }),
      );
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }

  @override
  MediaDevices get mediaDevices => webrtc_impl.navigator.mediaDevices;

  @override
  bool get isBackgroud => background;

  @override
  bool get isWeb => kIsWeb;

  @override
  Future<RTCPeerConnection> createPeerConnection(
          Map<String, dynamic> configuration,
          [Map<String, dynamic> constraints = const {}]) =>
      webrtc_impl.createPeerConnection(configuration, constraints);

  @override
  VideoRenderer createRenderer() {
    return webrtc_impl.RTCVideoRenderer();
  }

  @override
  void playRingtone() async {
    if (!background) {
      try {
        await UserMediaManager().startRingingTone();
      } catch (_) {}
    }
  }

  @override
  void stopRingtone() async {
    if (!background) {
      try {
        await UserMediaManager().stopRingingTone();
      } catch (_) {}
    }
  }

  @override
  void handleNewCall(CallSession call) async {
    /// Popup CallingPage for incoming call.
    if (!background) {
      addCallingOverlay(context, call.callId, call);
    } else {
      onIncomingCall?.call(call);
    }
  }

  @override
  void handleCallEnded(CallSession session) async {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
