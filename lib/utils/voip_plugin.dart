import 'dart:core';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/dialer/dialer.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import '../../../utils/voip/user_media_manager.dart';

class VoipPlugin with WidgetsBindingObserver implements WebRTCDelegate {
  final MatrixState matrix;

  VoipPlugin(this.matrix) {
    voip = VoIP(matrix.client, this);
    if (!kIsWeb) {
      final wb = WidgetsBinding.instance;
      wb.addObserver(this);
      didChangeAppLifecycleState(wb.lifecycleState);
    }
  }

  late VoIP voip;

  BuildContext get context => ChatList.contextForVoip!;

  bool speakerOn = false;
  OverlayEntry? overlayEntry;
  bool overlayMinimised = false;
  bool background = false;

  @override
  bool get isWeb => kIsWeb;

  @override
  EncryptionKeyProvider? get keyProvider => null;

  @override
  MediaDevices get mediaDevices => webrtc_impl.navigator.mediaDevices;

  @override
  bool get canHandleNewCall => voip.currentCID == null && voip.currentGroupCID == null;

  @override
  void didChangeAppLifecycleState(AppLifecycleState? state) {
    background = state == AppLifecycleState.detached || state == AppLifecycleState.paused;
  }

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) => webrtc_impl.createPeerConnection(configuration, constraints);

  void addCallingOverlay(String callId, CallSession call) {
    if (overlayEntry != null) {
      Logs().e('[VOIP] addCallingOverlay: The call session already exists?');
      overlayEntry!.remove();
    }

    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (context) => Calling(
          context: context,
          client: matrix.client,
          callId: callId,
          call: call,
          onClear: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        canSizeOverlay: true,
        builder: (_) => Calling(
          context: context,
          client: matrix.client,
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

  // ════════════════════════════════════════════
  // Call Handlers
  // ════════════════════════════════════════════

  @override
  Future<void> handleNewCall(CallSession call) async {
    if (call.direction == CallDirection.kIncoming) {
      Logs().d('[VOIP] Incoming call → play ringtone');
      await UserMediaManager().startIncomingRingtone();
      if (call.remoteUserId == call.client.userID) {
        Logs().w('[VOIP] Ignoring a call from ourselves — probably a call to someone else from a different device.');
        return;
      }
    }

    if (call.direction == CallDirection.kOutgoing) {
      Logs().d('[VOIP] Outgoing call → play ringback tone');
      await UserMediaManager().startOutgoingRingtone();
      if (call.localParticipant?.deviceId != matrix.client.deviceID) {
        Logs().w('[VOIP] Ignoring an outgoing call with different device ID.');
        return;
      }
    }

    if (PlatformInfos.isAndroid) {
      try {
        final wasForeground = await FlutterForegroundTask.isAppOnForeground;
        await matrix.store.setString('wasForeground', wasForeground == true ? 'true' : 'false');
        FlutterForegroundTask.setOnLockScreenVisibility(true);
        FlutterForegroundTask.wakeUpScreen();
        FlutterForegroundTask.launchApp();
      } catch (e) {
        Logs().e('[VOIP] Foreground task failed: $e');
      }
    }

    if (!call.callHasEnded) {
      overlayMinimised = false;
      Logs().d('[VOIP] Opening call overlay for ${call.callId}');
      addCallingOverlay(call.callId, call);
    }
  }

  @override
  Future<void> handleCallEnded(CallSession session) async {
    Logs().d('[VOIP] Call ended → stop ringtone');

    await UserMediaManager().stopRingingTone();

    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;

      if (PlatformInfos.isAndroid) {
        FlutterForegroundTask.setOnLockScreenVisibility(false);
        FlutterForegroundTask.stopService();
        final wasForeground = matrix.store.getString('wasForeground');
        if (wasForeground == 'false') FlutterForegroundTask.minimizeApp();
      }
    }
  }

  @override
  Future<void> handleMissedCall(CallSession session) async {
    Logs().d('[VOIP] Missed call from ${session.room.getLocalizedDisplayname()}');
    // TODO:
  }

  @override
  Future<void> handleNewGroupCall(GroupCallSession groupCall) async {
    // TODO: implement handleNewGroupCall
  }

  @override
  Future<void> handleGroupCallEnded(GroupCallSession groupCall) async {
    // TODO: implement handleGroupCallEnded
  }

  @override
  Future<void> registerListeners(CallSession session) async {
    if (!session.callHasEnded) {
      overlayMinimised = false;
    }
    Logs().d('[VOIP] registerListeners — ${session.direction.name}');

    session.onCallStateChanged.stream.listen((state) async {
      Logs().d('[CALL STATE] $state');

      switch (state) {
        case CallState.kRinging:
          if (session.direction == CallDirection.kIncoming) {
            await UserMediaManager().startIncomingRingtone();
          } else {
            await UserMediaManager().startOutgoingRingtone();
          }
          break;

        case CallState.kConnected:
          await UserMediaManager().stopRingingTone();
          break;

        case CallState.kEnded:
          await UserMediaManager().stopRingingTone();
          break;

        default:
          break;
      }
    });
  }

  Future<bool> get hasCallingAccount async => false;
  @override
  Future<void> playRingtone() async {}

  @override
  Future<void> stopRingtone() async {}
}
