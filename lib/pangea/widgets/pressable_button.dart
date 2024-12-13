import 'dart:async';

import 'package:fluffychat/pangea/utils/play_click_sound.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressableButton extends StatefulWidget {
  final BorderRadius borderRadius;
  final double buttonHeight;
  final bool depressed;
  final Color color;
  final Widget child;

  final void Function()? onPressed;
  final Stream? triggerAnimation;
  final ClickPlayer? clickPlayer;

  const PressableButton({
    required this.borderRadius,
    required this.child,
    required this.onPressed,
    required this.color,
    this.buttonHeight = 5,
    this.depressed = false,
    this.triggerAnimation,
    this.clickPlayer,
    super.key,
  });

  @override
  PressableButtonState createState() => PressableButtonState();
}

class PressableButtonState extends State<PressableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tweenAnimation;
  Completer<void>? _animationCompleter;
  StreamSubscription? _triggerAnimationSubscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tweenAnimation =
        Tween<double>(begin: 0, end: widget.buttonHeight).animate(_controller);
    if (!widget.depressed) {
      _triggerAnimationSubscription = widget.triggerAnimation?.listen((_) {
        _animationCompleter = Completer<void>();
        _animateUp();
        _animateDown();
      });
    }
  }

  void _onTapDown(TapDownDetails? details) {
    if (widget.depressed) return;
    _animationCompleter = Completer<void>();
    if (!mounted) return;
    _animateUp();
  }

  void _animateUp() {
    if (widget.depressed || !mounted) return;
    _controller.forward().then((_) {
      _animationCompleter?.complete();
      _animationCompleter = null;
    });
  }

  Future<void> _onTapUp(TapUpDetails? details) async {
    widget.onPressed?.call();
    if (widget.depressed) return;
    await _animateDown();
  }

  Future<void> _animateDown() async {
    if (_animationCompleter != null) {
      await _animationCompleter!.future;
    }
    widget.clickPlayer?.play();
    if (!kIsWeb) {
      HapticFeedback.mediumImpact();
    }
    if (mounted) _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.depressed) return;
    if (mounted) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    _triggerAnimationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _tweenAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                Colors.black.withOpacity(0.25),
                widget.color,
              ),
              borderRadius: widget.borderRadius,
            ),
            padding: EdgeInsets.only(
              bottom: !widget.depressed
                  ? widget.buttonHeight - _tweenAnimation.value
                  : 0,
            ),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.borderRadius,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
