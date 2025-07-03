import 'dart:math';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:flutter/material.dart';

class NewWordOverlay extends StatefulWidget {
  final Color overlayColor;
  final GlobalKey cardKey;

  const NewWordOverlay({
    super.key,
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
  bool columnMode = false;
  Widget? get svg => ConstructLevelEnum.seeds.icon();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
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
    _overlayEntry?.remove(); // Remove any existing overlay
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
          //move starting position as seed grows so it stays centered
          final startX = position.dx + size.width / 2 - (37 * scale);
          final startY = position.dy + size.height / 2 + 20 - (37 * scale);
          //end is top left if column mode (going towards vocab stats) or top right of card otherwise
          final endX = (columnMode) ? 0.0 : position.dx + size.width;
          final endY = (columnMode) ? 0.0 : position.dy + 30;
          final currentX = startX * (1 - t) + endX * t;
          final currentY = startY * (1 - t) + endY * t;
          //Grows into frame, and then shrinks if going to top right so it matches card seed size
          final seedSize = 75 * scale * ((!columnMode) ? fade : 1);

          return Positioned(
            left: currentX,
            top: currentY,
            child: Opacity(
              opacity: fade,
              child: Transform.rotate(
                angle: scale * 2 * pi,
                child: SizedBox(
                  //if going to card top right, shrinks as it moves to match word card seed size
                  width: seedSize,
                  height: seedSize,
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
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          color: Colors.transparent,
        ),
        Positioned(
          left: 5,
          right: 5,
          top: 50,
          bottom: 5,
          child: Container(
            height: size.height,
            width: size.width,
            color: widget.overlayColor,
          ),
        ),
      ],
    );
  }
}

const kAlwaysCompleteAnimation = AlwaysStoppedAnimation<double>(1.0);
