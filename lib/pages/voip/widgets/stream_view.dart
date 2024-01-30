import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:matrix/matrix.dart';

import '../../../utils/voip/livekit_stream.dart';
import '../../../widgets/avatar.dart';

class StreamView extends StatefulWidget {
  final WrappedMediaStream wrappedStream;
  final double avatarSize;
  final double avatarTextSize;
  final double avatarBorderRadius;
  final bool showExtendedName;
  final bool showName;
  final bool isVoiceOnly;
  final bool highLight;
  const StreamView({
    super.key,
    required this.wrappedStream,
    this.isVoiceOnly = false,
    this.showName = false,
    this.highLight = false,
    this.avatarSize = 44,
    this.avatarTextSize = 18,
    this.avatarBorderRadius = 8.0,
    this.showExtendedName = false,
  });

  @override
  State<StreamView> createState() => _StreamViewState();
}

class _StreamViewState extends State<StreamView> {
  Uri? get avatarUrl => widget.wrappedStream.getUser().avatarUrl;

  String? get displayName => widget.wrappedStream.displayName;

  String get avatarName => widget.wrappedStream.avatarName;

  bool get isLocal => widget.wrappedStream.isLocal();

  bool get isLivekit => widget.wrappedStream is LivekitParticipantStream;

  bool get isEncrypted =>
      isLivekit &&
      (widget.wrappedStream as LivekitParticipantStream).isEncrypted;

  VideoTrack? get videoTrack => isLivekit
      ? (widget.wrappedStream as LivekitParticipantStream).lkVideoTrack()
      : null;

  bool get mirrored =>
      widget.wrappedStream.isLocal() &&
      widget.wrappedStream.purpose == SDPStreamMetadataPurpose.Usermedia;

  bool get isScreenSharing =>
      widget.wrappedStream.purpose == SDPStreamMetadataPurpose.Screenshare;

  @override
  void initState() {
    widget.wrappedStream.onMuteStateChanged.stream.listen((stream) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: widget.highLight && !widget.wrappedStream.audioMuted ? 2 : 0,
          color: Theme.of(context).colorScheme.primary,
          strokeAlign: BorderSide.strokeAlignInside,
          style: widget.highLight && !widget.wrappedStream.audioMuted
              ? BorderStyle.solid
              : BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: widget.isVoiceOnly
            ? Colors.black.withOpacity(0.9)
            : Colors.white.withOpacity(0.18),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (widget.wrappedStream.videoMuted)
            Container(
              color: Colors.transparent,
            ),
          if (!widget.wrappedStream.videoMuted)
            isLivekit && videoTrack != null
                ? VideoTrackRenderer(
                    videoTrack!,
                    fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                  )
                : RTCVideoView(
                    widget.wrappedStream.renderer as RTCVideoRenderer,
                    mirror: mirrored,
                    objectFit:
                        RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                  ),
          if (widget.wrappedStream.videoMuted)
            Builder(
              builder: (context) {
                return Avatar(
                  mxContent: avatarUrl,
                  name: displayName ?? '',
                  size: widget.avatarSize,
                  fontSize: widget.avatarTextSize,
                  client: widget.wrappedStream.client,
                );
              },
            ),
          if (widget.showName)
            Positioned(
              left: 4.0,
              bottom: 4.0,
              child: !widget.showExtendedName
                  ? Text(displayName.toString())
                  : Container(
                      decoration: BoxDecoration(
                        color:
                            widget.highLight && !widget.wrappedStream.audioMuted
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(
                          4.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              widget.wrappedStream.audioMuted
                                  ? Icons.mic_off
                                  : Icons.mic,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isEncrypted ? Icons.lock : Icons.lock_open,
                              size: 15,
                              color: isEncrypted ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
