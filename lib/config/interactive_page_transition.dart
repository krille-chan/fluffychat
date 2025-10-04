import 'package:flutter/material.dart';

class InteractivePageTransition extends Page {
  final Widget child;
  final bool isLeftToRight;

  const InteractivePageTransition({
    required LocalKey key,
    required this.child,
    String? restorationId,
    this.isLeftToRight = true,
  }) : super(key: key, restorationId: restorationId);

  @override
  Route createRoute(BuildContext context) {
    return InteractivePageRoute(
      settings: this,
      builder: (BuildContext context) => child,
      isLeftToRight: isLeftToRight,
    );
  }
}

class InteractivePageRoute extends PageRoute {
  final WidgetBuilder builder;
  final bool isLeftToRight;

  InteractivePageRoute({
    required this.builder,
    required this.isLeftToRight,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SwipeBackDetector(
      isLeftToRight: isLeftToRight,
      onSwipeBack: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: SlideTransition(
        position: Tween<Offset>(
          begin:
              isLeftToRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }
}

class SwipeBackDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeBack;
  final bool isLeftToRight;

  const SwipeBackDetector({
    Key? key,
    required this.child,
    required this.onSwipeBack,
    this.isLeftToRight = true,
  }) : super(key: key);

  @override
  State<SwipeBackDetector> createState() => _SwipeBackDetectorState();
}

class _SwipeBackDetectorState extends State<SwipeBackDetector>
    with SingleTickerProviderStateMixin {
  static const double _kSwipeThreshold = 0.2;
  static const double _kMaxSlideDistance = 0.75;

  late AnimationController _controller;
  double _dragExtent = 0.0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.addStatusListener(_handleAnimationStatusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && _controller.value == 1.0) {
      widget.onSwipeBack();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.isLeftToRight) {
      setState(() {
        _dragging = true;
        _dragExtent = 0.0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final delta = details.primaryDelta ?? 0.0;

    // if ((widget.isLeftToRight && delta > 0) ||
    //     (!widget.isLeftToRight && delta < 0)) {
    setState(() {
      _dragExtent += delta;
      // Normalize to [0, 1] range with damping as we approach maxDistance
      final normalizedDragExtent =
          (_dragExtent / screenWidth).clamp(0.0, _kMaxSlideDistance);
      _controller.value = normalizedDragExtent;
    });
    // }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_dragging) return;

    final thresholdMet = _controller.value > _kSwipeThreshold;

    if (thresholdMet) {
      _controller.animateTo(1.0, curve: Curves.easeOut);
    } else {
      _controller.animateTo(0.0, curve: Curves.easeIn);
    }

    setState(() {
      _dragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final slideAmount = _controller.value;

          return Stack(
            children: [
              // Background (room list) becoming visible as we slide
              if (slideAmount > 0)
                Positioned.fill(
                  child: FractionalTranslation(
                    translation: Offset(-1 + slideAmount, 0),
                    child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),

              // Foreground (current chat room) sliding away
              Transform.translate(
                offset:
                    Offset(MediaQuery.of(context).size.width * slideAmount, 0),
                child: widget.child,
              ),

              // Shadow effect along the left edge when sliding
              if (slideAmount > 0)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 5.0,
                  child: Opacity(
                    opacity: slideAmount,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
