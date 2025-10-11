import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom recognizer that rejects early when initial movement is opposite
/// the allowed horizontal sign; accepts once slop is passed in allowed dir.
class DirectionalSwipeRecognizer extends HorizontalDragGestureRecognizer {
  DirectionalSwipeRecognizer({required this.allowedSign, this.onAccepted});

  /// The horizontal direction we treat as a valid swipe (+1 or -1).
  int allowedSign;

  final VoidCallback? onAccepted;

  double _positiveExtent = 0.0;
  double _negativeExtent = 0.0;
  bool _accepted = false;
  PointerDeviceKind? _pointerKind;

  void _resetState() {
    _positiveExtent = 0.0;
    _negativeExtent = 0.0;
    _accepted = false;
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

  void _accumulateDelta(double delta) {
    if (delta > 0) {
      _positiveExtent += delta;
    } else if (delta < 0) {
      _negativeExtent += -delta;
    }
  }

  bool _resolveForDirection(int direction, PointerEvent event) {
    if (direction == allowedSign) {
      _accepted = true;
      resolve(GestureDisposition.accepted);
      onAccepted?.call();
      return true;
    } else if (direction == -allowedSign) {
      resolve(GestureDisposition.rejected);
      stopTrackingPointer(event.pointer);
      _resetState();
      return true;
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_accepted) {
      if (event is PointerMoveEvent) {
        _pointerKind ??= event.kind;
        final deltaX = event.localDelta.dx;
        if (deltaX != 0.0) {
          _accumulateDelta(deltaX);
          final slop = _slopFor(event);
          if (_positiveExtent > slop) {
            if (_resolveForDirection(1, event)) {
              return;
            }
          } else if (_negativeExtent > slop) {
            if (_resolveForDirection(-1, event)) {
              return;
            }
          }
        }
      } else if (event is PointerPanZoomUpdateEvent) {
        _pointerKind ??= event.kind;
        final deltaX = event.panDelta.dx;
        if (deltaX != 0.0) {
          _accumulateDelta(deltaX);
          final slop = _slopFor(event);
          if (_positiveExtent > slop) {
            if (_resolveForDirection(1, event)) {
              return;
            }
          } else if (_negativeExtent > slop) {
            if (_resolveForDirection(-1, event)) {
              return;
            }
          }
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
