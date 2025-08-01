import 'dart:math';

import 'package:flutter/material.dart';

const int choiceArrayAnimationDuration = 500;

/// Show different animation depending on whether
/// the choice is correct, wrong, or neither
class ChoiceAnimationWidget extends StatefulWidget {
  final bool isSelected;
  final bool? isCorrect;
  final Widget child;

  const ChoiceAnimationWidget({
    super.key,
    required this.isSelected,
    this.isCorrect,
    required this.child,
  });

  @override
  ChoiceAnimationWidgetState createState() => ChoiceAnimationWidgetState();
}

class ChoiceAnimationWidgetState extends State<ChoiceAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: choiceArrayAnimationDuration),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ChoiceAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.isSelected && widget.isSelected != oldWidget.isSelected) ||
        widget.isCorrect != oldWidget.isCorrect) {
      _controller.forward().then((_) => _controller.reset());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> get _animation => widget.isCorrect == true
      ? TweenSequence<double>([
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.0, end: 1.2),
            weight: 1.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.2, end: 1.0),
            weight: 1.0,
          ),
        ]).animate(_controller)
      : TweenSequence<double>([
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: -8 * pi / 180),
            weight: 1.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: -8 * pi / 180, end: 16 * pi / 180),
            weight: 2.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 16 * pi / 180, end: 0),
            weight: 1.0,
          ),
        ]).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return widget.isCorrect == null
        ? widget.child
        : widget.isCorrect == true
            ? AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: child,
                  );
                },
                child: widget.child,
              )
            : AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value,
                    child: child,
                  );
                },
                child: widget.child,
              );
  }
}
