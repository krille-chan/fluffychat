import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/utils/cutout_painter.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnchoredOverlayWidget extends StatefulWidget {
  final Widget child;
  final Rect anchorRect;
  final String overlayKey;
  final double? borderRadius;
  final double? padding;
  final VoidCallback? onClick;

  const AnchoredOverlayWidget({
    required this.child,
    required this.anchorRect,
    required this.overlayKey,
    this.borderRadius,
    this.padding,
    this.onClick,
    super.key,
  });

  @override
  State<AnchoredOverlayWidget> createState() => _AnchoredOverlayWidgetState();
}

class _AnchoredOverlayWidgetState extends State<AnchoredOverlayWidget> {
  bool _visible = false;

  static const double overlayWidth = 200.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _visible = true;
      }),
    );
  }

  Future<void> _closeOverlay() async {
    if (mounted) {
      setState(() {
        _visible = false;
      });
      await Future.delayed(FluffyThemes.animationDuration);
    }

    MatrixState.pAnyState.closeOverlay(widget.overlayKey);
  }

  @override
  Widget build(BuildContext context) {
    final leftPosition = (widget.anchorRect.left +
            (widget.anchorRect.width / 2) -
            (overlayWidth / 2))
        .clamp(8.0, MediaQuery.sizeOf(context).width - overlayWidth - 8.0);

    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: FluffyThemes.animationDuration,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            final tapPos = details.globalPosition;
            if (widget.anchorRect.contains(tapPos)) {
              _closeOverlay();
              widget.onClick?.call();
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: CutoutBackgroundPainter(
                    holeRect: widget.anchorRect,
                    backgroundColor: Colors.black54,
                    borderRadius: widget.borderRadius ?? 0.0,
                    padding: widget.padding ?? 6.0,
                  ),
                ),
              ),
              Positioned(
                left: leftPosition,
                top: widget.anchorRect.bottom + (widget.padding ?? 6.0),
                child: Material(
                  color: Colors.transparent,
                  elevation: 4,
                  child: SizedBox(
                    width: overlayWidth,
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
