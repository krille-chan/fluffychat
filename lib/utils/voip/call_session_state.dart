import 'dart:async';

import 'package:all_sensors/all_sensors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'call_state_proxy.dart';

// maybe make it a singleton?

class CallSessionState implements CallStateProxy {
  final CallSession _call;
  Function()? callback;
  final VoipPlugin voipPlugin;
  AudioPlayer? _outgoingCallAudioPlayer;
  CallSessionState(this._call, this.voipPlugin) {
    StreamSubscription? proximitySubscription;
    int onHold = 0;
    int onUnhold = 0;
    _call.onCallEventChanged.stream.listen((CallEvent event) async {
      Logs().d('[CallSessionState] onCallEventChanged ${event.toString()}');
      // if (event == CallEvent.kError) {
      //   await ErrorReporter(
      //     call.lastError,
      //     StackTrace.current,
      //     level: SentryLevel.error,
      //   ).onErrorCallback(error);
      // }

      if (event == CallEvent.kState ||
          event == CallEvent.kFeedsChanged ||
          event == CallEvent.kLocalHoldUnhold ||
          event == CallEvent.kRemoteHoldUnhold) {
        if (event == CallEvent.kFeedsChanged) {
          await _call.tryRemoveStopedStreams();
        } else if ({CallEvent.kLocalHoldUnhold, CallEvent.kRemoteHoldUnhold}
            .contains(event)) {
          if (callOnHold) {
            onHold = DateTime.now().millisecondsSinceEpoch;
          } else {
            onUnhold = DateTime.now().millisecondsSinceEpoch;
            voipPlugin.onHoldMs = voipPlugin.onHoldMs + (onUnhold - onHold);
          }
          Logs().w(voipPlugin.onHoldMs.toString());
        }
        callback?.call();
      }
    });

    _call.onCallStateChanged.stream.listen((state) async {
      Logs().d('[CallSessionState] onCallStateChanged ${state.toString()}');

      if (_call.isOutgoing) {
        if (state == CallState.kInviteSent) {
          final player = _outgoingCallAudioPlayer = AudioPlayer();
          await player.setLoopMode(LoopMode.all);
          await player.setAudioSource(
            AudioSource.asset('assets/sounds/call.ogg'),
            initialIndex: 0,
            initialPosition: Duration.zero,
          );
          await player.play();
        } else if ({
          CallState.kConnecting,
          CallState.kConnected,
          CallState.kEnded,
        }.contains(state)) {
          await _outgoingCallAudioPlayer?.stop();
          _outgoingCallAudioPlayer = null;
        }
      }

      if (state == CallState.kConnected) {
        voipPlugin.connectedTsSinceEpoch =
            DateTime.now().millisecondsSinceEpoch;
        if (PlatformInfos.isMobile) {
          if (voiceonly) {
            // once you start listening to proximity stream remember to cancel it or
            // proximity sensor will keep turning off screen
            proximitySubscription =
                proximityEvents!.listen((ProximityEvent event) {});
          } else {
            await WakelockPlus.enable();
          }
          await vibrate();
        }
      } else if (state == CallState.kEnded) {
        voipPlugin.connectedTsSinceEpoch = 0;
        if (PlatformInfos.isMobile) {
          if (voiceonly) {
            await proximitySubscription?.cancel();
          } else {
            await WakelockPlus.disable();
          }
          await vibrate();
        }
      }
      callback?.call();
    });
  }

  @override
  GroupCallSession? get groupCall => null;

  @override
  CallSession get call => _call;

  Future<void> vibrate() async {
    try {
      await Vibration.vibrate(duration: 100);
    } catch (e) {
      Logs().e('[Dialer] could not vibrate for call updates');
    }
  }

  @override
  Stream get callEventStream => _call.onCallEventChanged.stream;
  @override
  Stream get callStateStream => _call.onCallStateChanged.stream;
  @override
  bool get voiceonly =>
      userMediaStreams.every((stream) => stream.videoMuted) &&
      screenSharingStreams.isEmpty;

  @override
  bool get connecting => _call.state == CallState.kConnecting;

  @override
  bool get answering => _call.state == CallState.kCreateAnswer;

  @override
  bool get connected => _call.state == CallState.kConnected;

  @override
  bool get ended => _call.state == CallState.kEnded;

  @override
  bool get isOutgoing => _call.isOutgoing;

  @override
  bool get ringingPlay => _call.state == CallState.kInviteSent;

  @override
  Future<void> answer() async {
    await _call.answer();
    callback?.call();
  }

  @override
  Future<void> enter(WrappedMediaStream stream) async {
    // TODO: implement enter
  }

  @override
  Future<void> hangup() async {
    if ({CallState.kRinging, CallState.kFledgling}.contains(_call.state)) {
      await _call.reject();
    } else {
      await _call.hangup();
    }
    callback?.call();
  }

  @override
  bool get isLocalVideoMuted => _call.isLocalVideoMuted;

  @override
  bool get isMicrophoneMuted => _call.isMicrophoneMuted;

  @override
  bool get localHold => _call.localHold;

  @override
  bool get remoteOnHold => _call.remoteOnHold;

  @override
  bool get isScreensharingEnabled => _call.screensharingEnabled;

  @override
  bool get callOnHold => _call.localHold || _call.remoteOnHold;

  @override
  Future<void> setLocalVideoMuted(bool muted) async {
    await _call.setLocalVideoMuted(muted);
    callback?.call();
  }

  @override
  Future<void> setMicrophoneMuted(bool muted) async {
    await _call.setMicrophoneMuted(muted);
    // TODO(Nico): Refactor this to be more granular
    callback?.call();
  }

  @override
  Future<void> setRemoteOnHold(bool onHold) async {
    await _call.setRemoteOnHold(onHold);
    callback?.call();
  }

  @override
  Future<void> setScreensharingEnabled(bool enabled) async {
    await _call.setScreensharingEnabled(enabled);
    callback?.call();
  }

  @override
  String get callState {
    switch (_call.state) {
      case CallState.kCreateAnswer:
      case CallState.kFledgling:
      case CallState.kWaitLocalMedia:
      case CallState.kCreateOffer:
        break;
      case CallState.kRinging:
        state = 'Ringing';
        break;
      case CallState.kInviteSent:
        state = 'Invite Sent';
        break;
      case CallState.kConnecting:
        state = 'Connecting';
        break;
      case CallState.kConnected:
        state = 'Connected';
        break;
      case CallState.kEnded:
        state = 'Ended';
        break;
    }
    return state;
  }

  String state = 'New Call';
  @override
  WrappedMediaStream? get localUserMediaStream => _call.localUserMediaStream;
  @override
  WrappedMediaStream? get localScreenSharingStream =>
      _call.localScreenSharingStream;

  @override
  List<WrappedMediaStream> get screenSharingStreams {
    final streams = <WrappedMediaStream>[];
    if (connected) {
      if (_call.remoteScreenSharingStream != null) {
        streams.add(_call.remoteScreenSharingStream!);
      }
      if (_call.localScreenSharingStream != null) {
        streams.add(_call.localScreenSharingStream!);
      }
    }
    return streams;
  }

  @override
  List<WrappedMediaStream> get userMediaStreams {
    final streams = <WrappedMediaStream>[];
    if (connected) {
      if (_call.remoteUserMediaStream != null) {
        streams.add(_call.remoteUserMediaStream!);
      }
      if (_call.localUserMediaStream != null) {
        streams.add(_call.localUserMediaStream!);
      }
    }
    return streams;
  }

  @override
  WrappedMediaStream? get primaryStream {
    if (screenSharingStreams.isNotEmpty) {
      return screenSharingStreams.first;
    }

    if (userMediaStreams.isNotEmpty) {
      return userMediaStreams.first;
    }

    if (!connected) {
      return _call.type == CallType.kVoice && !_call.isOutgoing
          ? _call.remoteUserMediaStream // show remote avatar on incoming call
          : _call.localUserMediaStream;
    }

    return _call.localScreenSharingStream ?? _call.localUserMediaStream;
  }

  @override
  String? get displayName => _call.room.getLocalizedDisplayname();

  @override
  void onUpdateViewCallback(Function() handler) {
    callback = handler;
  }

  @override
  Room get room => _call.room;

  @override
  Client get client => _call.client;

  @override
  VoipType get type =>
      _call.type == CallType.kVideo ? VoipType.kVideo : VoipType.kVoice;
}
