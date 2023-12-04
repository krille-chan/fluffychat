import 'package:flutter/material.dart';

Future<T?> showAlignedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Alignment followerAnchor = Alignment.center,
  Alignment targetAnchor = Alignment.center,
  Size? refChildSize,
  Offset offset = Offset.zero,
  bool avoidOverflow = false,
  bool isGlobal = false,
  RouteTransitionsBuilder? transitionsBuilder,
  Duration? duration,
}) {
  assert(debugCheckHasMaterialLocalizations(context));

  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );

  final RenderBox targetBox = context.findRenderObject()! as RenderBox;
  final RenderBox overlay =
      Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
  Offset position = targetBox
      .localToGlobal(targetAnchor.alongSize(targetBox.size), ancestor: overlay);

  if (isGlobal) {
    position = overlay.localToGlobal(followerAnchor.alongSize(overlay.size));
  }

  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push<T>(AlignedDialogRoute<T>(
    followerAlignment: followerAnchor,
    position: position,
    context: context,
    builder: builder,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: isGlobal == true,
    settings: routeSettings,
    themes: themes,
    transitionsBuilder: transitionsBuilder,
    duration: duration,
    avoidOverflow: avoidOverflow,
    offset: offset,
  ));
}

class AlignedDialogRoute<T> extends RawDialogRoute<T> {
  /// A dialog route with Material entrance and exit animations,
  /// modal barrier color, and modal barrier behavior (dialog is dismissible
  /// with a tap on the barrier).
  AlignedDialogRoute({
    required BuildContext context,
    required WidgetBuilder builder,
    required Alignment followerAlignment,
    required Offset position,
    CapturedThemes? themes,
    Color? barrierColor = Colors.transparent,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool useSafeArea = false,
    RouteSettings? settings,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? duration,
    bool avoidOverflow = false,
    Offset offset = Offset.zero,
  }) : super(
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            final Widget pageChild = Builder(builder: builder);
            Widget dialog = Builder(
              builder: (BuildContext context) {
                final MediaQueryData mediaQuery = MediaQuery.of(context);
                return CustomSingleChildLayout(
                  delegate: _FollowerDialogRouteLayout(
                    followerAlignment,
                    position,
                    Directionality.of(context),
                    mediaQuery.padding.top,
                    mediaQuery.padding.bottom,
                    offset,
                    avoidOverflow,
                  ),
                  child: pageChild,
                );
              },
            );
            dialog = themes?.wrap(dialog) ?? dialog;
            if (useSafeArea) {
              dialog = SafeArea(child: dialog);
            }
            return dialog;
          },
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel ??
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: duration ?? const Duration(milliseconds: 200),
          transitionBuilder:
              transitionsBuilder ?? _buildMaterialDialogTransitions,
          settings: settings,
        );
}

// Positioning of the menu on the screen.
class _FollowerDialogRouteLayout extends SingleChildLayoutDelegate {
  _FollowerDialogRouteLayout(
    this.followerAnchor,
    this.position,
    this.textDirection,
    this.topPadding,
    this.bottomPadding,
    this.offset,
    this.avoidOverflow,
  );

  final Alignment followerAnchor;

  final Offset position;

  final TextDirection textDirection;

  final double topPadding;

  final double bottomPadding;

  final Offset offset;
  final bool avoidOverflow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest)
        .deflate(EdgeInsets.only(top: topPadding, bottom: bottomPadding));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    Offset rst = followerAnchor.alongSize(childSize);
    rst = position - rst;
    rst += offset;
    if (avoidOverflow) {
      if (rst.dx < 0) rst = Offset(0, rst.dy);
      if (rst.dy < 0) rst = Offset(rst.dx, 0);
      if (rst.dx + childSize.width > size.width) {
        rst = Offset(size.width - childSize.width, rst.dy);
      }
      if (rst.dy + childSize.height > size.height) {
        rst = Offset(rst.dx, size.height - childSize.height);
      }
    }
    return rst;
  }

  @override
  bool shouldRelayout(_FollowerDialogRouteLayout oldDelegate) {
    return followerAnchor != oldDelegate.followerAnchor ||
        position != oldDelegate.position ||
        offset != oldDelegate.offset ||
        avoidOverflow != oldDelegate.avoidOverflow ||
        textDirection != oldDelegate.textDirection ||
        topPadding != oldDelegate.topPadding ||
        bottomPadding != oldDelegate.bottomPadding;
  }
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Offset _buildOffSet(BuildContext context,
    {required Size refChildSize, required Offset offset}) {
  final Size screenSize = MediaQuery.of(context).size;
  final Size maxAvilableArea = Size(screenSize.width - refChildSize.width,
      screenSize.height - refChildSize.height);
  return const Offset(0, 0);
}
