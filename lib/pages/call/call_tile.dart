// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class CallTile extends StatelessWidget {
  final lk.TrackPublication<lk.VideoTrack>? video;
  final lk.TrackPublication<lk.AudioTrack>? audio;
  final User user;
  final EdgeInsets? margin;
  const CallTile({
    super.key,
    this.video,
    this.audio,
    required this.user,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final video = this.video?.track;
    final theme = Theme.of(context);
    return Container(
      width: 128,
      height: 128,
      margin: margin,
      clipBehavior: .hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
      ),
      child: Stack(
        children: [
          video != null && !video.muted
              ? lk.VideoTrackRenderer(video, fit: .cover)
              : Center(
                  child: Avatar(
                    mxContent: user.avatarUrl,
                    name: user.calcDisplayname(),
                  ),
                ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Material(
              elevation: theme.appBarTheme.elevation ?? 4,
              shadowColor: theme.appBarTheme.shadowColor,
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 4,
                  children: [
                    if (audio != null)
                      Icon(
                        audio?.muted == false
                            ? Icons.mic_outlined
                            : Icons.mic_off_outlined,
                        size: 11,
                      ),
                    Text(
                      user.calcDisplayname(),
                      maxLines: 1,
                      style: TextStyle(fontSize: 11),
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

extension GetCallTiles on lk.Room {
  /// Calculates all call tiles to be rendered for this call in this matrix
  /// room. For users without any camera track it adds a CallTile with a
  /// null video track at least.
  List<
    ({
      lk.TrackPublication<lk.VideoTrack>? video,
      lk.TrackPublication<lk.AudioTrack>? audio,
      User user,
    })
  >
  getCallTiles(Room room) {
    final tiles =
        <
          ({
            lk.TrackPublication<lk.VideoTrack>? video,
            lk.TrackPublication<lk.AudioTrack>? audio,
            User user,
          })
        >[];
    for (final participant in remoteParticipants.values) {
      final user = room.unsafeGetUserFromMemoryOrFallback(participant.matrixId);
      if (!participant.videoTrackPublications.any(
        (pub) => !pub.isScreenShare,
      )) {
        tiles.add((user: user, video: null, audio: null));
      }
      for (final pub in participant.videoTrackPublications) {
        tiles.add((
          user: user,
          video: pub,
          audio: pub.isScreenShare
              ? null
              : participant.audioTrackPublications.firstOrNull,
        ));
      }
    }

    final ownUser = room.unsafeGetUserFromMemoryOrFallback(room.client.userID!);
    for (final pub
        in localParticipant?.videoTrackPublications ??
            <lk.LocalTrackPublication<lk.LocalVideoTrack>>[]) {
      tiles.add((
        user: ownUser,
        video: pub,
        audio: localParticipant?.audioTrackPublications.firstOrNull,
      ));
    }

    if (localParticipant?.videoTrackPublications.any(
          (pub) => !pub.isScreenShare,
        ) !=
        true) {
      tiles.add((
        user: ownUser,
        video: null,
        audio: localParticipant?.audioTrackPublications.firstOrNull,
      ));
    }

    return tiles;
  }
}

extension on lk.RemoteParticipant {
  String get matrixId => (identity.split(':')..removeLast()).join(':');
}
