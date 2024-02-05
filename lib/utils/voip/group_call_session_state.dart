import 'dart:async';

import 'package:matrix/matrix.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'call_state_proxy.dart';

class GroupCallSessionState implements CallStateProxy {
  Function()? callback;
  final GroupCallSession _groupCall;
  final VoipPlugin _voipPlugin;
  GroupCallSessionState(this._groupCall, this._voipPlugin) {
    _groupCall.onGroupCallEvent.stream.listen((event) {
      Logs().d('[GroupCallSessionState] onGroupCallEvent ${event.toString()}');
      callback?.call();
    });

    _groupCall.onGroupCallState.stream.listen((state) async {
      Logs().d('[GroupCallSessionState] onGroupCallState ${state.toString()}');
      if (state == GroupCallState.Entered) {
        _voipPlugin.connectedTsSinceEpoch =
            DateTime.now().millisecondsSinceEpoch;
        if (PlatformInfos.isMobile) {
          await WakelockPlus.enable();
          await vibrate();
        }
      } else if ({
        GroupCallState.LocalCallFeedUninitialized,
        GroupCallState.Ended,
      }.contains(state)) {
        // uninititalized when call not terminated, still has participant
        _voipPlugin.connectedTsSinceEpoch = 0;
        if (PlatformInfos.isMobile) {
          await WakelockPlus.disable();
          await vibrate();
        }
      }
      callback?.call();
    });

    _groupCall.onStreamAdd.stream.listen((event) {
      Logs().d('[GroupCallSessionState] onStreamAdd ${event.toString()}');
      callback?.call();
    });
    _groupCall.onStreamRemoved.stream.listen((event) {
      Logs().d('[GroupCallSessionState] onStreamRemoved ${event.toString()}');
      callback?.call();
    });
  }

  Future<void> vibrate() async {
    try {
      await Vibration.vibrate(duration: 100);
    } catch (e) {
      Logs().e('[Dialer] could not vibrate for call updates');
    }
  }

  @override
  Future<void> answer() async {
    // TODO: implement answer
  }

  @override
  Stream get callEventStream => _groupCall.onGroupCallEvent.stream;

  @override
  Stream get callStateStream => _groupCall.onGroupCallState.stream;

  @override
  bool get callOnHold => false;

  @override
  String get callState => _groupCall.state;

  @override
  bool get connected => _groupCall.state == GroupCallState.Entered;

  @override
  bool get connecting => _groupCall.state == GroupCallState.Entering;

  @override
  bool get answering => _groupCall.state == GroupCallState.Entering;

  @override
  GroupCallSession get groupCall => _groupCall;

  @override
  CallSession? get call => null;

  @override
  String get displayName => _groupCall.room.getLocalizedDisplayname();

  @override
  bool get ended =>
      _groupCall.state == GroupCallState.Ended ||
      _groupCall.state == GroupCallState.LocalCallFeedUninitialized;

  @override
  Future<void> enter(WrappedMediaStream stream) async {
    await _groupCall.enter(
      stream: stream,
    );
    callback?.call();
  }

  @override
  Future<void> hangup() async {
    await _groupCall.leave();
    callback?.call();
  }

  @override
  bool get isLocalVideoMuted => _groupCall.isLocalVideoMuted;

  @override
  bool get isMicrophoneMuted => _groupCall.isMicrophoneMuted;

  @override
  bool get isOutgoing => false;

  @override
  bool get isScreensharingEnabled => _groupCall.isScreensharing();

  @override
  bool get localHold => false;

  @override
  WrappedMediaStream? get localScreenSharingStream =>
      _groupCall.localScreenshareStream;

  @override
  WrappedMediaStream? get localUserMediaStream =>
      _groupCall.localUserMediaStream;

  @override
  void onUpdateViewCallback(Function() handler) {
    callback = handler;
  }

  @override
  WrappedMediaStream? get primaryStream => _groupCall.localUserMediaStream;

  @override
  bool get remoteOnHold => false;

  @override
  bool get ringingPlay => false;

  @override
  List<WrappedMediaStream> get screenSharingStreams =>
      _groupCall.screenshareStreams;

  @override
  List<WrappedMediaStream> get userMediaStreams => _groupCall.userMediaStreams;

  @override
  Future<void> setLocalVideoMuted(bool muted) async {
    await _groupCall.setLocalVideoMuted(muted);
    callback?.call();
  }

  @override
  Future<void> setMicrophoneMuted(bool muted) async {
    await _groupCall.setMicrophoneMuted(muted);
    callback?.call();
  }

  @override
  Future<void> setRemoteOnHold(bool onHold) async {
    // TODO: implement setRemoteOnHold
  }

  @override
  Future<void> setScreensharingEnabled(bool enabled) async {
    await _groupCall.setScreensharingEnabled(enabled, '');
    callback?.call();
  }

  @override
  bool get voiceonly => false;

  @override
  Room get room => _groupCall.room;

  @override
  Client get client => _groupCall.client;

  @override
  VoipType get type => VoipType.kGroup;
}
