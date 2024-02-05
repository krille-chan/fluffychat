import 'dart:typed_data';

import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/voip/voip_plugin.dart';

class FamedlyAppEncryptionKeyProviderImpl implements EncryptionKeyProvider {
  final Client client;
  final VoipPlugin voip;

  FamedlyAppEncryptionKeyProviderImpl(this.client, this.voip) {
    _initFuture = init();
  }
  late Future _initFuture;

  late lk.BaseKeyProvider _keyProvider;

  lk.BaseKeyProvider get keyProvider => _keyProvider;

  Future<void> init() async {
    _keyProvider = await lk.BaseKeyProvider.create(
      sharedKey: false,
      ratchetWindowSize: 16,
      failureTolerance: -1,
    );
  }

  @override
  Future<void> onSetEncryptionKey(
    Participant participant,
    String key,
    int index,
  ) async {
    await _initFuture;
    await _keyProvider.setKey(
      key,
      keyIndex: index,
      participantId: participant.id,
    );
    Logs().i(
      'onSetEncryptionKey Set key for ${participant.id}, key = $key, index = $index,',
    );
  }

  @override
  Future<Uint8List> onExportKey(Participant participant, int index) async {
    await _initFuture;
    final key = await _keyProvider.exportKey(participant.id, index);
    Logs().i(
      'onExportKey Got key for ${participant.id}, key = $key, index = $index,',
    );
    return key;
  }

  @override
  Future<Uint8List> onRatchetKey(Participant participant, int index) async {
    await _initFuture;
    final key = await _keyProvider.ratchetKey(participant.id, index);
    Logs().i(
      'onRatchetKey Ratched key for ${participant.id}, new key = $key, index = $index,',
    );
    return key;
  }
}
