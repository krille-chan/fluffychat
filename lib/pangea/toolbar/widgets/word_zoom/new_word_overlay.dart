import 'dart:math';

import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:flutter/material.dart';

class NewWordOverlay extends StatefulWidget {
  final Widget child;
  final bool show;
  final Color overlayColor;
  final GlobalKey cardKey;

  const NewWordOverlay({
    super.key,
    required this.child,
    required this.show,
    required this.overlayColor,
    required this.cardKey,
  });

  @override
  State<NewWordOverlay> createState() => _NewWordOverlayState();
}

class _NewWordOverlayState extends State<NewWordOverlay>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _xpScaleAnim;
  Animation<double>? _fadeAnim;
  Size size = const Size(0, 0);
  Offset position = const Offset(0, 0);
  OverlayEntry? _overlayEntry;
  bool _animationStarted = false;

  Widget? get svg => ConstructLevelEnum.seeds.icon();

  void _initAndStartAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _xpScaleAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      calculateSizeAndPosition();
      _showFlyingWidget();
      _controller?.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      _initAndStartAnimation();
      _animationStarted = true;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller?.dispose();
    super.dispose();
  }

  void calculateSizeAndPosition() {
    final RenderBox? box =
        widget.cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        position = box.localToGlobal(const Offset(-455, 0));
        size = box.size;
      });
    }
  }

  void _showFlyingWidget() {
    if (_controller == null || _xpScaleAnim == null || _fadeAnim == null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final scale = _xpScaleAnim!.value;
          final fade = 1.0 - (_fadeAnim!.value);
          // Calculate t for move to top left after 0.7
          double t = 0.0;
          if ((_controller!.value) >= 0.7) {
            t = ((_controller!.value) - 0.7) / 0.3;
            t = t.clamp(0.0, 1.0);
          }
          // Start position: center of card, End position: top left (0,0)
          final startX = position.dx + size.width / 2 - (37 * scale);
          final startY = position.dy + size.height / 2 + 20 - (37 * scale);
          const endX = 0.0;
          const endY = 0.0;
          final currentX = startX * (1 - t) + endX * t;
          final currentY = startY * (1 - t) + endY * t;
          return Positioned(
            left: currentX,
            top: currentY,
            child: Opacity(
              opacity: fade,
              child: Transform.rotate(
                angle: scale * 2 * pi,
                child: SizedBox(
                  width: 75 * scale,
                  height: 75 * scale,
                  child: svg ?? const SizedBox(),
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show && !_animationStarted) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 5,
          right: 5,
          top: 50,
          bottom: 5,
          child: FadeTransition(
            opacity: ReverseAnimation(_fadeAnim ?? kAlwaysCompleteAnimation),
            child: Container(
              color: widget.overlayColor,
            ),
          ),
        ),
      ],
    );
  }
}

const kAlwaysCompleteAnimation = AlwaysStoppedAnimation<double>(1.0);
