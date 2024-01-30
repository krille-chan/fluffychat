import 'package:flutter/material.dart';

import 'package:livekit_client/livekit_client.dart';

enum StatsType {
  kUnknown,
  kLocalAudioSender,
  kLocalVideoSender,
  kRemoteAudioReceiver,
  kRemoteVideoReceiver,
}

class ParticipantStatsWidget extends StatefulWidget {
  const ParticipantStatsWidget({super.key, required this.participant});
  final Participant participant;
  @override
  State<StatefulWidget> createState() => _ParticipantStatsWidgetState();
}

class _ParticipantStatsWidgetState extends State<ParticipantStatsWidget> {
  List<EventsListener<TrackEvent>> listeners = [];
  StatsType statsType = StatsType.kUnknown;
  Map<String, String> stats = {};

  void _setUpListener(Track track) {
    final listener = track.createListener();
    listeners.add(listener);
    if (track is LocalVideoTrack) {
      statsType = StatsType.kLocalVideoSender;
      listener.on<VideoSenderStatsEvent>((event) {
        setState(() {
          stats['video tx'] = 'total sent ${event.currentBitrate.toInt()} kpbs';
          event.stats.forEach((key, value) {
            stats['layer-$key'] =
                '${value.frameWidth ?? 0}x${value.frameHeight ?? 0} ${value.framesPerSecond?.toDouble() ?? 0} fps, ${event.bitrateForLayers[key] ?? 0} kbps';
          });
          final firstStats =
              event.stats['f'] ?? event.stats['h'] ?? event.stats['q'];
          if (firstStats != null) {
            stats['encoder'] = firstStats.encoderImplementation ?? '';
            stats['video codec'] =
                '${firstStats.mimeType}, ${firstStats.clockRate}hz, pt: ${firstStats.payloadType}';
            stats['qualityLimitationReason'] =
                firstStats.qualityLimitationReason ?? '';
          }
        });
      });
    } else if (track is RemoteVideoTrack) {
      statsType = StatsType.kRemoteVideoReceiver;
      listener.on<VideoReceiverStatsEvent>((event) {
        setState(() {
          stats['video rx'] = '${event.currentBitrate.toInt()} kpbs';
          stats['video codec'] =
              '${event.stats.mimeType}, ${event.stats.clockRate}hz, pt: ${event.stats.payloadType}';
          stats['video size'] =
              '${event.stats.frameWidth}x${event.stats.frameHeight} ${event.stats.framesPerSecond?.toDouble()}fps';
          stats['video jitter'] = '${event.stats.jitter} s';
          stats['video decoder'] = '${event.stats.decoderImplementation}';
          //stats['video packets lost'] = '${event.stats.packetsLost}';
          //stats['video packets received'] = '${event.stats.packetsReceived}';
          stats['video frames received'] = '${event.stats.framesReceived}';
          stats['video frames decoded'] = '${event.stats.framesDecoded}';
          stats['video frames dropped'] = '${event.stats.framesDropped}';
        });
      });
    } else if (track is LocalAudioTrack) {
      statsType = StatsType.kLocalAudioSender;
      listener.on<AudioSenderStatsEvent>((event) {
        setState(() {
          stats['audio tx'] = '${event.currentBitrate.toInt()} kpbs';
          stats['audio codec'] =
              '${event.stats.mimeType}, ${event.stats.clockRate}hz, ${event.stats.channels}ch, pt: ${event.stats.payloadType}';
        });
      });
    } else if (track is RemoteAudioTrack) {
      statsType = StatsType.kRemoteAudioReceiver;
      listener.on<AudioReceiverStatsEvent>((event) {
        setState(() {
          stats['audio rx'] = '${event.currentBitrate.toInt()} kpbs';
          stats['audio codec'] =
              '${event.stats.mimeType}, ${event.stats.clockRate}hz, ${event.stats.channels}ch, pt: ${event.stats.payloadType}';
          stats['audio jitter'] = '${event.stats.jitter} s';
          //stats['audio concealed samples'] =
          //    '${event.stats.concealedSamples} / ${event.stats.concealmentEvents}';
          stats['audio packets lost'] = '${event.stats.packetsLost}';
          stats['audio packets received'] = '${event.stats.packetsReceived}';
        });
      });
    }
  }

  _onParticipantChanged() {
    for (final element in listeners) {
      element.dispose();
    }
    listeners.clear();
    for (final track in widget.participant.trackPublications.values) {
      if (track.track != null) {
        _setUpListener(track.track!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_onParticipantChanged);
    // trigger initial change
    _onParticipantChanged();
  }

  @override
  void deactivate() {
    for (final element in listeners) {
      element.dispose();
    }
    widget.participant.removeListener(_onParticipantChanged);
    super.deactivate();
  }

  num sendBitrate = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: Column(
        children:
            stats.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
      ),
    );
  }
}
