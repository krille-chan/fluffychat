import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hermes/utils/horizontal_swipe_recognizer.dart';

typedef ReplyBackgroundBuilder = Widget Function(
  BuildContext context,
  bool leftToRight,
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
    this.leftToRight = true,
    this.thresholdPx = 56.0,
    this.maxDragPx = 96.0,
    this.hapticOnThreshold = true,
    this.backgroundBuilder,
  });

  final Widget child;
  final VoidCallback onReply;
  final bool leftToRight;
  final double thresholdPx;
  final double maxDragPx;
  final bool hapticOnThreshold;
  final ReplyBackgroundBuilder? backgroundBuilder;

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
    final allowedSign = widget.leftToRight ? -1 : 1;
    final sign = allowedSign.toDouble();
    final progress = (_dragX / widget.maxDragPx).clamp(0.0, 1.0).toDouble();

    return RawGestureDetector(
      behavior: HitTestBehavior.deferToChild,
      gestures: {
        HorizontalSwipeRecognizer:
            GestureRecognizerFactoryWithHandlers<HorizontalSwipeRecognizer>(
          () => HorizontalSwipeRecognizer(
            allowedSign: allowedSign,
          ),
          (rec) {
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
          Positioned.fill(
            child: widget.backgroundBuilder!(
              context,
              widget.leftToRight,
              progress,
            ),
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
