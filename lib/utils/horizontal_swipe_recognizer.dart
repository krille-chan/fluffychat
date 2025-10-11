import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom recognizer that only accepts drags once movement exceeds touch slop
/// in the externally provided horizontal direction.
class HorizontalSwipeRecognizer extends HorizontalDragGestureRecognizer {
  HorizontalSwipeRecognizer({
    required this.allowedSign,
    this.onAccepted,
    super.debugOwner,
  });

  /// The horizontal direction we treat as a valid swipe (+1 or -1).
  int allowedSign;

  final VoidCallback? onAccepted;
  double _accumulatedDelta = 0.0;
  bool _resolvedDirection = false;
  PointerDeviceKind? _pointerKind;

  void _resetState() {
    _accumulatedDelta = 0.0;
    _resolvedDirection = false;
    _pointerKind = null;
  }

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _resetState();
    _pointerKind = event.kind;
    super.addAllowedPointer(event);
  }

  double _slopFor(PointerEvent event) {
    final kind = _pointerKind ?? event.kind;
    return computeHitSlop(kind, gestureSettings);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_resolvedDirection &&
        (event is PointerMoveEvent || event is PointerPanZoomUpdateEvent)) {
      _pointerKind ??= event.kind;
      final deltaX = event is PointerMoveEvent
          ? event.localDelta.dx
          : (event as PointerPanZoomUpdateEvent).panDelta.dx;
      if (deltaX != 0.0) {
        final logicalDelta = deltaX * allowedSign;
        _accumulatedDelta += logicalDelta;
        final slop = _slopFor(event);
        if (_accumulatedDelta.abs() > slop) {
          _resolvedDirection = true;
          if (_accumulatedDelta < 0) {
            resolve(GestureDisposition.rejected);
            stopTrackingPointer(event.pointer);
            _resetState();
            return;
          }
          resolve(GestureDisposition.accepted);
          onAccepted?.call();
        }
      }
    }
    super.handleEvent(event);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _resetState();
    super.didStopTrackingLastPointer(pointer);
  }
}
