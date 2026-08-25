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

class CallTile extends StatefulWidget {
  final lk.TrackPublication<lk.VideoTrack>? video;
  final lk.TrackPublication<lk.AudioTrack>? audio;
  final User user;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final lk.VideoViewFit fit;
  final double size;
  final bool handRaised, connected;

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
    required this.connected,
  });

  @override
  State<CallTile> createState() => _CallTileState();
}

class _CallTileState extends State<CallTile> {
  double _waveForm = 0.0;
  lk.AudioVisualizer? _audioVisualizer;
  lk.EventsListener<lk.AudioVisualizerEvent>? _eventsListener;

  @override
  void initState() {
    super.initState();

    final track = widget.audio?.track;
    if (track != null) {
      _audioVisualizer ??= lk.createVisualizer(
        track,
        options: lk.AudioVisualizerOptions(barCount: 1),
      );
      _eventsListener ??= _audioVisualizer?.createListener();
      _eventsListener?.on<lk.AudioVisualizerEvent>((e) {
        if (mounted) {
          setState(() {
            _waveForm =
                e.event.map((e) => ((e as num) * 100).toDouble()).firstOrNull ??
                0;
          });
        }
      });
      _audioVisualizer?.start();
    }
  }

  @override
  void dispose() {
    _audioVisualizer?.stop();
    _audioVisualizer?.dispose();
    _eventsListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video?.track;
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppConfig.borderRadius);

    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      width: widget.size,
      height: widget.size,
      margin: widget.margin,
      clipBehavior: .hardEdge,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: (_waveForm / 10) + 1.0,
            color: _waveForm > 0.0
                ? theme.colorScheme.primary
                : theme.dividerColor,
            blurRadius: _waveForm / 10,
          ),
        ],
        color: widget.fit == .cover || !(video != null && !video.muted)
            ? Theme.of(context).colorScheme.surfaceContainerHigh
            : Colors.black,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          video != null && !video.muted
              ? lk.VideoTrackRenderer(video, fit: widget.fit)
              : Center(
                  child: Avatar(
                    size: 64,
                    mxContent: widget.user.avatarUrl,
                    name: widget.user.calcDisplayname(),
                  ),
                ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
            ),
          ),
          if (widget.handRaised)
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
                    if (widget.audio != null)
                      Icon(
                        widget.audio?.muted == false
                            ? Icons.mic
                            : Icons.mic_off,
                        size: 11,
                      ),
                    if (widget.video?.isScreenShare == true)
                      Icon(Icons.screen_share_outlined, size: 11),
                    Text(
                      widget.user.calcDisplayname(),
                      maxLines: 1,
                      style: TextStyle(fontSize: 11),
                    ),
                    if (!widget.connected)
                      Icon(Icons.portable_wifi_off_outlined, size: 11),
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
