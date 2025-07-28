import 'package:flutter/material.dart';
import 'package:fluffychat/config/themes.dart';
import 'video_streaming.dart';
import 'package:fluffychat/l10n/l10n.dart';

class VideoStreamingView extends StatelessWidget {
  final VideoStreamingController controller;
  final String title;
  final String playbackUrl;
  final String viewId;
  final bool isAdmin;
  final bool isPreview;
  final VoidCallback onClose;
  final VoidCallback onEdit;

  const VideoStreamingView(
    this.controller, {
    super.key,
    required this.title,
    required this.playbackUrl,
    required this.viewId,
    required this.isAdmin,
    required this.isPreview,
    required this.onClose,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobileMode = !FluffyThemes.isColumnMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const margin = 16.0;
    const sideBarWidth = 460;
    const topBarHeight = 70.0;

    final defaultWidth = isMobileMode ? screenWidth * 0.9 : screenWidth * 0.3;

    final constrainedWidth = isMobileMode
        ? screenWidth * 0.9
        : (controller.width ?? defaultWidth)
            .clamp(screenWidth * 0.3, screenWidth - 32);

    final videoHeight = constrainedWidth / (16 / 9);
    final boxHeight = videoHeight + 50;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.width == null && !isMobileMode) {
        controller.setWidth(constrainedWidth);
      }
    });

    final fixedLeft = (screenWidth - constrainedWidth) / 2;

    return Positioned(
      top: controller.position.dy,
      left: isMobileMode ? fixedLeft : controller.position.dx,
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
                    final newOffset = controller.position + details.delta;

                    final maxLeft =
                        screenWidth - constrainedWidth - margin - sideBarWidth;
                    final maxTop =
                        screenHeight - boxHeight - margin - topBarHeight;

                    final clampedDx = isMobileMode
                        ? controller.position.dx
                        : newOffset.dx.clamp(margin, maxLeft);

                    final clampedDy = newOffset.dy.clamp(margin, maxTop);

                    controller.setPosition(Offset(clampedDx, clampedDy));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              title.isNotEmpty
                                  ? '${(L10n.of(context).live).toUpperCase()} - $title'
                                  : (L10n.of(context).live).toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.onSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (isAdmin && !isPreview)
                        PopupMenuButton<String>(
                          tooltip: L10n.of(context).liveOptions,
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                onEdit();
                                break;
                              case 'remove':
                                onClose();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(L10n.of(context).edit),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(L10n.of(context).closeLive),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: HtmlElementView(viewType: viewId),
                ),
              ),
              if (!isMobileMode && !isPreview)
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      controller.setWidth(controller.width! + details.delta.dx);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeUpLeftDownRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin:
                            const EdgeInsets.only(top: 8, right: 5, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.open_in_full,
                          size: 15,
                          color: theme.colorScheme.onSurface,
                        ),
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
