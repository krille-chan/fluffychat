import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:hermes/config/app_config.dart';
import 'package:hermes/utils/horizontal_swipe_recognizer.dart';

/// A [Page] that wraps content in a swipe-to-pop route.
class SwipePopPage<T> extends Page<T> {
  /// Creates a [SwipePopPage] that reads defaults from [AppConfig].
  SwipePopPage({
    required this.child,
    Duration? duration,
    this.curve = Curves.decelerate,
    this.reverseCurve = Curves.easeOutCubic,
    bool? enableFullScreenDrag,
    double? minimumDragFraction,
    double? velocityThreshold,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  })  : duration = duration ?? AppConfig.swipePopDuration,
        enableFullScreenDrag =
            enableFullScreenDrag ?? AppConfig.swipePopEnableFullScreenDrag,
        minimumDragFraction =
            (minimumDragFraction ?? AppConfig.swipePopMinimumDragFraction)
                .clamp(0.0, 1.0),
        velocityThreshold =
            velocityThreshold ?? AppConfig.swipePopVelocityThreshold;

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final bool enableFullScreenDrag;
  final double minimumDragFraction;
  final double velocityThreshold;

  /// Builds the concrete [PageRoute] wired with swipe handling.
  @override
  Route<T> createRoute(BuildContext context) {
    return SwipePopPageRoute<T>(
      builder: (_) => child,
      duration: duration,
      curve: curve,
      reverseCurve: reverseCurve,
      enableFullScreenDrag: enableFullScreenDrag,
      minimumDragFraction: minimumDragFraction,
      velocityThreshold: velocityThreshold,
      settings: this,
    );
  }
}

/// A [PageRoute] that supports configurable swipe-to-pop gestures.
class SwipePopPageRoute<T> extends PageRoute<T> {
  /// Configures a swipe-enabled route with the provided animation options.
  SwipePopPageRoute({
    required this.builder,
    required this.duration,
    required this.curve,
    required this.reverseCurve,
    required this.enableFullScreenDrag,
    required this.minimumDragFraction,
    required this.velocityThreshold,
    super.settings,
  }) : assert(minimumDragFraction >= 0 && minimumDragFraction <= 1);

  final WidgetBuilder builder;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final bool enableFullScreenDrag;
  final double minimumDragFraction;
  final double velocityThreshold;

  /// Always render the page as opaque so the previous route stays hidden.
  @override
  bool get opaque => true;

  /// Prevent dismissing via tapping the barrier; only swipes should pop.
  @override
  bool get barrierDismissible => false;

  /// Pages do not paint a modal barrier for this transition.
  @override
  Color? get barrierColor => null;

  /// There is no semantic barrier label because no barrier is shown.
  @override
  String? get barrierLabel => null;

  /// Preserve route state when it is partially covered during gestures.
  @override
  bool get maintainState => true;

  /// Use the configured forward duration for pushes.
  @override
  Duration get transitionDuration => duration;

  /// Mirror the forward duration when popping the route.
  @override
  Duration get reverseTransitionDuration => duration;

  /// Enable native-style pop gestures when allowed by configuration.
  @override
  bool get popGestureEnabled => enableFullScreenDrag;

  /// Build the underlying page contents without wrapping animations.
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  /// Wrap the page with gesture handling and Cupertino-style animations.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final wrapped = enableFullScreenDrag
        ? _FullScreenPopGestureDetector<T>(
            route: this,
            minimumDragFraction: minimumDragFraction,
            velocityThreshold: velocityThreshold,
            child: child,
          )
        : child;

    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: navigator?.userGestureInProgress ?? false,
      child: wrapped,
    );
  }

  /// Exposes the route's animation controller to gesture helpers.
  AnimationController get popGestureController => controller!;

  /// Exposes the navigator to coordinate gesture lifecycle events.
  NavigatorState get popGestureNavigator => navigator!;
}

/// Detects a full-screen horizontal drag and proxies it to the route.
class _FullScreenPopGestureDetector<T> extends StatefulWidget {
  /// Creates a widget that attaches swipe tracking to [route].
  const _FullScreenPopGestureDetector({
    required this.route,
    required this.child,
    required this.minimumDragFraction,
    required this.velocityThreshold,
  });

  final SwipePopPageRoute<T> route;
  final Widget child;
  final double minimumDragFraction;
  final double velocityThreshold;

  /// Builds the backing state object that listens for drag gestures.
  @override
  State<_FullScreenPopGestureDetector<T>> createState() =>
      _FullScreenPopGestureDetectorState<T>();
}

/// Handles gesture recognition and forwards drag progress to the controller.
class _FullScreenPopGestureDetectorState<T>
    extends State<_FullScreenPopGestureDetector<T>> {
  _FullScreenPopGestureController<T>? _controller;
  late HorizontalSwipeRecognizer _recognizer;

  /// Prepare the drag recognizer with handlers for the swipe lifecycle.
  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalSwipeRecognizer(
      allowedSign: 1,
      debugOwner: this,
    )
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel
      ..dragStartBehavior = DragStartBehavior.down;
  }

  /// Update gesture settings when inherited configuration changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final textDirection = Directionality.of(context);
    _recognizer
      ..gestureSettings = MediaQuery.maybeGestureSettingsOf(context)
      ..allowedSign = textDirection == TextDirection.rtl ? -1 : 1;
  }

  /// Dispose the recognizer and ensure the navigator ends any active gesture.
  @override
  void dispose() {
    _recognizer.dispose();
    if (_controller != null) {
      final navigator = _controller!.navigator;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator.mounted) navigator.didStopUserGesture();
      });
      _controller = null;
    }
    super.dispose();
  }

  /// Begin tracking a pointer if swiping back is currently allowed.
  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.route.popGestureEnabled) return;
    _recognizer.addPointer(event);
  }

  /// Start a new gesture controller when the finger begins moving.
  void _handleDragStart(DragStartDetails details) {
    widget.route.popGestureController.stop();
    _controller = _FullScreenPopGestureController<T>(
      route: widget.route,
      duration: widget.route.duration,
      forwardCurve: widget.route.curve,
      reverseCurve: widget.route.reverseCurve,
      minimumDragFraction: widget.minimumDragFraction,
      velocityThreshold: widget.velocityThreshold,
    );
  }

  /// Update the pop animation as the user drags the page toward the back gesture.
  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller == null) return;
    final size = context.size;
    if (size == null || size.width == 0) return;
    final delta = _convertToLogical((details.primaryDelta ?? 0) / size.width);
    _controller!.dragUpdate(delta);
  }

  /// Decide whether to complete the pop when the gesture finishes.
  void _handleDragEnd(DragEndDetails details) {
    if (_controller == null) return;
    final velocity = _convertToLogical(details.velocity.pixelsPerSecond.dx);
    final progress = 1 - widget.route.popGestureController.value;
    _controller!.dragEnd(velocity: velocity, dragFraction: progress);
    _controller = null;
  }

  /// Revert the animation if the drag cancels.
  void _handleDragCancel() {
    _controller?.dragCancel();
    _controller = null;
  }

  /// Normalize deltas so RTL layouts read swipes consistently.
  double _convertToLogical(double value) {
    final td = Directionality.of(context);
    return td == TextDirection.rtl ? -value : value;
  }

  /// Wrap the child with pointer listeners that feed the recognizer.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      behavior: HitTestBehavior.deferToChild,
      child: widget.child,
    );
  }
}

/// Drives the pop animation in response to drag updates.
class _FullScreenPopGestureController<T> {
  /// Hooks the controller into the route and notifies the navigator.
  _FullScreenPopGestureController({
    required SwipePopPageRoute<T> route,
    required this.duration,
    required this.forwardCurve,
    required this.reverseCurve,
    required this.minimumDragFraction,
    required this.velocityThreshold,
  })  : controller = route.popGestureController,
        navigator = route.popGestureNavigator {
    getIsCurrent = () => route.isCurrent;
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;
  final Duration duration;
  final Curve forwardCurve;
  final Curve reverseCurve;
  final double minimumDragFraction;
  final double velocityThreshold;
  late final bool Function() getIsCurrent;

  /// Update the animation progress as the finger moves.
  void dragUpdate(double delta) {
    controller.value = (controller.value - delta).clamp(0.0, 1.0);
  }

  /// Decide whether to complete the pop or restore the pushed page.
  void dragEnd({required double velocity, required double dragFraction}) {
    if (!getIsCurrent()) {
      _animateToPushed();
      return;
    }

    final shouldPop = (velocity > velocityThreshold)
        ? true
        : (velocity < -velocityThreshold)
            ? false
            : (dragFraction > minimumDragFraction);

    if (shouldPop) {
      navigator.pop();
      _listenUntilSettled();
    } else {
      _animateToPushed();
    }
  }

  /// Cancel the interaction and animate back to the pushed position.
  void dragCancel() => _animateToPushed();

  /// Animate the page to the fully pushed state.
  void _animateToPushed() {
    controller.animateTo(
      1.0,
      duration: _scaledDuration(1.0),
      curve: forwardCurve,
    );
    _listenUntilSettled();
  }

  /// Keep the navigator informed until the animation finishes.
  void _listenUntilSettled() {
    bool isSettled(AnimationStatus status) =>
        status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed;

    if (!controller.isAnimating && isSettled(controller.status)) {
      navigator.didStopUserGesture();
      return;
    }

    void listener(AnimationStatus status) {
      if (isSettled(status)) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(listener);
      }
    }

    controller.addStatusListener(listener);
  }

  /// Scale the animation duration based on the remaining distance.
  Duration _scaledDuration(double target) {
    final distance = (controller.value - target).abs();
    final ms = math.max(1, (duration.inMilliseconds * distance).round());
    return Duration(milliseconds: ms);
  }
}
