// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:collection/collection.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:matrix/matrix.dart';

typedef TileData = ({
  String id,
  lk.TrackPublication<lk.VideoTrack>? video,
  lk.TrackPublication<lk.AudioTrack>? audio,
  User user,
  bool connected,
  bool isSpeaking,
});

extension GetCallTiles on lk.Room {
  /// Calculates all call tiles to be rendered for this call in this matrix
  /// room. For users without any camera track it adds a CallTile with a
  /// null video track at least.
  List<TileData> getCallTiles(Room room) {
    final tiles = <TileData>[];

    for (final member in room.getActiveMatrixRtcMembers()) {
      final participantId = '${member.senderId}:${member.deviceId}';

      // The local user is handled below:
      if (localParticipant?.identity == participantId) continue;

      final participant =
          remoteParticipants[participantId] ??
          remoteParticipants[member.membershipId];
      final matrixId = member.senderId ?? participant?.matrixId;
      if (matrixId == null) {
        Logs().wtf('No matrix ID found for this member!');
        continue;
      }
      final user = room.unsafeGetUserFromMemoryOrFallback(matrixId);
      final audio = participant?.audioTrackPublications.firstOrNull;
      if (participant == null ||
          !participant.videoTrackPublications.any(
            (pub) => !pub.isScreenShare,
          )) {
        tiles.add((
          id: '${participantId}_none',
          user: user,
          video: null,
          audio: audio,
          connected: participant != null,
          isSpeaking: participant?.isSpeaking == true,
        ));
      }
      for (final pub
          in participant?.videoTrackPublications ??
              <lk.RemoteTrackPublication<lk.RemoteVideoTrack>>[]) {
        tiles.add((
          id: '${participantId}_${pub.name}',
          user: user,
          video: pub,
          audio: pub.isScreenShare ? null : audio,
          connected: participant != null,
          isSpeaking: participant?.isSpeaking == true && !pub.isScreenShare,
        ));
      }
    }

    final ownUser = room.unsafeGetUserFromMemoryOrFallback(room.client.userID!);
    for (final pub
        in localParticipant?.videoTrackPublications ??
            <lk.LocalTrackPublication<lk.LocalVideoTrack>>[]) {
      tiles.add((
        id: '${localParticipant?.identity ?? ownUser.id}_${pub.name}',
        user: ownUser,
        video: pub,
        audio: localParticipant?.audioTrackPublications.firstOrNull,
        connected: localParticipant != null,
        isSpeaking: localParticipant?.isSpeaking == true && !pub.isScreenShare,
      ));
    }

    if (localParticipant?.videoTrackPublications.any(
          (pub) => !pub.isScreenShare,
        ) !=
        true) {
      tiles.add((
        id: '${localParticipant?.identity ?? ownUser.id}_none',
        user: ownUser,
        video: null,
        audio: localParticipant?.audioTrackPublications.firstOrNull,
        connected: localParticipant != null,
        isSpeaking: localParticipant?.isSpeaking == true,
      ));
    }

    return tiles;
  }
}

extension on lk.RemoteParticipant {
  String get matrixId => (identity.split(':')..removeLast()).join(':');
}
