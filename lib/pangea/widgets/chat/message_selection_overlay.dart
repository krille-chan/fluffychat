import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_footer.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_header.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_message.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class MessageSelectionOverlay extends StatelessWidget {
  final ChatController controller;
  final ToolbarDisplayController toolbarController;
  final Function closeToolbar;
  final Widget toolbar;
  final PangeaMessageEvent pangeaMessageEvent;
  final bool ownMessage;
  final bool immersionMode;
  final String targetId;

  const MessageSelectionOverlay({
    required this.controller,
    required this.closeToolbar,
    required this.toolbar,
    required this.pangeaMessageEvent,
    required this.immersionMode,
    required this.ownMessage,
    required this.targetId,
    required this.toolbarController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LayerLinkAndKey layerLinkAndKey =
        MatrixState.pAnyState.layerLinkAndKey(targetId);
    final targetRenderBox =
        layerLinkAndKey.key.currentContext?.findRenderObject();

    double center = 290;
    double? left;
    double? right;
    bool showDown = false;
    final double footerSize = PlatformInfos.isMobile
        ? PlatformInfos.isIOS
            ? 128
            : 108
        : 143;
    final double headerSize = PlatformInfos.isMobile
        ? PlatformInfos.isIOS
            ? 121
            : 84
        : 77;
    final double stackSize =
        MediaQuery.of(context).size.height - footerSize - headerSize;

    if (targetRenderBox != null) {
      final Size transformTargetSize = (targetRenderBox as RenderBox).size;
      final Offset targetOffset = (targetRenderBox).localToGlobal(Offset.zero);
      if (ownMessage) {
        right = MediaQuery.of(context).size.width -
            targetOffset.dx -
            transformTargetSize.width;
      } else {
        left = targetOffset.dx - (FluffyThemes.isColumnMode(context) ? 425 : 1);
      }

      showDown = targetOffset.dy + transformTargetSize.height <=
          headerSize + stackSize / 2;

      center = targetOffset.dy -
          headerSize +
          (showDown ? transformTargetSize.height + 3 : (-3));
      // If top of selected message extends below header
      if (targetOffset.dy <= headerSize) {
        center = transformTargetSize.height + 3;
        showDown = true;
      }
      // If bottom of selected message extends below footer
      else if (targetOffset.dy + transformTargetSize.height >=
          headerSize + stackSize) {
        center = stackSize - transformTargetSize.height - 3;
      }
      final double midpoint = headerSize + stackSize / 2;
      // If message is too long,
      // use default location to make full use of screen
      if (transformTargetSize.height >= stackSize / 2 - 30) {
        center = stackSize / 2 + (showDown ? -30 : 30);
      }
      // If message is normal size but too close
      // to center of screen, scroll closer to edges
      else if (targetOffset.dy > midpoint - 30 &&
          targetOffset.dy + transformTargetSize.height < midpoint + 30) {
        final double scrollUp =
            midpoint + 30 - (targetOffset.dy + transformTargetSize.height);
        final double scrollDown = targetOffset.dy - (midpoint - 30);
        final double minScroll =
            controller.scrollController.position.minScrollExtent;
        final double maxScroll =
            controller.scrollController.position.maxScrollExtent;
        final double currentOffset = controller.scrollController.offset;

        // If can scroll up, scroll up
        if (currentOffset + scrollUp < maxScroll) {
          controller.scrollController.animateTo(
            currentOffset + scrollUp,
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
          );
          showDown = false;
          center = stackSize / 2 - 12;
        }

        // Else if can scroll down, scroll down
        else if (currentOffset - scrollDown > minScroll) {
          controller.scrollController.animateTo(
            currentOffset - scrollDown,
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
          );
          showDown = true;
          center = stackSize / 2 + 12;
        }

        // Neither scrolling works; leave message as-is,
        // and use default toolbar location
        else {
          center = stackSize / 2 + (showDown ? -30 : 30);
        }
      }
    }

    final Widget overlayMessage = OverlayMessage(
      pangeaMessageEvent.event,
      timeline: pangeaMessageEvent.timeline,
      immersionMode: immersionMode,
      ownMessage: pangeaMessageEvent.ownMessage,
      toolbarController: toolbarController,
      width: 290,
      showDown: showDown,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment:
          ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        OverlayHeader(
          controller: controller,
          closeToolbar: closeToolbar,
        ),
        SizedBox(
          height: PlatformInfos.isAndroid ? 3 : 6,
        ),
        Flexible(
          child: Stack(
            children: [
              Positioned(
                left: left,
                right: right,
                bottom: stackSize - center + 3,
                child: showDown ? overlayMessage : toolbar,
              ),
              Positioned(
                left: left,
                right: right,
                top: center + 3,
                child: showDown ? toolbar : overlayMessage,
              ),
            ],
          ),
        ),
        SizedBox(
          height: PlatformInfos.isAndroid ? 3 : 6,
        ),
        OverlayFooter(controller: controller),
      ],
    );
  }
}
