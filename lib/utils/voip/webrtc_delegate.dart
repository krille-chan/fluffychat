import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' show RTCFactoryNative;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart';

class AppWebRTCDelegate implements WebRTCDelegate {
  @override
  bool get canHandleNewCall => false;

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) {
    // TODO: implement createPeerConnection
    throw UnimplementedError();
  }

  @override
  Future<void> handleCallEnded(CallSession session) {
    // TODO: implement handleCallEnded
    throw UnimplementedError();
  }

  @override
  Future<void> handleGroupCallEnded(GroupCallSession groupCall) {
    // TODO: implement handleGroupCallEnded
    throw UnimplementedError();
  }

  @override
  Future<void> handleMissedCall(CallSession session) {
    // TODO: implement handleMissedCall
    throw UnimplementedError();
  }

  @override
  Future<void> handleNewCall(CallSession session) {
    // TODO: implement handleNewCall
    throw UnimplementedError();
  }

  @override
  Future<void> handleNewGroupCall(GroupCallSession groupCall) {
    // TODO: implement handleNewGroupCall
    throw UnimplementedError();
  }

  @override
  bool get isWeb => kIsWeb;

  @override
  // TODO: implement keyProvider
  EncryptionKeyProvider? get keyProvider => throw UnimplementedError();

  @override
  MediaDevices get mediaDevices =>
      RTCFactoryNative.instance.navigator.mediaDevices;

  @override
  Future<void> playRingtone() {
    // TODO: implement playRingtone
    throw UnimplementedError();
  }

  @override
  Future<void> registerListeners(CallSession session) {
    // TODO: implement registerListeners
    throw UnimplementedError();
  }

  @override
  Future<void> stopRingtone() {
    // TODO: implement stopRingtone
    throw UnimplementedError();
  }
}
