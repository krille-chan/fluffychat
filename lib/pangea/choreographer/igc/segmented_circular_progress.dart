import 'dart:math';

import 'package:flutter/material.dart';

class SegmentedCircularProgress extends StatelessWidget {
  final List<Segment> segments;
  final double strokeWidth;
  final Widget? child;

  const SegmentedCircularProgress({
    super.key,
    required this.segments,
    this.strokeWidth = 4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SegmentedPainter(segments: segments, strokeWidth: strokeWidth),
      child: child,
    );
  }
}

class Segment {
  final double value; // relative value
  final Color color;
  final double opacity;

  Segment(this.value, this.color, {this.opacity = 1.0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Segment &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          color == other.color &&
          opacity == other.opacity;

  @override
  int get hashCode => value.hashCode ^ color.hashCode ^ opacity.hashCode;
}

class _SegmentedPainter extends CustomPainter {
  final List<Segment> segments;
  final double strokeWidth;
  final double gapFactor = 1.4;

  const _SegmentedPainter({required this.segments, this.strokeWidth = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    final radius = arcRect.width / 2;
    final center = arcRect.center;

    if (segments.isEmpty) return;
    if (segments.length == 1) {
      final segment = segments.first;
      paint.color = segment.color.withAlpha((segment.opacity * 255).ceil());
      canvas.drawCircle(center, radius, paint);
      return;
    }

    final total = segments.fold<double>(0, (sum, s) => sum + s.value);

    paint.strokeCap = StrokeCap.round;

    final baseCapAngle = strokeWidth / radius;
    final capAngle = baseCapAngle * gapFactor;

    double startAngle = -pi / 2;

    for (final segment in segments) {
      final rawSweep = (segment.value / total) * 2 * pi;
      final sweep = rawSweep - capAngle;

      if (sweep <= 0) {
        startAngle += rawSweep;
        continue;
      }

      paint.color = segment.color.withAlpha((segment.opacity * 255).ceil());

      canvas.drawArc(arcRect, startAngle + capAngle / 2, sweep, false, paint);

      startAngle += rawSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
