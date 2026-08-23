// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/call_kit_params.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/call_keys_event_content.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call_member.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/position_from_build_context.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:just_audio/just_audio.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CallViewModelState {
  lk.Room? room;
  lk.LocalVideoTrack? localVideoTrack;
  lk.LocalAudioTrack? localAudioTrack;
  String? focusedTrack;
}

class CallViewModel extends ValueNotifier<CallViewModelState> {
  final Room room;
  Timeline? timeline;
  final AudioPlayer _audioPlayer = AudioPlayer();
  DateTime? startTime;
  StreamSubscription? _onCallEncryptionKeysSub, _onCallMembersChanged;
  Timer? _resendCallMemberState;
  bool waitForOtherSide = false;
  String? callKitId;

  Set<String> _lastSharedParticipants = {};
  DateTime? _keyCreatedAt;
  Uint8List? _lastKey;

  lk.BaseKeyProvider? _keyProvider;

  CallViewModel({required this.room}) : super(CallViewModelState()) {
    _init();
  }

  void setFocusedTrack(String trackId) {
    Logs().d('Set focus on', trackId);
    if (value.focusedTrack == trackId) {
      value.focusedTrack = null;
    } else {
      value.focusedTrack = trackId;
    }
    notifyListeners();
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
    await WakelockPlus.enable();
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
    if (room.getActiveMatrixRtcMembers().firstOrNull?.callIntent == .voice) {
      value.localVideoTrack?.mute();
    }
    value.localVideoTrack?.addListener(notifyListeners);
    value.localAudioTrack = await lk.LocalAudioTrack.create();
    value.localAudioTrack?.addListener(notifyListeners);
    notifyListeners();

    liveKitRoom.events.on<lk.ParticipantConnectedEvent>((event) async {
      if (event.participant.identity ==
          liveKitRoom.localParticipant?.identity) {
        return;
      }
      if (waitForOtherSide) {
        waitForOtherSide = false;
        await _audioPlayer.stop();
        final callKitId = this.callKitId;
        if (callKitId != null) {
          await FlutterCallkitIncoming.setCallConnected(callKitId);
        }
      }
      _playJoinSound();
    });

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

  bool participantRaisedHand(String matrixId) {
    final timeline = this.timeline;
    if (timeline == null) return false;
    return room.participantRaisedHandInMatrixRtcCall(matrixId, timeline);
  }

  Future<void> _onNewTimelineEvent(int i) async {
    final event = timeline?.events[i];
    if (event == null) return;
    switch (event.type) {
      case 'io.element.call.reaction':
        Logs().d(
          'Call reactions are not yet handled',
          event.content.tryGet<String>('emoji'),
        );
        // TODO: handle reaction
        break;
      case EventTypes.Reaction:
        final reactedEvent = await timeline!.getEventById(
          event.relationshipEventId!,
        );
        if (reactedEvent != null &&
            reactedEvent.type == MatrixRtcCallMember.eventType &&
            event.senderId == reactedEvent.senderId &&
            event.content
                    .tryGetMap<String, Object?>('m.relates_to')
                    ?.tryGet<String>('key') ==
                '🖐️') {
          Logs().d('User raised hand!');
          _playRaiseHandSound();
          notifyListeners();
        }
        break;
      case EventTypes.Redaction:
        notifyListeners();
        break;
    }
  }

  Future<void> connect(BuildContext context) async {
    final l10n = L10n.of(context);
    final playWaitingSound = !room.hasActiveMatrixRtcCall && room.isDirectChat;

    final intent =
        room.getActiveMatrixRtcMembers().firstOrNull?.callIntent ??
        (value.localVideoTrack?.muted == false ? .video : .voice);

    final credentials = await room.joinMatrixRtcCall(intent: intent);
    timeline = await room.getTimeline(onInsert: _onNewTimelineEvent);
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

    _resendCallMemberState?.cancel();
    _resendCallMemberState = Timer.periodic(const Duration(hours: 1), (_) {
      final ownMembership = room.ownMatrixRtcMembership;
      if (ownMembership == null) {
        _resendCallMemberState?.cancel();
        return;
      }
      room.setMatrixRtcMembershipState(
        ownMembership.fociPreferred,
        intent: intent,
      );
    });
    startTime = DateTime.now();

    if (PlatformInfos.isMobile) {
      final activeCalls = await FlutterCallkitIncoming.activeCalls();
      callKitId = activeCalls
          .firstWhereOrNull(
            (call) =>
                call.extra?['roomId'] == room.id &&
                call.extra?['clientName'] == room.client.clientName,
          )
          ?.id;
      if (callKitId == null) {
        final params = buildFluffyChatCallKitParams(room, l10n, intent: intent);
        await FlutterCallkitIncoming.startCall(params);
        callKitId = params.id;
      }
    }
    if (playWaitingSound) {
      waitForOtherSide = true;
      _playWaitingSound();
    } else {
      final callKitId = this.callKitId;
      if (callKitId != null) {
        await FlutterCallkitIncoming.setCallConnected(callKitId);
      }
      _playJoinSound();
    }
    notifyListeners();
  }

  Future<void> close(BuildContext context) async {
    _playLeaveSound();
    final liveKitRoom = value.room;
    if (liveKitRoom != null) {
      liveKitRoom.removeListener(notifyListeners);
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          if (liveKitRoom.connectionState != lk.ConnectionState.disconnected) {
            await liveKitRoom.disconnect();
          }
          await liveKitRoom.dispose();
          value.room = null;
          if (room.ownMatrixRtcMembership != null) {
            await room.leaveMatrixRtcCall();
          }
        },
      );
    }
    if (context.mounted) {
      Matrix.of(context).activeCallRoomId.value = null;
    }
  }

  @override
  void dispose() {
    _onCallEncryptionKeysSub?.cancel();
    _onCallMembersChanged?.cancel();
    _resendCallMemberState?.cancel();
    timeline?.cancelSubscriptions();
    value.localAudioTrack?.dispose();
    value.localVideoTrack?.dispose();
    final callKitId = this.callKitId;
    if (callKitId != null) {
      FlutterCallkitIncoming.endCall(callKitId);
    }
    final liveKitRoom = value.room;
    if (liveKitRoom != null) {
      liveKitRoom.removeListener(notifyListeners);
      if (liveKitRoom.connectionState != lk.ConnectionState.disconnected) {
        liveKitRoom.disconnect();
      }
      liveKitRoom.dispose();
      room.leaveMatrixRtcCall();
    }
    _audioPlayer.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _playSoundIndex(
    AudioSource audioSource, {
    LoopMode loopMode = .off,
  }) async {
    if (_audioPlayer.playing) await _audioPlayer.stop();
    await _audioPlayer.setAudioSource(audioSource);
    if (_audioPlayer.loopMode != loopMode) {
      await _audioPlayer.setLoopMode(loopMode);
    }
    try {
      await _audioPlayer.play();
    } catch (e) {
      Logs().w('Unable to start audio player. Try again...', e);
      await Future.delayed(const Duration(milliseconds: 300));
      await _audioPlayer.play();
    }
  }

  final _joinSource = AudioSource.asset('assets/sounds/call_join.mp3');
  final _leaveSource = AudioSource.asset('assets/sounds/call_leave.mp3');
  final _raiseHandSource = AudioSource.asset(
    'assets/sounds/call_attention.mp3',
  );
  final _waitSource = AudioSource.asset('assets/sounds/call_wait.mp3');

  Future<void> _playJoinSound() => _playSoundIndex(_joinSource);

  Future<void> _playLeaveSound([_]) => _playSoundIndex(_leaveSource);

  Future<void> _playRaiseHandSound() => _playSoundIndex(_raiseHandSource);

  Future<void> _playWaitingSound() =>
      _playSoundIndex(_waitSource, loopMode: .all);

  Future<lk.MediaDevice?> _selectMediaDevice(
    BuildContext context,
    String type,
    String? activeDeviceId,
  ) async {
    final devices = await lk.Hardware.instance.enumerateDevices(type: type);
    if (!context.mounted) return null;
    return await showMenu<lk.MediaDevice>(
      context: context,
      position: context.position,
      items: devices.isEmpty
          ? [
              PopupMenuItem(
                enabled: false,
                child: Text(L10n.of(context).noDevicesFound),
              ),
            ]
          : devices
                .map(
                  (device) => PopupMenuItem(
                    value: device,
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          device.deviceId == activeDeviceId
                              ? Icons.check_circle_outlined
                              : Icons.circle_outlined,
                        ),
                        const SizedBox(width: 12),
                        Text(device.label),
                      ],
                    ),
                  ),
                )
                .toList(),
    );
  }

  Future<void> selectCamera(BuildContext context) async {
    final source = await _selectMediaDevice(
      context,
      'videoinput',
      value.room?.selectedVideoInputDeviceId,
    );
    if (source == null) return;
    await value.room?.setVideoInputDevice(source);
  }

  Future<void> selectMicrophone(BuildContext context) async {
    final source = await _selectMediaDevice(
      context,
      'audioinput',
      value.room?.selectedAudioInputDeviceId,
    );
    if (source == null) return;
    await value.room?.setAudioInputDevice(source);
  }
}
