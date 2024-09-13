import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

class AnimatedLevelBar extends StatefulWidget {
  final double height;
  final double beginWidth;
  final double endWidth;
  final BoxDecoration? decoration;

  const AnimatedLevelBar({
    super.key,
    required this.height,
    required this.beginWidth,
    required this.endWidth,
    this.decoration,
  });

  @override
  AnimatedLevelBarState createState() => AnimatedLevelBarState();
}

class AnimatedLevelBarState extends State<AnimatedLevelBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Whether the animation has run for the first time during initState. Don't
  /// want the animation to run when the widget mounts, only when points are gained.
  bool _init = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _controller.forward().then((_) => _init = false);
  }

  @override
  void didUpdateWidget(covariant AnimatedLevelBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endWidth != widget.endWidth) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> get _animation {
    // If this is the first run of the animation, don't animate. This is just the widget mounting,
    // not a points gain. This could instead be 'if going from 0 to a non-zero value', but that
    // would remove the animation for first points gained. It would remove the need for a flag though.
    if (_init) {
      return Tween<double>(
        begin: widget.endWidth,
        end: widget.endWidth,
      ).animate(_controller);
    }

    // animate the width of the bar
    return Tween<double>(
      begin: widget.beginWidth,
      end: widget.endWidth,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: _animation.value,
          decoration: widget.decoration,
        );
      },
    );
  }
}
