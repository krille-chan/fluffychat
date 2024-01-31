import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/livekit_group_call_session_state.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../pages/voip/widgets/call_banner.dart';
import '../../pages/voip/widgets/call_overlay.dart';
import '../../utils/voip/call_session_state.dart';
import '../../utils/voip/call_state_proxy.dart';
import '../../utils/voip/famedly_key_provider_impl.dart';
import '../../utils/voip/incoming_call.dart';

enum VoipType { kVoice, kVideo, kGroup }

class MediaDevicesWrapper extends MediaDevices {
  MediaDevicesWrapper() {
    AppLifecycleListener(
      onResume: () {
        _appLifecycleStateResumeStream.sink.add(true);
      },
    );
  }
  final StreamController<bool> _appLifecycleStateResumeStream =
      StreamController<bool>.broadcast();

  // We only request mic/cam permissions during the first call (this is handled in
  // getUserMedia from flutter_webrtc). But if the first call happens when the
  // app is in background (in android), getUserMedia throws an exception and is
  // unable to request permissions.
  //
  // So, awaiting for _waitBeforeRequestingMediaPermission method will make sure
  // you wait till the app comes back to foreground (or timeout, whichever comes first).
  // If the respective media permissions for the call (mic for audio call,
  // mic+cam for video call) have already been granted, the method just returns.
  //
  // The expected behaviour is, only the push notification that the call has started
  // will be shown to users and no callkit ringing, if the respective media
  // permissions for the call haven't been granted. The user will click on the push
  // notification and the app will come to foreground, then getUserMedia will run.
  Future<void> _waitBeforeRequestingMediaPermission({
    required bool isVideoCall,
  }) async {
    // if android and not on web,
    if (kIsWeb || !Platform.isAndroid) return;
    // if mic permission not granted and if video call, mic+cam permission not granted,
    if (await Permission.microphone.isGranted &&
        (!isVideoCall || await Permission.camera.isGranted)) return;
    // if app currently isn't in foreground,
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return;
    }
    // then, wait till it comes to foreground.
    await Future.any([
      _appLifecycleStateResumeStream.stream.first,
      Future.delayed(CallTimeouts.callInviteLifetime),
    ]);
  }

  @override
  Future<List<webrtc_impl.MediaDeviceInfo>> enumerateDevices() =>
      webrtc_impl.navigator.mediaDevices.enumerateDevices();

  @override
  Future<webrtc_impl.MediaStream> getDisplayMedia(
    Map<String, dynamic> mediaConstraints,
  ) async {
    final mediaConstraintsCopy = Map<String, dynamic>.from(mediaConstraints);
    if (!kIsWeb && Platform.isIOS) {
      mediaConstraintsCopy['video'] = {'deviceId': 'broadcast'};
    }
    return webrtc_impl.navigator.mediaDevices
        .getDisplayMedia(mediaConstraintsCopy);
  }

  @override
  Future<List> getSources() =>
      webrtc_impl.navigator.mediaDevices.enumerateDevices();

  @override
  Future<webrtc_impl.MediaStream> getUserMedia(
    Map<String, dynamic> mediaConstraints,
  ) async {
    await _waitBeforeRequestingMediaPermission(
      isVideoCall: mediaConstraints.containsKey('video') &&
          mediaConstraints['video'] != false,
    );
    return webrtc_impl.navigator.mediaDevices.getUserMedia(mediaConstraints);
  }
}

class VoipPlugin implements WebRTCDelegate {
  static VoipPlugin? _instance;
  static CallStateProxy? currentCallProxy;

  final Client client;

  factory VoipPlugin.clientOnly(Client client) {
    _instance ??= VoipPlugin._(client);
    return _instance!;
  }

  /// dw it'll be there
  /// do not use this randomly everywhere, rare cases where you are either stuck
  /// with a context hack or this

  VoipPlugin._(this.client) {
    voip = VoIP(client, this);
    encryptionKeyProvider = FamedlyAppEncryptionKeyProviderImpl(client, this);
    if (PlatformInfos.isMobile) {
      IncomingCallManager(this).initialize();
    }
    Connectivity()
        .onConnectivityChanged
        .listen(_handleNetworkChanged)
        .onError((e) => _currentConnectivity = ConnectivityResult.none);
    Connectivity()
        .checkConnectivity()
        .then((result) => _currentConnectivity = result)
        .catchError((e) => _currentConnectivity = ConnectivityResult.none);
  }

  final MediaDevicesWrapper _mediaDevices = MediaDevicesWrapper();

  late FamedlyAppEncryptionKeyProviderImpl encryptionKeyProvider;

  late VoIP voip;
  ConnectivityResult? _currentConnectivity;

  /// the only time this is null is when `FamedlyApp` is not in the tree (eg: call when the app is not open)
  BuildContext get globalContext => FluffyChatApp.appGlobalKey.currentContext!;

  void setupCallAndOpenCallPage(CallStateProxy proxy) {
    final provider = Provider.of<AppState>(globalContext, listen: false);

    if (!FluffyThemes.isColumnMode(globalContext)) {
      provider.setGlobalBanner(CallBanner(proxy: proxy, voipPlugin: this));
    }

    if (FluffyThemes.isColumnMode(globalContext) &&
        currentCall != null &&
        currentGroupCall == null &&
        !currentCall!.isOutgoing) {
      createOverlay(proxy);
    } else {
      FluffyChatApp.router.go('/rooms/${proxy.room.id}/call');
    }
  }

  void onPhoneButtonTap(
    BuildContext context,
    Room room,
    VoipType callType,
  ) async {
    await startCall(context, room, callType);
  }

  void _handleNetworkChanged(ConnectivityResult result) async {
    /// Got a new connectivity status!
    if (_currentConnectivity != result) {
      voip.calls.forEach((_, sess) {
        sess.restartIce();
      });
    }
    _currentConnectivity = result;
  }

  CallSession? get currentCall =>
      voip.currentCID == null ? null : voip.calls[voip.currentCID];

  GroupCallSession? get currentGroupCall => voip.currentGroupCID == null
      ? null
      : voip.groupCalls[voip.currentGroupCID];

  bool getInMeetingState() {
    return currentCall != null || currentGroupCall != null;
  }

  @override
  MediaDevices get mediaDevices => _mediaDevices;

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

  int connectedTsSinceEpoch = 0;
  int onHoldMs = 0;

  @override
  Future<void> handleNewCall(CallSession call) async {
    Logs().d('[VoipPlugin] Handle new call');
    connectedTsSinceEpoch = 0;
    onHoldMs = 0;
    final callProxy = CallSessionState(call, this);
    currentCallProxy = callProxy;
    if (!call.isOutgoing && !kIsWeb && Platform.isAndroid) {
      await IncomingCallManager(this).showIncomingCall(call);
    } else {
      setupCallAndOpenCallPage(callProxy);
    }
    client.backgroundSync = true;
  }

  @override
  Future<void> handleCallEnded(CallSession call) async {
    try {
      Logs().d('[VoipPlugin] handleCallEnded');
      if (currentCallProxy != null &&
          currentCallProxy is CallSessionState &&
          currentCallProxy!.call?.callId == call.callId) {
        if (!kIsWeb && Platform.isAndroid) {
          await IncomingCallManager(this).endIncomingCall(call.callId);
          await FlutterForegroundTask.stopService();
        }
        Logs().d('[VoipPlugin] Handle 1:1 call ended');

        connectedTsSinceEpoch = 0;
        onHoldMs = 0;
        final provider = Provider.of<AppState>(globalContext, listen: false);
        provider.removeGlobalBanner();
        removeCallPopupOverlay();
        currentCallProxy = null;

        final path = '/rooms/${call.room.id}';

        if (FluffyChatApp.router.routerDelegate.currentConfiguration.uri
                .toString() ==
            '/rooms/${call.room.id}/call') {
          FluffyChatApp.router.go(path);
        }
      }
    } catch (e) {
      Logs().e('[VoipPlugin] handleCallEnded failed', e);
    }
  }

  @override
  Future<void> handleNewGroupCall(GroupCallSession groupCall) async {
    Logs().d('[VoipPlugin] new group call found');
  }

  @override
  Future<void> handleGroupCallEnded(GroupCallSession groupCall) async {
    try {
      if ((currentCallProxy is GroupCallSession ||
              currentCallProxy is LiveKitGroupCallSessionState) &&
          currentCallProxy != null &&
          currentCallProxy?.groupCall?.groupCallId == groupCall.groupCallId) {
        if (!kIsWeb && Platform.isAndroid) {
          await FlutterForegroundTask.stopService();
        }
        final provider = Provider.of<AppState>(globalContext, listen: false);
        provider.removeGlobalBanner();
        removeCallPopupOverlay();
        currentCallProxy = null;

        final roomPath = '/rooms/${groupCall.room.id}';
        if (FluffyChatApp.router.routerDelegate.currentConfiguration.uri
                .toString() ==
            '/rooms/${groupCall.room.id}/call') {
          FluffyChatApp.router.go(roomPath);
        }
      }
    } catch (e, s) {
      Logs().e('[VoipPlugin] handleGroupCallEnded failed', e, s);
    }
  }

  @override
  bool get canHandleNewCall =>
      voip.currentCID == null && voip.currentGroupCID == null;

  @override
  Future<void> handleMissedCall(CallSession call) async {
    try {
      if (currentGroupCall == null) {
        await IncomingCallManager(this).showMissedCallNotification(call);
      }
    } catch (e) {
      Logs().w('[VoipPlugin] unable to show missed call notification');
    }
  }

  final player = AudioPlayer();

  @override
  Future<void> playRingtone() async {
    try {
      if (kIsWeb || Platform.isIOS) {
        await player.setLoopMode(LoopMode.all);
        await player.setAudioSource(
          // https://pixabay.com/sound-effects/ringtone-126505
          AudioSource.asset('assets/sounds/ringtone.mp3'),
          initialIndex: 0,
          initialPosition: Duration.zero,
        );
        // don't want to block the UI
        unawaited(player.play());
      }
      Logs().d('[VoipPlugin] ringtone playing');
    } catch (e) {
      Logs().e('[VoipPlugin] unable to start ringtone', e);
    }
  }

  @override
  Future<void> stopRingtone() async {
    try {
      // TODO: remove ios once callkeep is implemented
      if (kIsWeb || Platform.isIOS) {
        if (player.playerState.playing) {
          // don't want to block the UI
          unawaited(player.stop());
        }
      }
    } catch (e) {
      Logs().e('[VoipPlugin] unable to stop ringtone', e);
    }
  }

  OverlayEntry? callPopupOverlayEntry;
  void createOverlay(CallStateProxy proxy) {
    callPopupOverlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) {
        return CallOverlay(
          callStateProxy: proxy,
          voipPlugin: this,
        );
      },
    );

    Overlay.of(globalContext).insert(callPopupOverlayEntry!);
  }

  void createMinimizer(CallStateProxy proxy) async {
    if (FluffyThemes.isColumnMode(globalContext)) {
      Provider.of<AppState>(globalContext, listen: false).removeGlobalBanner();
      createOverlay(proxy);
    } else {
      removeCallPopupOverlay();
      Provider.of<AppState>(globalContext, listen: false)
          .setGlobalBanner(CallBanner(proxy: proxy, voipPlugin: this));
    }
  }

  // Remove the OverlayEntry.
  void removeCallPopupOverlay() {
    callPopupOverlayEntry?.remove();
    callPopupOverlayEntry = null;
  }

  Future<void> startCall(
    BuildContext context,
    Room room,
    VoipType callType,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final voipPlugin = Matrix.of(context).voipPlugin;
    if ({VoipType.kVideo, VoipType.kVoice}.contains(callType) &&
        room.isDirectChat) {
      if (currentCallProxy != null) {
        setupCallAndOpenCallPage(currentCallProxy!);
        return;
      }

      try {
        await voipPlugin.voip.inviteToCall(
          room.id,
          callType == VoipType.kVoice ? CallType.kVoice : CallType.kVideo,
          room.directChatMatrixID!,
        );

        // force null check here because handleNewCall is triggered in the above line anyway
        setupCallAndOpenCallPage(currentCallProxy!);
      } catch (e, s) {
        Logs().e('startCall', e, s);
      }
    } else if (callType == VoipType.kGroup) {
      if (voipPlugin.currentGroupCall != null &&
          (currentCallProxy is GroupCallSession ||
              currentCallProxy is LiveKitGroupCallSessionState) &&
          currentCallProxy != null) {
        setupCallAndOpenCallPage(currentCallProxy!);
      } else if (currentCallProxy == null) {
        FluffyChatApp.router.go('/rooms/${room.id}/group_call_onboarding');
      }
    }
  }

  String getCallStateSuffix(CallStateProxy proxy, BuildContext context) {
    if (proxy.connecting) {
      return L10n.of(context)!.connecting;
    }
    if (proxy.answering) {
      return L10n.of(context)!.answering;
    }
    if (proxy.ended) {
      return L10n.of(context)!.ended;
    }
    if (proxy is CallSessionState) {
      if (proxy.isOutgoing) {
        return L10n.of(context)!.calling;
      }
      if (!proxy.isOutgoing) {
        return L10n.of(context)!.incomingCall;
      }
      if (proxy.ringingPlay) {
        return L10n.of(context)!.ringing;
      }
    }

    return 'Unknown state';
  }

  @override
  EncryptionKeyProvider? get keyProvider => encryptionKeyProvider;
}
