import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/dialer/dialer.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../../utils/famedlysdk_store.dart';
import '../../utils/voip/callkeep_manager.dart';
import '../../utils/voip/user_media_manager.dart';

class VoipPlugin with WidgetsBindingObserver implements WebRTCDelegate {
  final Client client;
  VoipPlugin(this.client) {
    voip = VoIP(client, this);
    Connectivity()
        .onConnectivityChanged
        .listen(_handleNetworkChanged)
        .onError((e) => _currentConnectivity = ConnectivityResult.none);
    Connectivity()
        .checkConnectivity()
        .then((result) => _currentConnectivity = result)
        .catchError((e) => _currentConnectivity = ConnectivityResult.none);
    if (!kIsWeb) {
      final wb = WidgetsBinding.instance;
      wb.addObserver(this);
      didChangeAppLifecycleState(wb.lifecycleState);
    }
  }
  bool background = false;
  bool speakerOn = false;
  late VoIP voip;
  ConnectivityResult? _currentConnectivity;
  OverlayEntry? overlayEntry;

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
  void didChangeAppLifecycleState(AppLifecycleState? state) {
    Logs().v('AppLifecycleState = $state');
    background = (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused);
  }

  void addCallingOverlay(String callId, CallSession call) {
    final context = kIsWeb
        ? ChatList.contextForVoip!
        : FluffyChatApp.routerKey.currentContext!; // web is weird
    if (overlayEntry != null) {
      Logs().e('[VOIP] addCallingOverlay: The call session already exists?');
      overlayEntry!.remove();
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
          },
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  @override
  MediaDevices get mediaDevices => webrtc_impl.navigator.mediaDevices;

  @override
  bool get isWeb => kIsWeb;

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) =>
      webrtc_impl.createPeerConnection(configuration, constraints);

  @override
  VideoRenderer createRenderer() {
    return webrtc_impl.RTCVideoRenderer();
  }

  Future<bool> get hasCallingAccount async =>
      kIsWeb ? false : await CallKeepManager().hasPhoneAccountEnabled;

  @override
  void playRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().startRingingTone();
      } catch (_) {}
    }
  }

  @override
  void stopRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().stopRingingTone();
      } catch (_) {}
    }
  }

  @override
  void handleNewCall(CallSession call) async {
    if (PlatformInfos.isAndroid) {
      // probably works on ios too
      final hasCallingAccount = await CallKeepManager().hasPhoneAccountEnabled;
      if (call.direction == CallDirection.kIncoming &&
          hasCallingAccount &&
          call.type == CallType.kVoice) {
        ///Popup native telecom manager call UI for incoming call.
        final callKeeper = CallKeeper(CallKeepManager(), call);
        CallKeepManager().addCall(call.callId, callKeeper);
        await CallKeepManager().showCallkitIncoming(call);
        return;
      } else {
        try {
          final wasForeground = await FlutterForegroundTask.isAppOnForeground;
          await Store().setItem(
            'wasForeground',
            wasForeground == true ? 'true' : 'false',
          );
          FlutterForegroundTask.setOnLockScreenVisibility(true);
          FlutterForegroundTask.wakeUpScreen();
          FlutterForegroundTask.launchApp();
        } catch (e) {
          Logs().e('VOIP foreground failed $e');
        }
        // use fallback flutter call pages for outgoing and video calls.
        addCallingOverlay(call.callId, call);
        try {
          if (!hasCallingAccount) {
            ScaffoldMessenger.of(FluffyChatApp.routerKey.currentContext!)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'No calling accounts found (used for native calls UI)',
                ),
              ),
            );
          }
        } catch (e) {
          Logs().e('failed to show snackbar');
        }
      }
    } else {
      addCallingOverlay(call.callId, call);
    }
  }

  @override
  void handleCallEnded(CallSession session) async {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      if (PlatformInfos.isAndroid) {
        FlutterForegroundTask.setOnLockScreenVisibility(false);
        FlutterForegroundTask.stopService();
        final wasForeground = await Store().getItem('wasForeground');
        wasForeground == 'false' ? FlutterForegroundTask.minimizeApp() : null;
      }
    }
  }

  @override
  void handleGroupCallEnded(GroupCall groupCall) {
    // TODO: implement handleGroupCallEnded
  }

  @override
  void handleNewGroupCall(GroupCall groupCall) {
    // TODO: implement handleNewGroupCall
  }

  @override
  // TODO: implement canHandleNewCall
  bool get canHandleNewCall =>
      voip.currentCID == null && voip.currentGroupCID == null;

  @override
  void handleMissedCall(CallSession session) {
    // TODO: implement handleMissedCall
  }
}
