import 'dart:math';

import 'package:fluffychat/config/themes.dart';
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
  bool columnMode = false;
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
      columnMode = FluffyThemes.isColumnMode(context);
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
    //find position of word card and overlaybox(chat view) to figure out where seed should start
    final RenderBox? cardBox =
        widget.cardKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (cardBox != null && overlayBox != null) {
      final cardGlobal = cardBox.localToGlobal(Offset.zero);
      final overlayGlobal = overlayBox.localToGlobal(Offset.zero);
      setState(() {
        position = cardGlobal - overlayGlobal;
        size = cardBox.size;
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
          double t = 0.0;
          if ((_controller!.value) >= 0.7) {
            t = ((_controller!.value) - 0.7) / 0.3;
            t = t.clamp(0.0, 1.0);
          }
          final startX = position.dx + size.width / 2 - (37 * scale);
          final startY = position.dy + size.height / 2 + 20 - (37 * scale);
          final endX = (columnMode) ? 0.0 : position.dx + size.width;
          final endY = (columnMode) ? 0.0 : position.dy + 30;
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
                  //if going to top right, shrinks as it moves to match word card seed size
                  width: 75 * scale * ((!columnMode) ? fade : 1),
                  height: 75 * scale * ((!columnMode) ? fade : 1),
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
