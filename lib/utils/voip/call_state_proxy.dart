import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/voip/voip_plugin.dart';

abstract class CallStateProxy {
  String? get displayName;
  bool get isMicrophoneMuted;
  bool get isLocalVideoMuted;
  bool get isScreensharingEnabled;
  bool get localHold;
  bool get remoteOnHold;
  bool get answering;
  bool get voiceonly;
  bool get connecting;
  bool get connected;
  bool get ended;
  bool get callOnHold;
  bool get isOutgoing;
  bool get ringingPlay;
  String get callState;
  Room get room;
  Stream get callEventStream;
  Stream get callStateStream;
  Client get client;
  VoipType get type;
  GroupCallSession? get groupCall;
  CallSession? get call;

  Future<void> answer();

  Future<void> hangup();

  Future<void> enter(WrappedMediaStream stream);

  Future<void> setMicrophoneMuted(bool muted);

  Future<void> setLocalVideoMuted(bool muted);

  Future<void> setScreensharingEnabled(bool enabled);

  Future<void> setRemoteOnHold(bool onHold);

  WrappedMediaStream? get localUserMediaStream;

  WrappedMediaStream? get localScreenSharingStream;

  WrappedMediaStream? get primaryStream;

  List<WrappedMediaStream> get screenSharingStreams;

  List<WrappedMediaStream> get userMediaStreams;

  void onUpdateViewCallback(Function() callback);
}
