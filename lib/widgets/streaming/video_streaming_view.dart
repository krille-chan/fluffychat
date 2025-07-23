import 'package:flutter/material.dart';
import 'video_streaming.dart';
import 'package:fluffychat/config/themes.dart';

class VideoStreamingView extends StatefulWidget {
  final String playbackUrl;

  const VideoStreamingView({
    super.key,
    required this.playbackUrl,
  });

  @override
  State<VideoStreamingView> createState() => _VideoStreamingViewState();
}

class _VideoStreamingViewState extends State<VideoStreamingView> {
  Offset position = const Offset(16, 16);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobileMode = !FluffyThemes.isColumnMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const margin = 16.0;
    const sideBarWidth = 460;
    const topBarHeight = 70.0;

    final boxWidth = isMobileMode ? screenWidth * 0.9 : screenWidth * 0.4;
    final constrainedWidth = boxWidth.clamp(280.0, screenWidth);
    final videoHeight = constrainedWidth / (16 / 9);
    final boxHeight = videoHeight + 50;

    final fixedLeft = (screenWidth - constrainedWidth) / 2;

    return Positioned(
      top: position.dy,
      left: isMobileMode ? fixedLeft : position.dx,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: constrainedWidth,
          height: boxHeight,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.surface,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.move,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    final newOffset = position + details.delta;

                    final maxLeft =
                        screenWidth - constrainedWidth - margin - sideBarWidth;
                    final maxTop =
                        screenHeight - boxHeight - margin - topBarHeight;

                    final clampedDx = isMobileMode
                        ? position.dx
                        : newOffset.dx.clamp(margin, maxLeft);

                    final clampedDy = newOffset.dy.clamp(margin, maxTop);

                    setState(() {
                      position = Offset(clampedDx, clampedDy);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'AO VIVO - Santa Cannabis de cada dia',
                          style: TextStyle(
                            color: theme.colorScheme.onTertiary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: VideoStreaming(
                    playbackUrl: widget.playbackUrl,
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
