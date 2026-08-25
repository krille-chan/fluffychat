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
});

extension GetCallTiles on lk.Room {
  /// Calculates all call tiles to be rendered for this call in this matrix
  /// room. For users without any camera track it adds a CallTile with a
  /// null video track at least.
  List<TileData> getCallTiles(Room room) {
    final tiles = <TileData>[];
    final removeParticipantIds = <String>{
      ...remoteParticipants.keys,
      ...room.getActiveMatrixRtcMembers().map(
        (member) => '${member.senderId}:${member.deviceId}',
      ),
    }..remove(localParticipant?.identity);

    for (final participantId in removeParticipantIds) {
      final participant = remoteParticipants[participantId];
      final matrixId =
          participant?.matrixId ??
          (participantId.split(':')..removeLast()).join(':');
      final user = room.unsafeGetUserFromMemoryOrFallback(matrixId);
      final audio = participant?.audioTrackPublications.firstOrNull;
      if (participant == null ||
          !participant.videoTrackPublications.any(
            (pub) => !pub.isScreenShare,
          )) {
        final tile = (
          id: '${participantId}_none',
          user: user,
          video: null,
          audio: audio,
          connected: participant != null,
        );
        tiles.add(tile);
      }
      for (final pub
          in participant?.videoTrackPublications ??
              <lk.RemoteTrackPublication<lk.RemoteVideoTrack>>[]) {
        final newTile = (
          id: '${participantId}_${pub.name}',
          user: user,
          video: pub,
          audio: pub.isScreenShare ? null : audio,
          connected: participant != null,
        );
        tiles.add(newTile);
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
      ));
    }

    return tiles;
  }
}

extension on lk.RemoteParticipant {
  String get matrixId => (identity.split(':')..removeLast()).join(':');
}
