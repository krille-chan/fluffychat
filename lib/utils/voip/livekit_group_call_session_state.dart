import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:matrix/matrix.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webrtc_interface/webrtc_interface.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'call_state_proxy.dart';
import 'livekit_stream.dart';

class LiveKitGroupCallSessionState implements CallStateProxy {
  Function()? callback;
  final GroupCallSession _groupCall;
  final VoipPlugin voipPlugin;
  livekit.Room? lkRoom;

  /// livekitstreams
  final List<LivekitParticipantStream> _userMediaStreams = [];

  /// livekitstreams
  final List<LivekitParticipantStream> _screenSharingStreams = [];

  LiveKitGroupCallSessionState(this._groupCall, this.voipPlugin) {
    _groupCall.onGroupCallEvent.stream.listen((event) {
      Logs().d(
        '[LiveKitGroupCallSessionState] onGroupCallEvent ${event.toString()}',
      );
      callback?.call();
    });

    _groupCall.onGroupCallState.stream.listen((state) async {
      Logs().d(
        '[LiveKitGroupCallSessionState] onGroupCallState ${state.toString()}',
      );
      if (state == GroupCallState.Entered) {
        voipPlugin.connectedTsSinceEpoch =
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
        voipPlugin.connectedTsSinceEpoch = 0;
        if (PlatformInfos.isMobile) {
          await WakelockPlus.disable();
          await vibrate();
        }
      }
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
  Future<void> answer() async {}

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
    await _groupCall.enter();

    if (_groupCall.isLivekitCall && _groupCall.state != GroupCallState.Ended) {
      try {
        final sfuConfig = await getSFUConfigWithOpenID(
          client: client,
          roomName: _groupCall.room.id,
          groupCall: _groupCall,
        );
        if (sfuConfig == null) {
          Logs().w('Failed to get SFU config for group call');
          return;
        }
        await join(
          groupCall: _groupCall,
          enableE2EE: false,
          sfuConfig: sfuConfig,
          stream: stream,
        );
      } catch (e) {
        Logs().e('Failed to get SFU config for group call', e);
        return;
      }
    }
    callback?.call();
  }

  @override
  Future<void> hangup() async {
    await _groupCall.leave();
    if (_groupCall.isLivekitCall) {
      if (lkRoom != null) {
        await lkRoom?.disconnect();
        await _groupCall.localUserMediaStream?.dispose();
        _groupCall.localUserMediaStream = null;
      }
    }
    callback?.call();
  }

  @override
  bool get isLocalVideoMuted =>
      !(lkRoom?.localParticipant?.isCameraEnabled() ?? false);

  @override
  bool get isMicrophoneMuted =>
      !(lkRoom?.localParticipant?.isMicrophoneEnabled() ?? false);

  @override
  bool get isScreensharingEnabled =>
      lkRoom?.localParticipant?.isScreenShareEnabled() ?? false;

  @override
  bool get isOutgoing => false;

  @override
  bool get localHold => false;

  @override
  WrappedMediaStream? get localScreenSharingStream =>
      screenSharingStreams.firstWhereOrNull((element) => element.isLocal());

  @override
  WrappedMediaStream? get localUserMediaStream =>
      userMediaStreams.firstWhereOrNull((element) => element.isLocal());

  @override
  List<WrappedMediaStream> get userMediaStreams => _userMediaStreams.toList();

  @override
  WrappedMediaStream? get primaryStream => localUserMediaStream;

  @override
  List<WrappedMediaStream> get screenSharingStreams =>
      _screenSharingStreams.toList();

  @override
  void onUpdateViewCallback(Function() handler) {
    callback = handler;
  }

  @override
  bool get remoteOnHold => false;

  @override
  bool get ringingPlay => false;

  @override
  Room get room => _groupCall.room;

  @override
  Future<void> setLocalVideoMuted(bool muted) async {
    await lkRoom?.localParticipant?.setCameraEnabled(!muted);
    localUserMediaStream?.setVideoMuted(muted);
    callback?.call();
  }

  @override
  Future<void> setMicrophoneMuted(bool muted) async {
    await lkRoom?.localParticipant?.setMicrophoneEnabled(!muted);
    localUserMediaStream?.setAudioMuted(muted);
    callback?.call();
  }

  @override
  Future<void> setRemoteOnHold(bool onHold) async {}

  @override
  Future<void> setScreensharingEnabled(bool enabled) async {
    enabled ? await _enableScreenShare() : await _disableScreenShare();
  }

  Future<void> _enableScreenShare() async {
    if (livekit.lkPlatformIs(livekit.PlatformType.iOS)) {
      final track = await livekit.LocalVideoTrack.createScreenShareTrack(
        const livekit.ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
          maxFrameRate: 15.0,
        ),
      );
      await lkRoom?.localParticipant?.publishVideoTrack(track);
      return;
    }
    await lkRoom?.localParticipant?.setScreenShareEnabled(true);
  }

  Future<void> _disableScreenShare() async {
    await lkRoom?.localParticipant?.setScreenShareEnabled(false);
  }

  @override
  VoipType get type => VoipType.kGroup;

  @override
  bool get voiceonly => false;

  @override
  Client get client => _groupCall.client;

  Future<void> join({
    required GroupCallSession groupCall,
    required SFUConfig sfuConfig,
    bool? enableE2EE,
    required WrappedMediaStream stream,
  }) async {
    livekit.E2EEOptions? e2eeOptions;
    if (enableE2EE == true) {
      e2eeOptions = livekit.E2EEOptions(
        keyProvider: voipPlugin.encryptionKeyProvider.keyProvider,
      );
    }

    livekit.FastConnectOptions? fastConnectOptions;

    fastConnectOptions = livekit.FastConnectOptions(
      microphone: livekit.TrackOption(enabled: !stream.audioMuted),
      camera: livekit.TrackOption(enabled: !stream.videoMuted),
    );

    // create new room
    lkRoom = livekit.Room(
      roomOptions: livekit.RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultAudioPublishOptions: const livekit.AudioPublishOptions(),
        defaultVideoPublishOptions: const livekit.VideoPublishOptions(),
        defaultScreenShareCaptureOptions: livekit.ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
          params: livekit.VideoParametersPresets.screenShareH1080FPS30,
        ),
        e2eeOptions: e2eeOptions,
        defaultCameraCaptureOptions: livekit.CameraCaptureOptions(
          maxFrameRate: 30,
          params: livekit.VideoParametersPresets.h720_169,
        ),
      ),
    );

    // Create a Listener before connecting
    final livekit.EventsListener<livekit.RoomEvent> listener =
        lkRoom!.createListener();

    await setUpListeners(lkRoom, listener, groupCall);

    await lkRoom!.connect(
      sfuConfig.url,
      sfuConfig.jwt,
      fastConnectOptions: fastConnectOptions,
    );

    Logs().i(
      'Connected to room ${lkRoom?.name}, local participant => ${lkRoom?.localParticipant!.identity}',
    );

    // we don't need the preview stream anymore? I think
    await stream.disposeRenderer();
    await stopMediaStream(stream.stream!);
  }

  Future<void> _sortParticipants(GroupCallSession groupCall) async {
    _userMediaStreams.clear();
    _screenSharingStreams.clear();

    final lkps = List<livekit.RemoteParticipant>.from(
      lkRoom?.participants.values.toList() ?? [],
    );
    for (final lkp in lkps) {
      // skip livekit participant updates that don't have a valid matrix event set
      if (!groupCall.participants.contains(Participant.fromId(lkp.identity))) {
        continue;
      }

      final remoteTrackPublications = List<livekit.RemoteTrackPublication>.from(
        lkp.trackPublications.values.toList(),
      );
      for (final t in remoteTrackPublications) {
        if (t.kind == livekit.TrackType.AUDIO) continue;

        final lkpStream = LivekitParticipantStream(
          lkParticipant: lkp,
          client: client,
          room: groupCall.room,
          participant: Participant.fromId(lkp.identity),
          audioMuted: !lkp.isMicrophoneEnabled(),
          videoMuted: t.isScreenShare
              ? !lkp.isScreenShareEnabled()
              : !lkp.isCameraEnabled(),
          stream: t.track?.mediaStream,
          renderer: voipPlugin.createRenderer(),
          isWeb: false,
          isGroupCall: true,
          purpose: t.isScreenShare
              ? SDPStreamMetadataPurpose.Screenshare
              : SDPStreamMetadataPurpose.Usermedia,
          publication: [t],
        );
        await lkpStream.initialize();
        if (t.isScreenShare) {
          if (_screenSharingStreams.contains(lkpStream)) continue;
          _screenSharingStreams.add(lkpStream);
        } else {
          if (_userMediaStreams.contains(lkpStream)) continue;
          _userMediaStreams.add(lkpStream);
        }
      }
    }
    // sort speakers for the grid
    _userMediaStreams.sort((a, b) {
      // loudest speaker first
      if (a.lkParticipant.isSpeaking && b.lkParticipant.isSpeaking) {
        if (a.lkParticipant.audioLevel > b.lkParticipant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.lkParticipant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.lkParticipant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.lkParticipant.hasVideo != b.lkParticipant.hasVideo) {
        return a.lkParticipant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.lkParticipant.joinedAt.millisecondsSinceEpoch -
          b.lkParticipant.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipantTracks = List<livekit.LocalTrackPublication>.from(
      lkRoom?.localParticipant?.trackPublications.values.toList() ?? [],
    );

    for (final t in localParticipantTracks) {
      if (t.kind == livekit.TrackType.AUDIO) continue;
      final lkp = lkRoom!.localParticipant!;

      final lkpStream = LivekitParticipantStream(
        lkParticipant: lkp,
        client: client,
        room: groupCall.room,
        participant: Participant.fromId(lkp.identity),
        audioMuted: !lkp.isMicrophoneEnabled(),
        videoMuted: t.isScreenShare
            ? !lkp.isScreenShareEnabled()
            : !lkp.isCameraEnabled(),
        stream: t.track?.mediaStream,
        renderer: voipPlugin.createRenderer(),
        isWeb: false,
        isGroupCall: true,
        purpose: t.isScreenShare
            ? SDPStreamMetadataPurpose.Screenshare
            : SDPStreamMetadataPurpose.Usermedia,
        publication: [t],
      );
      await lkpStream.initialize();
      if (t.isScreenShare) {
        if (_screenSharingStreams.contains(lkpStream)) continue;
        _screenSharingStreams.add(lkpStream);
      } else {
        if (_userMediaStreams.contains(lkpStream)) continue;
        _userMediaStreams.add(lkpStream);
      }
    }

    callback?.call();
  }

  Future<void> setUpListeners(
    room,
    livekit.EventsListener<livekit.RoomEvent> listener,
    GroupCallSession groupCall,
  ) async {
    listener.on((livekit.RoomDisconnectedEvent event) async {
      Logs().i('RoomDisconnectedEvent');
      if (event.reason != null) {
        Logs().i('Room disconnected: reason => ${event.reason}');
      }
      await groupCall.leave();
    });
    listener.on((livekit.LocalTrackPublishedEvent event) async {
      Logs().i(
        'LocalTrackPublishedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.LocalTrackUnpublishedEvent event) async {
      Logs().i(
        'LocalTrackUnpublishedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.TrackSubscribedEvent event) async {
      Logs().i(
        'TrackSubscribedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.TrackUnsubscribedEvent event) async {
      Logs().i(
        'TrackUnsubscribedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.ParticipantNameUpdatedEvent event) async {
      Logs().i('ParticipantNameUpdatedEvent');
      callback?.call();
    });

    listener.on((livekit.DataReceivedEvent event) async {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (_) {
        Logs().e('Failed to decode: $_');
      }
      Logs()
          .i('Data received: ${event.participant?.identity}, data => $decoded');
    });

    listener.on((livekit.TrackMutedEvent event) async {
      Logs().i(
        'TrackMutedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.TrackUnmutedEvent event) async {
      Logs().i(
        'TrackUnmutedEvent, p: ${event.participant.identity}, sid: ${event.publication.sid}, kind: ${event.publication.track?.kind}, screenShare: ${event.publication.isScreenShare}',
      );
      await _sortParticipants(groupCall);
    });

    listener.on((livekit.TrackE2EEStateEvent event) async {
      Logs().i(
        'TrackE2EEStateEvent: ${event.participant.identity}, ${event.publication.sid} state: ${event.state}',
      );
      final participant = Participant.fromId(event.participant.identity);
      if (event.state == livekit.E2EEState.kMissingKey &&
          participant != voipPlugin.voip.localParticipant) {
        Logs().i('TrackE2EEStateEvent: requesting keys from ${participant.id}');
        await groupCall.requestEncrytionKey(
          [participant],
        );
      }
      await _sortParticipants(groupCall);
    });
  }

  Future<void> stopMediaStream(MediaStream? stream) async {
    if (stream != null) {
      for (final track in stream.getTracks()) {
        try {
          await track.stop();
        } catch (e, s) {
          Logs().e('[VOIP] stopping track ${track.id} failed', e, s);
        }
      }
      try {
        await stream.dispose();
      } catch (e, s) {
        Logs().e('[VOIP] disposing stream ${stream.id} failed', e, s);
      }
    }
  }
}

/// lk token processing
/// The livekitServiceURL is usually set by the participant who created the
/// meeting, and everyone who joins later needs to use the same livekitServiceURL
/// 1, request a openID token from our matrix server
/// 2, use the { openIDToken, roomId,deviceId } to request a SFUConfig from the lk jwt service,
/// `lk-jwt-service` will use openIdToken to go to our matrix server to verify the validity of the client.
/// and then we will get a jwt and a url from the livekit server
/// 3, put jwt/url to the livekit-flutter-sdk to connect to the livekit server
Future<SFUConfig?> getSFUConfigWithOpenID({
  required Client client,
  required String roomName,
  required GroupCallSession groupCall,
}) async {
  final openIdToken = await client.requestOpenIdToken(client.userID!, {});
  Logs().d('Got openID token of type ${openIdToken.tokenType}');
  if (groupCall.isLivekitCall) {
    final backend = (groupCall.backends.first as LiveKitBackend);
    try {
      Logs().i(
        'Trying to get JWT from call\'s configured URL of ${backend.livekitServiceUrl}...',
      );
      final sfuConfig = await getLiveKitJWT(
        client,
        backend.livekitServiceUrl,
        roomName,
        openIdToken,
      );
      Logs().i('Got JWT from call state event URL.');

      return sfuConfig;
    } catch (e) {
      Logs().w(
        'Failed to get JWT from group call\'s configured URL of ${backend.livekitServiceUrl}. $e',
      );
    }
  }
  const urlFromConf = AppConfig.livekitServiceUrl;
  Logs().i('Trying livekit service URL from our config: $urlFromConf...');
  try {
    final sfuConfig =
        await getLiveKitJWT(client, urlFromConf, roomName, openIdToken);

    Logs()
        .i('Got JWT, updating call livekit service URL with: $urlFromConf...');

    return sfuConfig;
  } catch (e) {
    Logs().e('Failed to get JWT from URL defined in Config.', e);
    rethrow;
  }
}

/// identity for the user is set in livekit-jwt-service (currently userId:deviceId)
Future<SFUConfig> getLiveKitJWT(
  Client client,
  String livekitServiceURL,
  String roomName,
  OpenIdCredentials openIdCredentials,
) async {
  try {
    final res = await http.post(
      Uri.parse('$livekitServiceURL/sfu/get'), // element compantibilty
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'room': roomName,
        'openid_token': {
          'access_token': openIdCredentials.accessToken,
          'token_type': openIdCredentials.tokenType,
          'matrix_server_name': openIdCredentials.matrixServerName,
        },
        'device_id': client.deviceID!,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception(
        'SFU Config fetch failed with status code #${res.statusCode}',
      );
    }
    return SFUConfig.fromJson(jsonDecode(res.body));
  } catch (e) {
    throw Exception(
      'SFU Config fetch failed with exception $e',
    );
  }
}
