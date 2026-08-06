import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final Widget child;
  final Function(bool isZoomed) onZoomChanged;
  final Function(ScaleEndDetails)? onInteractionEnd;
  final Function(double delta) onDriveScroll;
  final Function(ScaleEndDetails details) onDriveScrollEnd;

  const ZoomableImage({
    super.key,
    required this.child,
    required this.onZoomChanged,
    required this.onDriveScroll,
    required this.onDriveScrollEnd,
    this.onInteractionEnd,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with TickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    Matrix4 currentMatrix = _transformationController.value;
    double currentScale = currentMatrix.getMaxScaleOnAxis();

    Matrix4 endMatrix;
    if (currentScale > 1.0) {
      // Zoom out to 1.0
      endMatrix = Matrix4.identity();
      widget.onZoomChanged(false); // We are animating to zoomed out
    } else {
      // Zoom in to 3.0 centered on the tap position
      final position = _doubleTapDetails?.localPosition ??
          Offset(context.size!.width / 2, context.size!.height / 2);
      
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      widget.onZoomChanged(true);
    }

    _animation = Matrix4Tween(
      begin: currentMatrix,
      end: endMatrix,
    ).animate(CurveTween(curve: Curves.easeInOut).animate(_animationController));

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1.0,
        maxScale: 10.0,
        onInteractionStart: (_) {
          _animationController.stop();
          widget.onZoomChanged(true);
        },
        onInteractionUpdate: (details) {
          // If we are fully zoomed out, we drive the scroll
          if (_transformationController.value.getMaxScaleOnAxis() <= 1.0 && details.scale == 1.0) {
             widget.onDriveScroll(details.focalPointDelta.dy);
          }
        },
        onInteractionEnd: (details) {
          if (_transformationController.value.getMaxScaleOnAxis() <= 1.0) {
            widget.onZoomChanged(false);
            // Snap the scroll
            widget.onDriveScrollEnd(details);
          }
          widget.onInteractionEnd?.call(details);
        },
        child: widget.child,
      ),
    );
  }
}
