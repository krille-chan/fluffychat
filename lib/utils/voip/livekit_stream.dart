import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:matrix/matrix.dart';

class SFUConfig {
  final String url;
  final String jwt;
  SFUConfig({required this.url, required this.jwt});
  factory SFUConfig.fromJson(Map<String, dynamic> json) {
    return SFUConfig(url: json['url'], jwt: json['jwt']);
  }
}

class LivekitParticipantStream extends WrappedMediaStream {
  final livekit.Participant lkParticipant;
  List<livekit.TrackPublication> publication = [];
  LivekitParticipantStream({
    required super.participant,
    required super.renderer,
    required super.room,
    required super.purpose,
    required super.client,
    required super.audioMuted,
    required super.videoMuted,
    required super.isWeb,
    required super.isGroupCall,
    required super.stream,
    required this.lkParticipant,
    this.publication = const [],
  });

  bool publicationExists(livekit.TrackPublication pub) {
    return publication.contains(pub);
  }

  void addPublication(livekit.TrackPublication pub) {
    publication.add(pub);
    super.onMuteStateChanged.add(this);
  }

  void removePublication(livekit.TrackPublication pub) {
    publication.remove(pub);
    super.onMuteStateChanged.add(this);
  }

  livekit.VideoTrack? lkVideoTrack() {
    if (lkParticipant is livekit.LocalParticipant) {
      return publication.firstOrNull?.track as livekit.VideoTrack?;
    }

    if (lkParticipant is livekit.RemoteParticipant) {
      return publication.firstOrNull?.track as livekit.VideoTrack?;
    }

    return null;
  }

  bool get isEncrypted => lkParticipant.isEncrypted;
}
