import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/common/widgets/anchored_overlay_widget.dart';
import 'package:fluffychat/pangea/common/widgets/overlay_container.dart';
import 'package:fluffychat/pangea/common/widgets/transparent_backdrop.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';
import 'error_handler.dart';

enum OverlayPositionEnum {
  transform,
  centered,
  top,
}

class OverlayUtil {
  static showOverlay({
    required BuildContext context,
    required Widget child,
    String? transformTargetId,
    bool backDropToDismiss = true,
    bool blurBackground = false,
    Color? borderColor,
    Color? backgroundColor,
    bool closePrevOverlay = true,
    VoidCallback? onDismiss,
    OverlayPositionEnum position = OverlayPositionEnum.transform,
    Offset? offset,
    String? overlayKey,
    Alignment? targetAnchor,
    Alignment? followerAnchor,
    bool ignorePointer = false,
    bool canPop = true,
  }) {
    try {
      if (position == OverlayPositionEnum.transform) {
        assert(
          transformTargetId != null,
          "transformTargetId must be provided when position is OverlayPositionEnum.transform",
        );
      }

      if (closePrevOverlay) {
        MatrixState.pAnyState.closeOverlay();
      }

      final OverlayEntry entry = OverlayEntry(
        builder: (context) => AnimatedContainer(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          child: Stack(
            children: [
              if (backDropToDismiss)
                IgnorePointer(
                  ignoring: ignorePointer,
                  child: TransparentBackdrop(
                    backgroundColor: backgroundColor,
                    onDismiss: onDismiss,
                    blurBackground: blurBackground,
                  ),
                ),
              Positioned(
                top: (position == OverlayPositionEnum.centered ||
                        position == OverlayPositionEnum.top)
                    ? 0
                    : null,
                right: (position == OverlayPositionEnum.centered ||
                        position == OverlayPositionEnum.top)
                    ? 0
                    : null,
                left: (position == OverlayPositionEnum.centered ||
                        position == OverlayPositionEnum.top)
                    ? 0
                    : null,
                bottom: (position == OverlayPositionEnum.centered) ? 0 : null,
                child: (position != OverlayPositionEnum.transform)
                    ? child
                    : CompositedTransformFollower(
                        targetAnchor: targetAnchor ?? Alignment.topCenter,
                        followerAnchor:
                            followerAnchor ?? Alignment.bottomCenter,
                        link: MatrixState.pAnyState
                            .layerLinkAndKey(transformTargetId!)
                            .link,
                        showWhenUnlinked: false,
                        offset: offset ?? Offset.zero,
                        child: child,
                      ),
              ),
            ],
          ),
        ),
      );

      MatrixState.pAnyState.openOverlay(
        entry,
        context,
        overlayKey: overlayKey,
        canPop: canPop,
      );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {},
      );
    }
  }

  static showPositionedCard({
    required BuildContext context,
    required Widget cardToShow,
    required String transformTargetId,
    required double maxHeight,
    required double maxWidth,
    bool backDropToDismiss = true,
    Color? borderColor,
    bool closePrevOverlay = true,
    String? overlayKey,
    bool isScrollable = true,
    bool addBorder = true,
    VoidCallback? onDismiss,
    bool ignorePointer = false,
  }) {
    try {
      final LayerLinkAndKey layerLinkAndKey =
          MatrixState.pAnyState.layerLinkAndKey(transformTargetId);
      if (layerLinkAndKey.key.currentContext == null) {
        debugPrint("layerLinkAndKey.key.currentContext is null");
        return;
      }

      Offset offset = Offset.zero;
      final RenderBox? targetRenderBox =
          layerLinkAndKey.key.currentContext!.findRenderObject() as RenderBox?;

      bool hasTopOverflow = false;
      if (targetRenderBox != null && targetRenderBox.hasSize) {
        final Offset transformTargetOffset =
            (targetRenderBox).localToGlobal(Offset.zero);
        final Size transformTargetSize = targetRenderBox.size;

        final columnWidth = FluffyThemes.isColumnMode(context)
            ? FluffyThemes.columnWidth + FluffyThemes.navRailWidth
            : 0;

        final horizontalMidpoint = (transformTargetOffset.dx - columnWidth) +
            (transformTargetSize.width / 2);

        final verticalMidpoint =
            transformTargetOffset.dy + (transformTargetSize.height / 2);

        final halfMaxWidth = maxWidth / 2;
        final hasLeftOverflow = (horizontalMidpoint - halfMaxWidth) < 10;
        final hasRightOverflow = (horizontalMidpoint + halfMaxWidth) >
            (MediaQuery.of(context).size.width - columnWidth - 10);
        hasTopOverflow = (verticalMidpoint - maxHeight) < 0;

        double xOffset = 0;

        MediaQuery.of(context).size.width - (horizontalMidpoint + halfMaxWidth);
        if (hasLeftOverflow) {
          xOffset = (horizontalMidpoint - halfMaxWidth - 10) * -1;
        } else if (hasRightOverflow) {
          xOffset = (MediaQuery.of(context).size.width - columnWidth) -
              (horizontalMidpoint + halfMaxWidth + 10);
        }
        offset = Offset(xOffset, 0);
      }

      final Widget child = addBorder
          ? Material(
              borderOnForeground: false,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: OverlayContainer(
                cardToShow: cardToShow,
                borderColor: borderColor,
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                isScrollable: isScrollable,
              ),
            )
          : cardToShow;

      showOverlay(
        context: context,
        child: child,
        transformTargetId: transformTargetId,
        backDropToDismiss: backDropToDismiss,
        borderColor: borderColor,
        closePrevOverlay: closePrevOverlay,
        offset: offset,
        overlayKey: overlayKey,
        targetAnchor:
            hasTopOverflow ? Alignment.bottomCenter : Alignment.topCenter,
        followerAnchor:
            hasTopOverflow ? Alignment.topCenter : Alignment.bottomCenter,
        onDismiss: onDismiss,
        ignorePointer: ignorePointer,
      );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {},
      );
    }
  }

  static void showTutorialOverlay(
    BuildContext context,
    Widget overlayContent,
    Rect anchorRect, {
    double? borderRadius,
    double? padding,
    final VoidCallback? onClick,
    final VoidCallback? onDismiss,
  }) {
    MatrixState.pAnyState.closeAllOverlays();
    final entry = OverlayEntry(
      builder: (context) {
        return AnchoredOverlayWidget(
          anchorRect: anchorRect,
          borderRadius: borderRadius,
          padding: padding,
          onClick: onClick,
          onDismiss: onDismiss,
          child: overlayContent,
        );
      },
    );
    MatrixState.pAnyState.openOverlay(
      entry,
      context,
      rootOverlay: true,
    );
  }
}
