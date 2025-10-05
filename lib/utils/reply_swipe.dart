import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum ReplySwipeDirection { startToEnd, endToStart }

typedef ReplyBackgroundBuilder = Widget Function(
  BuildContext context,
  ReplySwipeDirection direction,
  double progress, // 0..1
);

/// Swipe-to-reply that animates the child, fires [onReply] once threshold
/// is crossed, then snaps back. Rejects early if initial motion is the
/// opposite direction so parents can win the arena.
class ReplySwipe extends StatefulWidget {
  const ReplySwipe({
    super.key,
    required this.child,
    required this.onReply,
    this.direction = ReplySwipeDirection.startToEnd,
    this.thresholdPx = 56.0,
    this.maxDragPx = 96.0,
    this.hapticOnThreshold = true,
    this.backgroundBuilder,
    this.allowedPointerKinds, // optional filter (e.g., {touch, trackpad})
  });

  final Widget child;
  final VoidCallback onReply;
  final ReplySwipeDirection direction;
  final double thresholdPx;
  final double maxDragPx;
  final bool hapticOnThreshold;
  final ReplyBackgroundBuilder? backgroundBuilder;

  /// Optional: restrict which input devices can trigger the drag (passes to
  /// recognizer.supportedDevices). If null, uses Flutter's default.
  final Set<PointerDeviceKind>? allowedPointerKinds;

  @override
  State<ReplySwipe> createState() => _ReplySwipeState();
}

class _ReplySwipeState extends State<ReplySwipe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  double _dragX = 0.0; // >= 0
  bool _thresholdBuzzed = false;

  int _signFor(TextDirection textDir) {
    final ltr = textDir == TextDirection.ltr;
    final dir = widget.direction;
    if (dir == ReplySwipeDirection.startToEnd) return ltr ? 1 : -1;
    return ltr ? -1 : 1;
  }

  void _setDragX(double v) {
    final clamped = v.clamp(0.0, widget.maxDragPx).toDouble();
    if (clamped != _dragX) {
      setState(() => _dragX = clamped);
      final crossed = _dragX >= widget.thresholdPx;
      if (widget.hapticOnThreshold && crossed && !_thresholdBuzzed) {
        HapticFeedback.selectionClick();
        _thresholdBuzzed = true;
      }
      if (!crossed) _thresholdBuzzed = false;
    }
  }

  Future<void> _snapBack() async {
    final start = _dragX;
    if (start == 0.0) return;
    final anim = Tween<double>(begin: start, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    void listener() => setState(() => _dragX = anim.value);
    _ctrl
      ..value = 0.0
      ..addListener(listener);
    try {
      await _ctrl.forward();
    } finally {
      _ctrl.removeListener(listener);
      setState(() => _dragX = 0.0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDir = Directionality.of(context);
    final allowedSign = _signFor(textDir);
    final sign = allowedSign.toDouble();
    final progress = (_dragX / widget.maxDragPx).clamp(0.0, 1.0).toDouble();

    return RawGestureDetector(
      behavior: HitTestBehavior.deferToChild,
      gestures: {
        _DirectionalSwipeRecognizer:
            GestureRecognizerFactoryWithHandlers<_DirectionalSwipeRecognizer>(
          () => _DirectionalSwipeRecognizer(
            allowedSign: allowedSign,
            onAccepted: () {}, // hook if needed
          ),
          (rec) {
            // Optional: restrict devices like Swipeable.allowedPointerKinds
            rec.supportedDevices = widget.allowedPointerKinds;
            rec.allowedSign = allowedSign;

            rec
              ..onUpdate = (details) {
                final delta = details.delta.dx * sign;
                if (delta >= 0) {
                  _setDragX(_dragX + delta);
                } else {
                  final next = _dragX + delta;
                  _setDragX(next >= 0 ? next : 0.0);
                }
              }
              ..onEnd = (_) async {
                final triggered = _dragX >= widget.thresholdPx;
                if (triggered) widget.onReply();
                await _snapBack();
              };
          },
        ),
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.backgroundBuilder != null)
            Positioned.fill(
              child: widget.backgroundBuilder!(
                context,
                widget.direction,
                progress,
              ),
            )
          else
            _DefaultReplyBackground(
              direction: widget.direction,
              progress: progress,
            ),
          Transform.translate(
            offset: Offset(sign * _dragX, 0.0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Custom recognizer that rejects early when initial movement is opposite
/// the allowed horizontal sign; accepts once slop is passed in allowed dir.
class _DirectionalSwipeRecognizer extends HorizontalDragGestureRecognizer {
  _DirectionalSwipeRecognizer({required this.allowedSign, this.onAccepted});

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

/// Default background: Material reply icon that fades/slides in.
class _DefaultReplyBackground extends StatelessWidget {
  const _DefaultReplyBackground({
    required this.direction,
    required this.progress,
  });

  final ReplySwipeDirection direction;
  final double progress; // 0..1

  @override
  Widget build(BuildContext context) {
    final textDir = Directionality.of(context);
    final isStartToEnd = direction == ReplySwipeDirection.startToEnd;

    final align = switch ((isStartToEnd, textDir)) {
      (true, TextDirection.ltr) => Alignment.centerLeft,
      (true, TextDirection.rtl) => Alignment.centerRight,
      (false, TextDirection.ltr) => Alignment.centerRight,
      (false, TextDirection.rtl) => Alignment.centerLeft,
    };

    final slideSign = align == Alignment.centerLeft ? -1.0 : 1.0;

    return IgnorePointer(
      child: Container(
        alignment: align,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset((1 - progress) * 8.0 * slideSign, 0.0),
            child: const Icon(Icons.reply, size: 20),
          ),
        ),
      ),
    );
  }
}
