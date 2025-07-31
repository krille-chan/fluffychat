import 'package:flutter/material.dart';
import 'video_streaming.dart';
import 'package:fluffychat/config/themes.dart';
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

    final defaultWidth = isMobileMode ? screenWidth * 0.9 : screenWidth * 0.4;
    controller.initializeIfNeeded(defaultWidth);

    return ValueListenableBuilder<Offset>(
      valueListenable: controller.positionNotifier,
      builder: (context, position, _) {
        return ValueListenableBuilder<double>(
          valueListenable: controller.widthNotifier,
          builder: (context, width, __) {
            final height = width / (16 / 9);
            final boxHeight = height + 50;
            final fixedLeft = (screenWidth - width) / 2;

            final content = Material(
              color: Colors.transparent,
              child: Container(
                width: width,
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
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.move,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (details) {
                          final maxLeft = screenWidth - width - 16 - 460;
                          final maxTop = screenHeight - boxHeight - 16 - 70;
                          controller.setPosition(
                            controller.position + details.delta,
                            maxLeft,
                            maxTop,
                            isMobileMode,
                          );
                        },
                        child: SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fiber_manual_record,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Tooltip(
                                  message: title.isNotEmpty
                                      ? '${(L10n.of(context).live).toUpperCase()} - $title'
                                      : (L10n.of(context).live).toUpperCase(),
                                  child: Text(
                                    title.isNotEmpty
                                        ? '${(L10n.of(context).live).toUpperCase()} - $title'
                                        : (L10n.of(context).live).toUpperCase(),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSecondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isAdmin && !isPreview)
                                _buildAdminMenu(context),
                            ],
                          ),
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
                          onPanUpdate: (details) =>
                              controller.resize(details.delta.dx, screenWidth),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.resizeUpLeftDownRight,
                            child: Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 8, right: 5),
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
            );

            return isPreview
                ? content
                : Positioned(
                    top: position.dy,
                    left: isMobileMode ? fixedLeft : position.dx,
                    child: content,
                  );
          },
        );
      },
    );
  }

  Widget _buildAdminMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'remove') onClose();
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
    );
  }
}
