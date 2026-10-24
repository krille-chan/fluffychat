// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/call_kit_params.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_call.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_room_client_extensions.dart';
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
  bool startWithAudio = true;
  bool isLoading = false;
  Object? error;
  String? focusedTrack;
}

class CallViewModel extends ValueNotifier<CallViewModelState> {
  final Room room;
  MatrixRtcCall? call;
  final AudioPlayer _audioPlayer = AudioPlayer();
  DateTime? startTime;
  bool waitForOtherSide = false;
  String? callKitId;

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

  Future<void> _init() async {
    await WakelockPlus.enable();
    await lk.LiveKitClient.initialize();

    // kHKDF matches the key derivation used by element-web's LiveKit JS SDK
    final keyProviderOptions = rtc.KeyProviderOptions(
      sharedKey: false,
      ratchetSalt: Uint8List.fromList('LKFrameEncryptionKey'.codeUnits),
      ratchetWindowSize: 0,
      discardFrameWhenCryptorNotReady: true,
      keyDerivationAlgorithm: rtc.KeyDerivationAlgorithm.kHKDF,
      keyRingSize: 255,
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
        defaultScreenShareCaptureOptions: lk.ScreenShareCaptureOptions(
          useiOSBroadcastExtension: PlatformInfos.isIOS,
        ),
        defaultAudioOutputOptions: lk.AudioOutputOptions(
          speakerOn: PlatformInfos.isMobile,
        ),
        encryption: lk.E2EEOptions(keyProvider: baseKeyProvider),
      ),
    );

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
        Logs().i(
          'E2EE event from ${event.participant} (${event.publication})',
          event.state,
        );
        return;
      }
      if (event.state == .kMissingKey) {
        Logs().d('Waiting for call key...', event);
        return;
      }
      Logs().e('LiveKit E2EE Error', event);
    });

    liveKitRoom.addListener(notifyListeners);

    if (room.isDirectChat && room.hasActiveMatrixRtcCall) {
      await connect();
    } else {
      value.localVideoTrack = await lk.LocalVideoTrack.createCameraTrack();
      if (room.getActiveMatrixRtcMembers().firstOrNull?.callIntent == .voice) {
        value.localVideoTrack?.mute();
      }
      value.localVideoTrack?.addListener(notifyListeners);
      notifyListeners();
    }
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

  void togglePreviewMic() {
    value.startWithAudio = !value.startWithAudio;
    notifyListeners();
  }

  bool participantRaisedHand(String matrixId) =>
      call?.userHasHandRaised(matrixId) ?? false;

  Future<void> connect() async {
    try {
      value.isLoading = true;
      notifyListeners();
      final playWaitingSound =
          !room.hasActiveMatrixRtcCall && room.isDirectChat;

      final intent =
          room.getActiveMatrixRtcMembers().firstOrNull?.callIntent ??
          (value.localVideoTrack?.muted == false ? .video : .voice);
      if (PlatformInfos.isMobile) {
        await lk.AudioManager.instance.setSpeakerOutputPreferred(
          intent == .video,
        );
      }

      final call = this.call = await room.joinMatrixRtcCall(intent: intent);
      call.onNewKey.listen((newKey) async {
        await _keyProvider!.setRawKey(
          newKey.key,
          keyIndex: newKey.index,
          participantId: newKey.participantId,
        );
        if (newKey.participantId == call.ownMembershipId) {
          await value.room?.e2eeManager?.setKeyIndex(
            newKey.index,
            participantIdentity: newKey.participantId,
          );
        }
      });
      call.onChanged.listen((_) => notifyListeners());
      call.onHandRaised.listen((_) => _playRaiseHandSound());

      final startWithVideo =
          !(value.localVideoTrack?.muted ?? intent == .voice);
      final startWithAudio = value.startWithAudio;
      await value.localVideoTrack?.stop();
      await value.localVideoTrack?.dispose();
      value.localVideoTrack = null;
      await value.room!.connect(
        call.credentials.url,
        call.credentials.jwt,
        fastConnectOptions: lk.FastConnectOptions(
          microphone: lk.TrackOption(
            track: startWithAudio ? await lk.LocalAudioTrack.create() : null,
          ),
          camera: lk.TrackOption(
            track: startWithVideo
                ? await lk.LocalVideoTrack.createCameraTrack()
                : null,
          ),
        ),
      );

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
          final params = await buildFluffyChatCallKitParams(
            room,
            intent: intent,
          );
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
    } catch (e, s) {
      Logs().e('Error while connecting', e, s);
      value.error = e;
      ErrorReporter(null, 'Unable to connect').onErrorCallback(e, s);
    } finally {
      value.isLoading = false;
      notifyListeners();
    }
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
          await call?.leave();
          call = null;
        },
      );
    }
    if (context.mounted) {
      Matrix.of(context).activeCallRoomId.value = null;
    }
  }

  @override
  void dispose() {
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
    }
    call?.leave();
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
    List<lk.MediaDevice> devices,
    String? activeDeviceId,
  ) async {
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
                      spacing: 12,
                      children: [
                        Icon(
                          device.deviceId == activeDeviceId
                              ? Icons.check_circle_outlined
                              : Icons.circle_outlined,
                        ),
                        Expanded(
                          child: Text(
                            device.label,
                            maxLines: 1,
                            overflow: .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
    );
  }

  Future<void> selectCamera(BuildContext context) async {
    final devices = await lk.Hardware.instance.videoInputs();
    if (!context.mounted) return;
    final source = await _selectMediaDevice(
      context,
      devices,
      value.room?.selectedVideoInputDeviceId,
    );
    if (source == null) return;
    await value.room?.setVideoInputDevice(source);
  }

  Future<void> selectMicrophone(BuildContext context) async {
    final devices = await lk.Hardware.instance.audioInputs();
    if (!context.mounted) return;
    final source = await _selectMediaDevice(
      context,
      devices,
      value.room?.selectedAudioInputDeviceId,
    );
    if (source == null) return;
    await value.room?.setAudioInputDevice(source);
  }

  Future<void> selectSpeaker(BuildContext context) async {
    final devices = await lk.Hardware.instance.audioOutputs();
    if (!context.mounted) return;
    if (devices.isEmpty && PlatformInfos.isMobile) {
      final preferSpeaker = lk.AudioManager.instance.isSpeakerOutputPreferred;
      final toggle = await showMenu<bool>(
        context: context,
        position: context.position,
        items: [
          PopupMenuItem(
            value: true,
            child: Row(
              mainAxisSize: .min,
              spacing: 12,
              children: [
                Icon(
                  preferSpeaker
                      ? Icons.check_circle_outlined
                      : Icons.circle_outlined,
                ),
                Expanded(
                  child: Text(
                    L10n.of(context).preferSpeaker,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      if (toggle == null) return;
      await lk.AudioManager.instance.setSpeakerOutputPreferred(!preferSpeaker);
      return;
    }
    final source = await _selectMediaDevice(
      context,
      devices,
      value.room?.selectedAudioOutputDeviceId,
    );
    if (source == null) return;
    await value.room?.setAudioOutputDevice(source);
  }
}
