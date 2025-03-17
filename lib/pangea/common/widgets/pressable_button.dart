import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffychat/pangea/common/utils/play_click_sound.dart';

class PressableButton extends StatefulWidget {
  final BorderRadius borderRadius;
  final double buttonHeight;
  final bool depressed;
  final Color color;
  final Widget child;

  final void Function()? onPressed;
  final Stream? triggerAnimation;
  final bool playSound;

  final bool? isShadow;

  const PressableButton({
    required this.borderRadius,
    required this.child,
    required this.onPressed,
    required this.color,
    this.buttonHeight = 4,
    this.depressed = false,
    this.triggerAnimation,
    this.isShadow,
    this.playSound = false,
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
  final ClickPlayer clickPlayer = ClickPlayer();

  // seperate the widget's depressed state from the internal
  // state to enable animations when this changes
  bool _depressed = false;

  @override
  void initState() {
    super.initState();
    _depressed = widget.depressed;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tweenAnimation =
        Tween<double>(begin: 0, end: widget.buttonHeight).animate(_controller);

    if (!_depressed) {
      _triggerAnimationSubscription = widget.triggerAnimation?.listen((_) {
        _animationCompleter = Completer<void>();
        _animateUp();
        _animateDown();
      });
    }
  }

  @override
  void didUpdateWidget(PressableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_depressed && !widget.depressed) {
      _controller.forward().then((_) {
        _depressed = widget.depressed;
        _controller.reverse();
      });
    } else if (!_depressed && widget.depressed) {
      _controller.forward().then((_) {
        _depressed = widget.depressed;
      });
    }
  }

  // bool get _isLightMode => Theme.of(context).brightness == Brightness.light;

  void _onTapDown(TapDownDetails? details) {
    if (_depressed) return;
    _animationCompleter = Completer<void>();
    if (!mounted) return;
    _animateUp();
  }

  void _animateUp() {
    if (_depressed || !mounted) return;
    _controller.forward().then((_) {
      _animationCompleter?.complete();
      _animationCompleter = null;
    });
  }

  Future<void> _onTapUp(TapUpDetails? details) async {
    if (_animationCompleter != null) {
      await _animationCompleter!.future;
    }
    widget.onPressed?.call();
    if (_depressed) return;
    await _animateDown();
  }

  Future<void> _animateDown() async {
    if (_animationCompleter != null) {
      await _animationCompleter!.future;
    }
    if (widget.playSound) clickPlayer.play();
    if (!kIsWeb) {
      HapticFeedback.mediumImpact();
    }
    if (mounted) _controller.reverse();
  }

  void _onTapCancel() {
    if (_depressed) return;
    if (mounted) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    _triggerAnimationSubscription?.cancel();
    clickPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _tweenAnimation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: _tweenAnimation.value),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            Colors.black.withAlpha(70),
                            widget.color,
                          ),
                          borderRadius: widget.borderRadius,
                        ),
                        padding: EdgeInsets.only(
                          bottom: !_depressed
                              ? widget.buttonHeight - _tweenAnimation.value
                              : 0,
                          right: !_depressed
                              ? (widget.buttonHeight - _tweenAnimation.value) /
                                  2
                              : 0,
                        ),
                        child: child,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: _tweenAnimation.value / 2),
              ],
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
