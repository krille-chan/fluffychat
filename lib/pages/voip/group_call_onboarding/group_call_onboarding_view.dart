import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../utils/voip/group_call_session_state.dart';
import '../../../utils/voip/livekit_group_call_session_state.dart';
import '../widgets/stream_view.dart';

class GroupCallOnboardingView extends StatefulWidget {
  const GroupCallOnboardingView({super.key, required this.roomId});
  final String roomId;

  @override
  State<GroupCallOnboardingView> createState() =>
      _GroupCallOnboardingViewState();
}

class _GroupCallOnboardingViewState extends State<GroupCallOnboardingView> {
  MediaStream? _localMediaStream;
  WrappedMediaStream? _localStream;
  Client get client => Matrix.of(context).client;

  late Room room;

  Future<void> setup() async {
    room = client.getRoomById(widget.roomId)!;

    final voipPlugin = Matrix.of(context).voipPlugin;

    _localMediaStream = await voipPlugin.mediaDevices.getUserMedia(
      {
        'audio': true,
        'video': {
          'mandatory': {
            'minWidth': '640',
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'facingMode': 'user',
          'optional': [],
        },
      },
    );

    _localStream = WrappedMediaStream(
      renderer: voipPlugin.createRenderer(),
      stream: _localMediaStream,
      participant:
          Participant(deviceId: client.deviceID!, userId: client.userID!),
      room: room,
      client: voipPlugin.client,
      purpose: SDPStreamMetadataPurpose.Usermedia,
      audioMuted: _localMediaStream!.getAudioTracks().isEmpty,
      videoMuted: _localMediaStream!.getVideoTracks().isEmpty,
      isWeb: voipPlugin.isWeb,
      isGroupCall: true,
    );

    await _localStream!.initialize();

    setState(() {});
    Logs().i(
      'setting up group calls onboarding page with localStream = $_localStream',
    );
  }

  @override
  void initState() {
    super.initState();
    setup();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  bool cancelButtonLoading = false;
  bool joinGroupCallButtonLoading = false;
  GroupCallSession? groupCallSession;

  @override
  Widget build(BuildContext context) {
    if (_localStream == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 120,
        leading: InkWell(
          onTap: _localStream == null
              ? null
              : () async {
                  if (cancelButtonLoading) return;
                  setState(() {
                    cancelButtonLoading = true;
                  });

                  await _localStream?.dispose();
                  await _localMediaStream?.dispose();
                  await groupCallSession?.leave();

                  if (mounted) {
                    setState(() {
                      cancelButtonLoading = false;
                    });
                  }
                  final path = '/rooms/${room.id}';
                  GoRouter.of(context).go(path);
                },
          child: Row(
            children: [
              const SizedBox(
                width: 16.0,
              ),
              if (cancelButtonLoading)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              if (!cancelButtonLoading) ...[
                const Icon(Icons.cancel, color: Colors.white),
                const SizedBox(
                  width: 12.0,
                ),
                Text(
                  L10n.of(context)!.cancel,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
      body: _localStream == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      L10n.of(context)!.joinGroupCall,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      room.getLocalizedDisplayname(),
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        height: 200,
                        width:
                            min(343, MediaQuery.of(context).size.width * 0.9),
                        child: _localStream!.videoMuted
                            ? Center(
                                child: Text(
                                  L10n.of(context)!.cameraTurnedOff,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                ),
                              )
                            : StreamView(wrappedStream: _localStream!),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _localStream!
                                  .setAudioMuted(!_localStream!.audioMuted);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              color: _localStream!.audioMuted
                                  ? Colors.white
                                  : Colors.white10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                16.0,
                              ),
                              child: Icon(
                                _localStream!.audioMuted
                                    ? Icons.mic_off
                                    : Icons.mic,
                                color: !_localStream!.audioMuted
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _localStream!
                                  .setVideoMuted(!_localStream!.videoMuted);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              color: _localStream!.videoMuted
                                  ? Colors.white
                                  : Colors.white10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                16.0,
                              ),
                              child: Icon(
                                _localStream!.videoMuted
                                    ? Icons.videocam_off
                                    : Icons.videocam,
                                color: !_localStream!.videoMuted
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () async {
                        if (joinGroupCallButtonLoading) return;
                        setState(() {
                          joinGroupCallButtonLoading = true;
                        });
                        groupCallSession = await Matrix.of(context)
                            .voipPlugin
                            .voip
                            .fetchOrCreateGroupCall(
                              '', //call for whole room
                              room,
                              [
                                AppConfig.livekitEnabledCalls
                                    ? LiveKitBackend(
                                        livekitServiceUrl:
                                            AppConfig.livekitServiceUrl,
                                        livekitAlias: widget.roomId,
                                      )
                                    : MeshBackend(),
                              ],
                              'm.call',
                              'm.room',
                            );
                        final voipPlugin = Matrix.of(context).voipPlugin;
                        final groupCallProxy = groupCallSession!.isLivekitCall
                            ? LiveKitGroupCallSessionState(
                                groupCallSession!,
                                voipPlugin,
                              )
                            : GroupCallSessionState(
                                groupCallSession!,
                                voipPlugin,
                              );
                        VoipPlugin.currentCallProxy = groupCallProxy;

                        voipPlugin.connectedTsSinceEpoch = 0;
                        voipPlugin.onHoldMs = 0;

                        await groupCallProxy.enter(_localStream!);

                        voipPlugin.setupCallAndOpenCallPage(groupCallProxy);

                        if (mounted) {
                          setState(() {
                            joinGroupCallButtonLoading = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: joinGroupCallButtonLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  L10n.of(context)!.joinGroupCall,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
