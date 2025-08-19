import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/dialer/dialer.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import '../../utils/voip/user_media_manager.dart';
import '../widgets/matrix.dart';


class VoipPlugin with WidgetsBindingObserver implements WebRTCDelegate {
  final MatrixState matrix;
  Client get client => matrix.client;

  VoipPlugin(this.matrix) {
    voip = VoIP(client, this);
    if (!kIsWeb) {
      final wb = WidgetsBinding.instance;
      wb.addObserver(this);
      didChangeAppLifecycleState(wb.lifecycleState);
    }
  }

  bool background = false;
  bool speakerOn = false;
  late VoIP voip;

  // Track whether we've already presented the call UI
  bool _callRoutePushed = false;

  BuildContext get context => matrix.context;

  @override
  void didChangeAppLifecycleState(AppLifecycleState? state) {
    background = (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused);
  }

  /// Present the call UI via the root Navigator (works even when Overlay isn't ready)
  void addCallingOverlay(String callId, CallSession call) {
    // Prefer a global, always-ready context; fall back to previous behavior if needed
    final ctx = Nav.ctx ?? (kIsWeb ? ChatList.contextForVoip! : context);

    // If app is still building and Nav.ctx is null, retry on next frame
    if (Nav.ctx == null) {
      debugPrint('[VOIP] addCallingOverlay: Nav.ctx is null; retry next frame');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (voip.currentCID == call.callId) addCallingOverlay(callId, call);
      });
      return;
    }

    // Avoid duplicate screens
    if (_callRoutePushed) {
      debugPrint('[VOIP] addCallingOverlay: route already pushed, ignoring');
      return;
    }
    _callRoutePushed = true;

    // Web was using showDialog; showGeneralDialog also works there
    showGeneralDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      barrierLabel: 'Call',
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, __, ___) => Calling(
        context: ctx,
        client: client,
        callId: callId,
        call: call,
        onClear: () {
          final nav = Nav.navigatorKey.currentState;
          if (nav?.canPop() ?? false) {
            nav!.pop();
          }
          _callRoutePushed = false;
        },
      ),
    ).then((_) {
      _callRoutePushed = false;
    });
  }

  // ==== WebRTCDelegate requirement implementations ====

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

  Future<bool> get hasCallingAccount async => false;

  @override
  Future<void> playRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().startRingingTone();
      } catch (_) {}
    }
  }

  @override
  Future<void> stopRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().stopRingingTone();
      } catch (_) {}
    }
  }

  @override
  Future<void> handleNewCall(CallSession call) async {
    if (PlatformInfos.isAndroid) {
      try {
        final wasForeground = await FlutterForegroundTask.isAppOnForeground;
        await matrix.store.setString(
          'wasForeground',
          wasForeground == true ? 'true' : 'false',
        );
        FlutterForegroundTask.setOnLockScreenVisibility(true);
        FlutterForegroundTask.wakeUpScreen();
        if (wasForeground != true) {
          FlutterForegroundTask.launchApp();
        }
      } catch (e) {
        Logs().e('VOIP foreground failed $e');
      }
    }
    addCallingOverlay(call.callId, call);
  }

  @override
  Future<void> handleCallEnded(CallSession session) async {
    final nav = Nav.navigatorKey.currentState;
    if (_callRoutePushed && (nav?.canPop() ?? false)) {
      nav!.pop();
    }
    _callRoutePushed = false;

    if (PlatformInfos.isAndroid) {
      FlutterForegroundTask.setOnLockScreenVisibility(false);
      FlutterForegroundTask.stopService();
      final wasForeground = matrix.store.getString('wasForeground');
      if (wasForeground == 'false') {
        FlutterForegroundTask.minimizeApp();
      }
    }
  }

  @override
  Future<void> handleGroupCallEnded(GroupCallSession groupCall) async {
    // No-op for now; add UI cleanup if/when you implement group call UI.
  }

  @override
  Future<void> handleNewGroupCall(GroupCallSession groupCall) async {
    // No-op for now; add UI entry if/when you implement group call UI.
  }

  @override
  bool get canHandleNewCall =>
      voip.currentCID == null && voip.currentGroupCID == null;

  @override
  Future<void> handleMissedCall(CallSession session) async {
    // Optional: show a local notification / badge here.
  }

  @override
  EncryptionKeyProvider? get keyProvider => null;

  @override
  Future<void> registerListeners(CallSession session) {
    return SynchronousFuture(null);
  }
}
class Nav {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get ctx => navigatorKey.currentContext;
}