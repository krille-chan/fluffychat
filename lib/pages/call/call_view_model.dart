// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/call_keys_event_content.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call_member.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:matrix/matrix.dart';

class CallViewModelState {
  lk.Room? room;
  lk.LocalVideoTrack? localVideoTrack;
  lk.LocalAudioTrack? localAudioTrack;
}

class CallViewModel extends ValueNotifier<CallViewModelState> {
  final Room room;
  final player = AudioPlayer();
  StreamSubscription? _onCallEncryptionKeysSub, _onCallMembersChanged;

  Set<String> _lastSharedParticipants = {};
  DateTime? _keyCreatedAt;
  Uint8List? _lastKey;

  lk.BaseKeyProvider? _keyProvider;

  CallViewModel({required this.room}) : super(CallViewModelState()) {
    _init();
  }

  Future<void> _onCallEncryptionKeys(CallKeysEvent event) async {
    final callKeys = event.callKeysContent;
    final keyProvider = _keyProvider;
    if (keyProvider == null) {
      ErrorReporter(
        null,
        'Received a new key but the keyProvider is not ready yet!',
      ).onErrorCallback(Exception(), StackTrace.current);
      return;
    }

    await keyProvider.setRawKey(
      base64Decode(callKeys.keys.key),
      participantId: '${event.sender}:${callKeys.member.claimedDeviceId}',
      keyIndex: callKeys.keys.index,
    );
  }

  Future<void> _createKeyAndShare() async {
    final liveKitRoom = value.room;
    if (liveKitRoom == null) return;

    final ownMemberId = '${room.client.userID}:${room.client.deviceID}';

    final currentParticipants =
        room
            .getActiveMatrixRtcMembers()
            .map((member) => member.membershipId)
            .whereType<String>()
            .toSet()
          ..remove(ownMemberId);

    if (setEquals(currentParticipants, _lastSharedParticipants) &&
        currentParticipants.isNotEmpty) {
      Logs().d(
        'Participant list has not changed. No need to share keys again!',
      );
      return;
    }

    var index = liveKitRoom.roomOptions.encryption!.keyProvider.getLatestIndex(
      ownMemberId,
    );

    final keyCreatedAt = _keyCreatedAt;
    final canJustForwardToNewUsers =
        keyCreatedAt != null &&
        DateTime.now().difference(keyCreatedAt).inSeconds < 15 &&
        _lastSharedParticipants.difference(currentParticipants).isEmpty;

    late final Uint8List key;
    if (_lastKey == null || !canJustForwardToNewUsers) {
      // Key generation
      final rng = Random.secure();
      key = Uint8List(16);
      key.setAll(0, Iterable.generate(key.length, (i) => rng.nextInt(256)));
      if (_lastKey != null) index = (index + 1) % 256;

      await liveKitRoom.roomOptions.encryption!.keyProvider.setRawKey(
        key,
        keyIndex: index,
        participantId: ownMemberId,
      );
      _keyCreatedAt = DateTime.now();
      _lastKey = key;
      if (_lastKey != null) {
        await liveKitRoom.e2eeManager?.setKeyIndex(
          index,
          participantIdentity: ownMemberId,
        );
      }
    } else {
      key = _lastKey!;
    }

    final forwardParticipants = canJustForwardToNewUsers
        ? currentParticipants.difference(_lastSharedParticipants)
        : currentParticipants;
    final deviceKeys = <DeviceKeys>[];
    for (final membershipId in forwardParticipants) {
      final membershipParts = membershipId.split(':');
      final deviceId = membershipParts.removeLast();
      final userId = membershipParts.join(':');
      final keys = room.client.userDeviceKeys[userId]?.deviceKeys[deviceId];
      if (keys == null) {
        Logs().w('No device keys found for $membershipId');
        continue;
      }
      deviceKeys.add(keys);
    }

    _lastSharedParticipants = currentParticipants;
    await room.shareMatrixRtcCallKey(
      key: key,
      index: index,
      memberId: ownMemberId,
      deviceKeys: deviceKeys,
    );
  }

  Future<void> _init() async {
    _onCallEncryptionKeysSub = room.client.onCallEncryptionKeys.listen(
      _onCallEncryptionKeys,
    );
    _onCallMembersChanged = room.client.onSync.stream
        .where(
          (syncUpdate) =>
              syncUpdate.rooms?.join?[room.id]?.timeline?.events?.any(
                (event) => event.type == MatrixRtcCallMember.eventType,
              ) ??
              false,
        )
        .listen((_) => _createKeyAndShare());
    await lk.LiveKitClient.initialize();

    // kHKDF matches the key derivation used by element-web's LiveKit JS SDK
    final keyProviderOptions = rtc.KeyProviderOptions(
      sharedKey: false,
      ratchetSalt: Uint8List.fromList('LKFrameEncryptionKey'.codeUnits),
      ratchetWindowSize: 0,
      discardFrameWhenCryptorNotReady: true,
      keyDerivationAlgorithm: rtc.KeyDerivationAlgorithm.kHKDF,
    );
    final nativeKeyProvider = await rtc.frameCryptorFactory
        .createDefaultKeyProvider(keyProviderOptions);
    final baseKeyProvider = _keyProvider = lk.BaseKeyProvider(
      nativeKeyProvider,
      keyProviderOptions,
    );

    final liveKitRoom = value.room = lk.Room(
      roomOptions: lk.RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultAudioCaptureOptions: lk.AudioCaptureOptions(
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
          highPassFilter: true,
        ),
        encryption: lk.E2EEOptions(keyProvider: baseKeyProvider),
      ),
    );
    value.localVideoTrack = await lk.LocalVideoTrack.createCameraTrack();
    value.localVideoTrack?.addListener(notifyListeners);
    value.localAudioTrack = await lk.LocalAudioTrack.create();
    value.localAudioTrack?.addListener(notifyListeners);
    notifyListeners();

    liveKitRoom.events.on<lk.ParticipantConnectedEvent>(_playJoinSound);

    liveKitRoom.events.on<lk.ParticipantDisconnectedEvent>(_playLeaveSound);

    liveKitRoom.events.on<lk.TrackE2EEStateEvent>((event) {
      if (event.state == .kOk || event.state == .kNew) {
        Logs().i('E2EE event', event);
        return;
      }
      if (event.state == .kMissingKey) {
        Logs().d('Waiting for call key...', event);
        return;
      }
      Logs().e('LiveKit E2EE Error', event);
    });
    liveKitRoom.addListener(notifyListeners);
  }

  Future<void> togglePreviewCamera() async {
    final track = value.localVideoTrack;
    if (track == null) return;
    if (!track.muted) {
      await track.mute();
      return;
    }
    track.removeListener(notifyListeners);
    await track.stop();
    value.localVideoTrack = await lk.LocalVideoTrack.createCameraTrack();
    value.localVideoTrack?.addListener(notifyListeners);

    notifyListeners();
  }

  Future<void> togglePreviewMic() async {
    final track = value.localAudioTrack;
    if (track == null) return;
    if (!track.muted) {
      await track.mute();
      return;
    }
    track.removeListener(notifyListeners);
    await track.stop();
    value.localAudioTrack = await lk.LocalAudioTrack.create();
    value.localAudioTrack?.addListener(notifyListeners);

    notifyListeners();
  }

  Future<void> connect() async {
    final credentials = await room.joinMatrixRtcCall();
    await _createKeyAndShare();
    final video = value.localVideoTrack;
    final audio = value.localAudioTrack;
    value.localVideoTrack = value.localAudioTrack = null;
    await value.room!.connect(
      credentials.url,
      credentials.jwt,
      fastConnectOptions: lk.FastConnectOptions(
        microphone: lk.TrackOption(track: audio),
        camera: lk.TrackOption(track: video),
      ),
    );
    notifyListeners();
    _playJoinSound();
  }

  Future<void> close(BuildContext context) async {
    _playLeaveSound();
    final liveKitRoom = value.room;
    if (liveKitRoom != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          await liveKitRoom.disconnect();
          await liveKitRoom.dispose();
          value.room = null;
          await room.leaveMatrixRtcCall();
        },
      );
    }
    if (context.mounted) context.pop();
  }

  @override
  void dispose() {
    _onCallEncryptionKeysSub?.cancel();
    _onCallMembersChanged?.cancel();
    final liveKitRoom = value.room;
    if (liveKitRoom != null) {
      liveKitRoom.removeListener(notifyListeners);
      if (liveKitRoom.connectionState != lk.ConnectionState.disconnected) {
        liveKitRoom.disconnect();
      }
      liveKitRoom.dispose();
      room.leaveMatrixRtcCall();
    }
    player.dispose();
    super.dispose();
  }

  Future<void> _playJoinSound([_]) async {
    await player.setAsset('assets/sounds/call_join.mp3');
    await player.play();
  }

  Future<void> _playLeaveSound([_]) async {
    await player.setAsset('assets/sounds/call_leave.mp3');
    await player.play();
  }
}
