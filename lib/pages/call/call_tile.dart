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
  final VoidCallback? onTap;
  final lk.VideoViewFit fit;
  final double size;
  final bool handRaised;

  const CallTile({
    super.key,
    this.video,
    this.audio,
    this.size = 256.0,
    required this.user,
    required this.onTap,
    this.handRaised = false,
    this.fit = lk.VideoViewFit.cover,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final video = this.video?.track;
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppConfig.borderRadius / 2);
    // VideoTrackRenderer installs its own GestureDetector for local camera
    // tap-to-focus/zoom on mobile, which wins the gesture arena over parents.
    // Handle taps on a transparent overlay above the video instead.
    return Container(
      width: size,
      height: size,
      margin: margin,
      clipBehavior: .hardEdge,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: 1.0,
            color: theme.dividerColor,
            blurRadius: 0.0,
          ),
        ],
        color: fit == .cover || !(video != null && !video.muted)
            ? Theme.of(context).colorScheme.surfaceContainerHigh
            : Colors.black,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          video != null && !video.muted
              ? lk.VideoTrackRenderer(video, fit: fit)
              : Center(
                  child: Avatar(
                    size: 64,
                    mxContent: user.avatarUrl,
                    name: user.calcDisplayname(),
                  ),
                ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
          ),
          if (handRaised)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                borderRadius: BorderRadius.circular(32),
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.front_hand_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
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
                        audio?.muted == false ? Icons.mic : Icons.mic_off,
                        size: 11,
                      ),
                    if (this.video?.isScreenShare == true)
                      Icon(Icons.screen_share_outlined, size: 11),
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
      String id,
      lk.TrackPublication<lk.VideoTrack>? video,
      lk.TrackPublication<lk.AudioTrack>? audio,
      User user,
    })
  >
  getCallTiles(Room room) {
    final tiles =
        <
          ({
            String id,
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
        tiles.add((
          id: '${participant.identity}_none',
          user: user,
          video: null,
          audio: null,
        ));
      }
      for (final pub in participant.videoTrackPublications) {
        tiles.add((
          id: '${participant.identity}_${pub.name}',
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
        id: '${localParticipant?.identity ?? ownUser.id}_${pub.name}',
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
        id: '${localParticipant?.identity ?? ownUser.id}_none',
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
