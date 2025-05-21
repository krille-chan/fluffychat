import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

class AnimatedLevelBar extends StatefulWidget {
  final double height;
  final double beginWidth;
  final double endWidth;
  final Color primaryColor;
  final Color highlightColor;

  const AnimatedLevelBar({
    super.key,
    required this.height,
    required this.beginWidth,
    required this.endWidth,
    required this.primaryColor,
    required this.highlightColor,
  });

  @override
  AnimatedLevelBarState createState() => AnimatedLevelBarState();
}

class AnimatedLevelBarState extends State<AnimatedLevelBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get _beginWidth => max(20, widget.beginWidth);
  double get _endWidth => max(20, widget.endWidth);

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
    if (max(20, oldWidget.endWidth) != max(20, widget.endWidth)) {
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
        begin: _endWidth,
        end: _endWidth,
      ).animate(_controller);
    }

    // animate the width of the bar
    return Tween<double>(
      begin: _beginWidth,
      end: _endWidth,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              height: widget.height,
              width: _animation.value,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppConfig.borderRadius),
                ),
              ),
            ),
            Positioned(
              top: 2,
              left: 8,
              child: Container(
                height: 6,
                width: _animation.value >= 16 ? _animation.value - 16 : 0,
                decoration: BoxDecoration(
                  color: widget.highlightColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppConfig.borderRadius),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
