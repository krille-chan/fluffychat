import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressableButton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  final bool enabled;
  final bool depressed;

  final Color color;
  final Widget child;
  final void Function()? onPressed;

  const PressableButton({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.child,
    required this.onPressed,
    required this.color,
    this.enabled = true,
    this.depressed = false,
    super.key,
  });

  @override
  PressableButtonState createState() => PressableButtonState();
}

class PressableButtonState extends State<PressableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tweenAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _tweenAnimation = Tween<double>(begin: 5, end: 0).animate(_controller);
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
    widget.onPressed?.call();
    HapticFeedback.mediumImpact();
  }

  void _onTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: SizedBox(
        height: 45,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  Colors.black.withOpacity(0.25),
                  widget.color,
                ),
                borderRadius: widget.borderRadius,
              ),
            ),
            AnimatedBuilder(
              animation: _tweenAnimation,
              builder: (context, _) {
                return Positioned(
                  bottom: widget.depressed ? 0 : _tweenAnimation.value,
                  child: widget.child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
