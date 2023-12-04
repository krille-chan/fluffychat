import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/widgets/common_widgets/overlay_container.dart';
import '../../config/themes.dart';
import '../../widgets/matrix.dart';
import 'error_handler.dart';

class OverlayUtil {
  static showPositionedCard({
    required BuildContext context,
    required Widget cardToShow,
    required Size cardSize,
    required String transformTargetId,
    backDropToDismiss = true,
    Color? borderColor,
  }) {
    try {
      MatrixState.pAnyState.closeOverlay();

      final LayerLinkAndKey layerLinkAndKey =
          MatrixState.pAnyState.layerLinkAndKey(transformTargetId);

      final Offset cardOffset = _calculateCardOffset(
        cardSize: cardSize,
        transformTargetKey: layerLinkAndKey.key,
      );

      MatrixState.pAnyState.overlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            if (backDropToDismiss) const TransparentBackdrop(),
            Positioned(
              width: cardSize.width,
              height: cardSize.height,
              child: CompositedTransformFollower(
                link: layerLinkAndKey.link,
                showWhenUnlinked: false,
                offset: cardOffset,
                child: Material(
                  borderOnForeground: false,
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  child: OverlayContainer(
                      cardToShow: cardToShow, borderColor: borderColor,),
                ),
              ),
            ),
          ],
        ),
      );

      Overlay.of(layerLinkAndKey.key.currentContext!)
          .insert(MatrixState.pAnyState.overlay!);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  /// calculates the card offset relative to the target
  /// identified by [transformTargetKey]
  static Offset _calculateCardOffset({
    required Size cardSize,
    required LabeledGlobalKey transformTargetKey,
    final double minPadding = 10.0,
  }) {
    // debugger(when: kDebugMode);
    //Note: assumes overlay in chatview
    final OverlayConstraints constraints =
        ChatViewConstraints(transformTargetKey.currentContext!);

    final RenderObject? targetRenderBox =
        transformTargetKey.currentContext!.findRenderObject();
    if (targetRenderBox == null) return Offset.zero;
    final Offset transformTargetOffset =
        (targetRenderBox as RenderBox).localToGlobal(Offset.zero);
    final Size transformTargetSize = targetRenderBox.size;

    // ideally horizontally centered on target
    double dx = transformTargetSize.width / 2 - cardSize.width / 2;
    // make sure it's not off the left edge of the screen
    // if transformTargetOffset.dx + dc < constraints.x0 + minPadding

    if (transformTargetOffset.dx + dx < minPadding + constraints.x0) {
      debugPrint("setting dx");
      dx = minPadding + constraints.x0 - transformTargetOffset.dx;
    }
    // make sure it's not off the right edge of the screen
    if (transformTargetOffset.dx + dx + cardSize.width + minPadding >
        constraints.x1) {
      dx = constraints.x1 -
          transformTargetOffset.dx -
          cardSize.width -
          minPadding;
    }

    // if there's more room above target,
    //    put the card there
    // else,
    //    put it below
    // debugPrint(
    //     "transformTargetOffset.dx ${transformTargetOffset.dx} transformTargetOffset.dy ${transformTargetOffset.dy}");
    // debugPrint(
    //     "transformTargetSize.width ${transformTargetSize.width} transformTargetSize.height ${transformTargetSize.height}");
    double dy = transformTargetOffset.dy >
            constraints.y1 -
                transformTargetOffset.dy -
                transformTargetSize.height
        ? -cardSize.height - minPadding
        : transformTargetSize.height + minPadding;
    // make sure it's not off the top edge of the screen
    if (dy < minPadding + constraints.y0 - transformTargetOffset.dy) {
      dy = minPadding + constraints.y0 - transformTargetOffset.dy;
    }
    // make sure it's not off the bottom edge of the screen
    if (transformTargetOffset.dy + dy + cardSize.height + minPadding >
        constraints.y1) {
      dy = constraints.y1 -
          transformTargetOffset.dy -
          cardSize.height -
          minPadding;
    }
    // debugPrint("dx $dx dy $dy");

    return Offset(dx, dy);
  }
}

class TransparentBackdrop extends StatelessWidget {
  const TransparentBackdrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: false,
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          MatrixState.pAnyState.closeOverlay();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

/// global coordinates that the overlay should stay inside
abstract class OverlayConstraints {
  late double x0;
  late double y0;
  late double x1;
  late double y1;
}

class ChatViewConstraints implements OverlayConstraints {
  @override
  late double x0;
  @override
  late double y0;
  @override
  late double x1;
  @override
  late double y1;

  ChatViewConstraints(BuildContext context) {
    final MediaQueryData mediaQueryData =
        MediaQuery.of(Scaffold.of(context).context);
    final bool isColumnMode = FluffyThemes.isColumnMode(context);

    x0 = isColumnMode
        ? AppConfig.columnWidth + 70.0
        : max(mediaQueryData.viewPadding.left, mediaQueryData.viewInsets.left);
    y0 = max(mediaQueryData.viewPadding.top, mediaQueryData.viewInsets.top);
    x1 = mediaQueryData.size.width -
        max(mediaQueryData.viewPadding.right, mediaQueryData.viewInsets.right);
    y1 = mediaQueryData.size.height -
        max(mediaQueryData.viewPadding.bottom,
            mediaQueryData.viewInsets.bottom,);

    // https://medium.com/flutter-community/a-flutter-guide-to-visual-overlap-padding-viewpadding-and-viewinsets-a63e214be6e8
    //   debugPrint(
    //       "viewInsets ${mediaQueryData.viewInsets.left} ${mediaQueryData.viewInsets.top} ${mediaQueryData.viewInsets.right} ${mediaQueryData.viewInsets.bottom}");
    //   debugPrint(
    //       "padding ${mediaQueryData.padding.left} ${mediaQueryData.padding.top} ${mediaQueryData.padding.right} ${mediaQueryData.padding.bottom}");
    //   debugPrint(
    //       "viewPadding ${mediaQueryData.viewPadding.left} ${mediaQueryData.viewPadding.top} ${mediaQueryData.viewPadding.right} ${mediaQueryData.viewPadding.bottom}");
    //   debugPrint("chatViewConstraints x0: $x0 y0: $y0 x1: $x1 y1: $y1");
  }
}
