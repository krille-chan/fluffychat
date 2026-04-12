import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:matrix/matrix.dart';

class EncryptionKeyProvidorImpl implements EncryptionKeyProvider {
  EncryptionKeyProvidorImpl({int keyRingSize = 16, int ratchetWindowSize = 16})
    : _keyRingSize = keyRingSize,
      _ratchetWindowSize = ratchetWindowSize;

  final int _keyRingSize;
  final int _ratchetWindowSize;
  KeyProvider? _keyProvider;

  Future<KeyProvider> _ensureKeyProvider() async {
    final existingProvider = _keyProvider;
    if (existingProvider != null) {
      return existingProvider;
    }
    final createdProvider = await frameCryptorFactory.createDefaultKeyProvider(
      KeyProviderOptions(
        sharedKey: false,
        ratchetSalt: _randomBytes(32),
        ratchetWindowSize: _ratchetWindowSize,
        keyRingSize: _keyRingSize,
        discardFrameWhenCryptorNotReady: true,
      ),
    );
    _keyProvider = createdProvider;
    return createdProvider;
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  @override
  Future<Uint8List> onExportKey(CallParticipant participant, int index) async =>
      (await _ensureKeyProvider()).exportKey(
        participantId: participant.id,
        index: index,
      );

  @override
  Future<Uint8List> onRatchetKey(
    CallParticipant participant,
    int index,
  ) async => (await _ensureKeyProvider()).ratchetKey(
    participantId: participant.id,
    index: index,
  );

  @override
  Future<void> onSetEncryptionKey(
    CallParticipant participant,
    Uint8List key,
    int index,
  ) async {
    await (await _ensureKeyProvider()).setKey(
      participantId: participant.id,
      index: index,
      key: key,
    );
  }

  Future<void> dispose() async {
    final provider = _keyProvider;
    _keyProvider = null;
    await provider?.dispose();
  }
}
