import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/common/widgets/overlay_container.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';
import 'error_handler.dart';

enum OverlayPositionEnum {
  transform,
  centered,
}

class OverlayUtil {
  static showOverlay({
    required BuildContext context,
    required Widget child,
    required String transformTargetId,
    backDropToDismiss = true,
    blurBackground = false,
    Color? borderColor,
    Color? backgroundColor,
    bool closePrevOverlay = true,
    Function? onDismiss,
    OverlayPositionEnum position = OverlayPositionEnum.transform,
    Offset? offset,
    String? overlayKey,
    Alignment? targetAnchor,
    Alignment? followerAnchor,
  }) {
    try {
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
                TransparentBackdrop(
                  backgroundColor: backgroundColor,
                  onDismiss: onDismiss,
                  blurBackground: blurBackground,
                ),
              Positioned(
                top: (position == OverlayPositionEnum.centered) ? 0 : null,
                right: (position == OverlayPositionEnum.centered) ? 0 : null,
                left: (position == OverlayPositionEnum.centered) ? 0 : null,
                bottom: (position == OverlayPositionEnum.centered) ? 0 : null,
                child: (position != OverlayPositionEnum.transform)
                    ? child
                    : CompositedTransformFollower(
                        targetAnchor: targetAnchor ?? Alignment.topCenter,
                        followerAnchor:
                            followerAnchor ?? Alignment.bottomCenter,
                        link: MatrixState.pAnyState
                            .layerLinkAndKey(transformTargetId)
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
        closePrevOverlay: closePrevOverlay,
        overlayKey: overlayKey,
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
    backDropToDismiss = true,
    Color? borderColor,
    bool closePrevOverlay = true,
    String? overlayKey,
    bool isScrollable = true,
    bool addBorder = true,
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
        final hasLeftOverflow = (horizontalMidpoint - halfMaxWidth) < 0;
        final hasRightOverflow = (horizontalMidpoint + halfMaxWidth) >
            (MediaQuery.of(context).size.width - columnWidth);
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

  // /// calculates the card offset relative to the target
  // /// identified by [transformTargetKey]
  // static Offset _calculateCardOffset({
  //   required Size cardSize,
  //   required BuildContext transformTargetContext,
  //   final double minPadding = 10.0,
  // }) {
  //   // debugger(when: kDebugMode);
  //   //Note: assumes overlay in chatview
  //   final OverlayConstraints constraints =
  //       ChatViewConstraints(transformTargetContext);

  // final RenderObject? targetRenderBox =
  //     transformTargetContext.findRenderObject();
  // if (targetRenderBox == null) return Offset.zero;
  // final Offset transformTargetOffset =
  //     (targetRenderBox as RenderBox).localToGlobal(Offset.zero);
  // final Size transformTargetSize = targetRenderBox.size;

  //   // ideally horizontally centered on target
  //   double dx = transformTargetSize.width / 2 - cardSize.width / 2;
  //   // make sure it's not off the left edge of the screen
  //   // if transformTargetOffset.dx + dc < constraints.x0 + minPadding

  //   if (transformTargetOffset.dx + dx < minPadding + constraints.x0) {
  //     debugPrint("setting dx");
  //     dx = minPadding + constraints.x0 - transformTargetOffset.dx;
  //   }
  //   // make sure it's not off the right edge of the screen
  //   if (transformTargetOffset.dx + dx + cardSize.width + minPadding >
  //       constraints.x1) {
  //     dx = constraints.x1 -
  //         transformTargetOffset.dx -
  //         cardSize.width -
  //         minPadding;
  //   }

  //   // if there's more room above target,
  //   //    put the card there
  //   // else,
  //   //    put it below
  //   // debugPrint(
  //   //     "transformTargetOffset.dx ${transformTargetOffset.dx} transformTargetOffset.dy ${transformTargetOffset.dy}");
  //   // debugPrint(
  //   //     "transformTargetSize.width ${transformTargetSize.width} transformTargetSize.height ${transformTargetSize.height}");
  //   double dy = transformTargetOffset.dy >
  //           constraints.y1 -
  //               transformTargetOffset.dy -
  //               transformTargetSize.height
  //       ? -cardSize.height - minPadding
  //       : transformTargetSize.height + minPadding;
  //   // make sure it's not off the top edge of the screen
  //   if (dy < minPadding + constraints.y0 - transformTargetOffset.dy) {
  //     dy = minPadding + constraints.y0 - transformTargetOffset.dy;
  //   }
  //   // make sure it's not off the bottom edge of the screen
  //   if (transformTargetOffset.dy + dy + cardSize.height + minPadding >
  //       constraints.y1) {
  //     dy = constraints.y1 -
  //         transformTargetOffset.dy -
  //         cardSize.height -
  //         minPadding;
  //   }
  //   // debugPrint("dx $dx dy $dy");

  //   return Offset(dx, dy);
  // }

  static bool get isOverlayOpen => MatrixState.pAnyState.entries.isNotEmpty;
}

class TransparentBackdrop extends StatefulWidget {
  final Color? backgroundColor;
  final Function? onDismiss;
  final bool blurBackground;

  const TransparentBackdrop({
    super.key,
    this.onDismiss,
    this.backgroundColor,
    this.blurBackground = false,
  });

  @override
  TransparentBackdropState createState() => TransparentBackdropState();
}

class TransparentBackdropState extends State<TransparentBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityTween;
  late Animation<double> _blurTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: AppConfig.overlayAnimationDuration),
      vsync: this,
    );
    _opacityTween = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: FluffyThemes.animationCurve,
      ),
    );
    _blurTween = Tween<double>(begin: 0.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: FluffyThemes.animationCurve,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityTween,
      builder: (context, _) {
        return Material(
          borderOnForeground: false,
          color: widget.backgroundColor
                  ?.withAlpha((_opacityTween.value * 255).round()) ??
              Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (widget.onDismiss != null) {
                widget.onDismiss!();
              }
              MatrixState.pAnyState.closeOverlay();
            },
            child: AnimatedBuilder(
              animation: _blurTween,
              builder: (context, _) {
                return BackdropFilter(
                  filter: widget.blurBackground
                      ? ImageFilter.blur(
                          sigmaX: _blurTween.value,
                          sigmaY: _blurTween.value,
                        )
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
          // ),
        );
      },
    );
  }
}

// /// global coordinates that the overlay should stay inside
// abstract class OverlayConstraints {
//   late double x0;
//   late double y0;
//   late double x1;
//   late double y1;
// }

// class ChatViewConstraints implements OverlayConstraints {
//   @override
//   late double x0;
//   @override
//   late double y0;
//   @override
//   late double x1;
//   @override
//   late double y1;

//   ChatViewConstraints(BuildContext context) {
//     final MediaQueryData mediaQueryData =
//         MediaQuery.of(Scaffold.of(context).context);
//     final bool isColumnMode = FluffyThemes.isColumnMode(context);

//     x0 = isColumnMode
//         ? AppConfig.columnWidth + 70.0
//         : max(mediaQueryData.viewPadding.left, mediaQueryData.viewInsets.left);
//     y0 = max(mediaQueryData.viewPadding.top, mediaQueryData.viewInsets.top);
//     x1 = mediaQueryData.size.width -
//         max(mediaQueryData.viewPadding.right, mediaQueryData.viewInsets.right);
//     y1 = mediaQueryData.size.height -
//         max(
//           mediaQueryData.viewPadding.bottom,
//           mediaQueryData.viewInsets.bottom,
//         );

//     // https://medium.com/flutter-community/a-flutter-guide-to-visual-overlap-padding-viewpadding-and-viewinsets-a63e214be6e8
//     //   debugPrint(
//     //       "viewInsets ${mediaQueryData.viewInsets.left} ${mediaQueryData.viewInsets.top} ${mediaQueryData.viewInsets.right} ${mediaQueryData.viewInsets.bottom}");
//     //   debugPrint(
//     //       "padding ${mediaQueryData.padding.left} ${mediaQueryData.padding.top} ${mediaQueryData.padding.right} ${mediaQueryData.padding.bottom}");
//     //   debugPrint(
//     //       "viewPadding ${mediaQueryData.viewPadding.left} ${mediaQueryData.viewPadding.top} ${mediaQueryData.viewPadding.right} ${mediaQueryData.viewPadding.bottom}");
//     //   debugPrint("chatViewConstraints x0: $x0 y0: $y0 x1: $x1 y1: $y1");
//   }
// }
