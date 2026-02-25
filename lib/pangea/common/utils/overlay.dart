import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/growth_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/star_rain_widget.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_card.dart';
import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/common/widgets/anchored_overlay_widget.dart';
import 'package:fluffychat/pangea/common/widgets/overlay_container.dart';
import 'package:fluffychat/pangea/common/widgets/transparent_backdrop.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/learning_settings/language_mismatch_popup.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';
import 'error_handler.dart';

enum OverlayPositionEnum { transform, centered, top }

class OverlayUtil {
  static bool showOverlay({
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
    bool rootOverlay = false,
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
        builder: (context) => Stack(
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
              top:
                  (position == OverlayPositionEnum.centered ||
                      position == OverlayPositionEnum.top)
                  ? 0
                  : null,
              right:
                  (position == OverlayPositionEnum.centered ||
                      position == OverlayPositionEnum.top)
                  ? 0
                  : null,
              left:
                  (position == OverlayPositionEnum.centered ||
                      position == OverlayPositionEnum.top)
                  ? 0
                  : null,
              bottom: (position == OverlayPositionEnum.centered) ? 0 : null,
              child: (position != OverlayPositionEnum.transform)
                  ? child
                  : CompositedTransformFollower(
                      targetAnchor: targetAnchor ?? Alignment.topCenter,
                      followerAnchor: followerAnchor ?? Alignment.bottomCenter,
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
      );

      return MatrixState.pAnyState.openOverlay(
        entry,
        context,
        overlayKey: overlayKey,
        canPop: canPop,
        rootOverlay: rootOverlay,
      );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: {});
      return false;
    }
  }

  static void showPositionedCard({
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
    Alignment? targetAnchor,
    Alignment? followerAnchor,
  }) {
    try {
      final LayerLinkAndKey layerLinkAndKey = MatrixState.pAnyState
          .layerLinkAndKey(transformTargetId);
      if (layerLinkAndKey.key.currentContext == null) {
        debugPrint("layerLinkAndKey.key.currentContext is null");
        return;
      }

      Offset offset = Offset.zero;
      final RenderBox? targetRenderBox =
          layerLinkAndKey.key.currentContext!.findRenderObject() as RenderBox?;

      bool hasTopOverflow = false;
      if (targetRenderBox != null && targetRenderBox.hasSize) {
        final Offset transformTargetOffset = (targetRenderBox).localToGlobal(
          Offset.zero,
        );
        final Size transformTargetSize = targetRenderBox.size;

        final columnWidth = FluffyThemes.isColumnMode(context)
            ? FluffyThemes.columnWidth + FluffyThemes.navRailWidth
            : 0;

        final horizontalMidpoint =
            (transformTargetOffset.dx - columnWidth) +
            (transformTargetSize.width / 2);

        final halfMaxWidth = maxWidth / 2;
        final hasLeftOverflow = (horizontalMidpoint - halfMaxWidth) < 10;
        final hasRightOverflow =
            (horizontalMidpoint + halfMaxWidth) >
            (MediaQuery.widthOf(context) - columnWidth - 10);
        hasTopOverflow = maxHeight + kToolbarHeight > transformTargetOffset.dy;

        double xOffset = 0;

        MediaQuery.widthOf(context) - (horizontalMidpoint + halfMaxWidth);
        if (hasLeftOverflow) {
          xOffset = (horizontalMidpoint - halfMaxWidth - 10) * -1;
        } else if (hasRightOverflow) {
          xOffset =
              (MediaQuery.of(context).size.width - columnWidth) -
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
            targetAnchor ??
            (hasTopOverflow ? Alignment.bottomCenter : Alignment.topCenter),
        followerAnchor:
            followerAnchor ??
            (hasTopOverflow ? Alignment.topCenter : Alignment.bottomCenter),
        onDismiss: onDismiss,
        ignorePointer: ignorePointer,
      );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: {});
    }
  }

  static void showIGCMatch(
    PangeaMatchState match,
    Choreographer choreographer,
    BuildContext context,
    Future Function(String) onFeedbackSubmitted,
  ) {
    MatrixState.pAnyState.closeAllOverlays();
    showPositionedCard(
      overlayKey: 'span-card-overlay',
      context: context,
      cardToShow: SpanCard(
        choreographer: choreographer,
        onFeedbackSubmitted: onFeedbackSubmitted,
        close: () => MatrixState.pAnyState.closeOverlay('span-card-overlay'),
      ),
      maxHeight: 325,
      maxWidth: 325,
      transformTargetId: ChoreoConstants.inputTransformTargetKey,
      ignorePointer: true,
      isScrollable: false,
      targetAnchor: Alignment.topCenter,
      followerAnchor: Alignment.bottomCenter,
    );
  }

  static void showTutorialOverlay(
    BuildContext context, {
    required Widget overlayContent,
    required String overlayKey,
    required Rect anchorRect,
    double? borderRadius,
    double? padding,
    final VoidCallback? onClick,
  }) {
    // force close all overlays to prevent showing
    // constuct / level up notification on top of tutorial
    MatrixState.pAnyState.closeAllOverlays(force: true);
    final entry = OverlayEntry(
      builder: (context) {
        return AnchoredOverlayWidget(
          anchorRect: anchorRect,
          borderRadius: borderRadius,
          padding: padding,
          onClick: onClick,
          overlayKey: overlayKey,
          child: overlayContent,
        );
      },
    );
    MatrixState.pAnyState.openOverlay(
      entry,
      context,
      rootOverlay: true,
      overlayKey: overlayKey,
      canPop: false,
      blockOverlay: true,
    );
  }

  static void showStarRainOverlay(BuildContext context) {
    showOverlay(
      context: context,
      position: OverlayPositionEnum.centered,
      closePrevOverlay: false,
      canPop: false,
      overlayKey: "star_rain_level_up",
      child: const StarRainWidget(overlayKey: "star_rain_level_up"),
    );
  }

  static void showPointsGained(
    String targetId,
    int points,
    BuildContext context,
  ) {
    showOverlay(
      overlayKey: "${targetId}_points",
      followerAnchor: Alignment.bottomCenter,
      targetAnchor: Alignment.bottomCenter,
      context: context,
      child: PointsGainedAnimation(points: points, targetID: targetId),
      transformTargetId: targetId,
      closePrevOverlay: false,
      backDropToDismiss: false,
      ignorePointer: true,
      canPop: false,
    );
  }

  static void showGrowthAnimation(
    BuildContext context,
    String targetId,
    ConstructLevelEnum level,
    ConstructIdentifier constructId,
  ) {
    final overlayKey = "${targetId}_growth_${constructId.string}";
    showOverlay(
      overlayKey: overlayKey,
      followerAnchor: Alignment.topCenter,
      targetAnchor: Alignment.topCenter,
      context: context,
      child: GrowthAnimation(targetID: overlayKey, level: level),
      transformTargetId: targetId,
      closePrevOverlay: false,
      backDropToDismiss: false,
      ignorePointer: true,
    );
  }

  static void showLanguageMismatchPopup({
    required BuildContext context,
    required String targetId,
    required String message,
    required String targetLanguage,
    required VoidCallback onConfirm,
  }) {
    showPositionedCard(
      context: context,
      cardToShow: LanguageMismatchPopup(
        message: message,
        overlayId: 'language_mismatch_popup',
        onConfirm: onConfirm,
        targetLanguage: targetLanguage,
      ),
      maxHeight: 325,
      maxWidth: 325,
      transformTargetId: targetId,
      overlayKey: 'language_mismatch_popup',
    );
  }
}
