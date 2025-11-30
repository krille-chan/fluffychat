import 'dart:math';

import 'package:flutter/material.dart';

class BurstParticle {
  final double angle;
  final double distance;
  final double scale;
  final double rotation;

  BurstParticle({
    required this.angle,
    required this.distance,
    required this.scale,
    required this.rotation,
  });
}

class BurstPainter extends CustomPainter {
  final List<BurstParticle> particles;
  final double progress;
  final Color particleColor;
  final double baseRadius;

  BurstPainter({
    required this.particles,
    required this.progress,
    required this.particleColor,
    this.baseRadius = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final radians = particle.angle * (pi / 180);
      final currentDistance = particle.distance * progress * 0.8;
      final x = center.dx + cos(radians) * currentDistance;
      final y = center.dy + sin(radians) * currentDistance;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final animatedRadius =
          baseRadius * particle.scale * (1.0 - progress * 0.3);

      final paint = Paint()
        ..color = particleColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), animatedRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
