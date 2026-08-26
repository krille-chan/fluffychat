// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
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
  final double width, height;
  final bool handRaised, connected, isSpeaking;

  const CallTile({
    super.key,
    this.video,
    this.audio,
    this.width = 256.0,
    this.height = 256.0,
    required this.user,
    required this.onTap,
    this.handRaised = false,
    this.fit = lk.VideoViewFit.cover,
    this.margin,
    required this.connected,
    required this.isSpeaking,
  });

  @override
  Widget build(BuildContext context) {
    final video = this.video?.track;
    final theme = Theme.of(context);
    final borderWidth = isSpeaking ? 5.0 : 1.0;

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedContainer(
        margin: margin,
        duration: FluffyThemes.animationDuration,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          border: BoxBorder.all(
            color: isSpeaking
                ? theme.colorScheme.primaryFixedDim
                : theme.colorScheme.surfaceContainerHighest,
            width: borderWidth,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
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
                bottom: 8,
                left: 8,
                child: Material(
                  elevation: theme.appBarTheme.elevation ?? 4,
                  shadowColor: theme.appBarTheme.shadowColor,
                  borderRadius: BorderRadius.circular(7),
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceBright.withAlpha(230),
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
                            size: 12,
                          ),
                        if (this.video?.isScreenShare == true)
                          Icon(Icons.screen_share_outlined, size: 12),
                        Text(
                          user.calcDisplayname(),
                          maxLines: 1,
                          style: TextStyle(fontSize: 12),
                        ),
                        if (!connected)
                          Icon(Icons.portable_wifi_off_outlined, size: 12),
                      ],
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
