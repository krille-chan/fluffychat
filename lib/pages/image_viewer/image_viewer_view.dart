import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'image_viewer.dart';

class ImageViewerView extends StatelessWidget {
  final ImageViewerController controller;

  const ImageViewerView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final iconButtonStyle = IconButton.styleFrom(
      backgroundColor: Colors.black.withAlpha(200),
      foregroundColor: Colors.white,
    );
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withAlpha(128),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            style: iconButtonStyle,
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
            color: Colors.white,
            tooltip: L10n.of(context).close,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              style: iconButtonStyle,
              icon: const Icon(Icons.reply_outlined),
              onPressed: controller.forwardAction,
              color: Colors.white,
              tooltip: L10n.of(context).share,
            ),
            const SizedBox(width: 8),
            IconButton(
              style: iconButtonStyle,
              icon: const Icon(Icons.download_outlined),
              onPressed: () => controller.saveFileAction(context),
              color: Colors.white,
              tooltip: L10n.of(context).downloadFile,
            ),
            const SizedBox(width: 8),
            if (PlatformInfos.isMobile)
              // Use builder context to correctly position the share dialog on iPad
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Builder(
                  builder: (context) => IconButton(
                    style: iconButtonStyle,
                    onPressed: () => controller.shareFileAction(context),
                    tooltip: L10n.of(context).share,
                    color: Colors.white,
                    icon: Icon(Icons.adaptive.share_outlined),
                  ),
                ),
              ),
          ],
        ),
        body: HoverBuilder(
          builder: (context, hovered) => Stack(
            children: [
              KeyboardListener(
                focusNode: controller.focusNode,
                onKeyEvent: controller.onKeyEvent,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.allEvents.length,
                  itemBuilder: (context, i) => InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 10.0,
                    onInteractionEnd: controller.onInteractionEnds,
                    child: Center(
                      child: Hero(
                        tag: controller.allEvents[i].eventId,
                        child: GestureDetector(
                          // Ignore taps to not go back here:
                          onTap: () {},
                          child: MxcImage(
                            key: ValueKey(controller.allEvents[i].eventId),
                            event: controller.allEvents[i],
                            fit: BoxFit.contain,
                            isThumbnail: false,
                            animated: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (hovered && controller.canGoBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      style: iconButtonStyle,
                      tooltip: L10n.of(context).previous,
                      icon: const Icon(Icons.chevron_left_outlined),
                      onPressed: controller.prevImage,
                    ),
                  ),
                ),
              if (hovered && controller.canGoNext)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      style: iconButtonStyle,
                      tooltip: L10n.of(context).next,
                      icon: const Icon(Icons.chevron_right_outlined),
                      onPressed: controller.nextImage,
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
