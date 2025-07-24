import 'dart:math';

import 'package:flutter/material.dart';

class BurstParticle {
  final String emoji;
  final double angle;
  final double distance;
  final double scale;
  final double rotation;

  BurstParticle({
    required this.emoji,
    required this.angle,
    required this.distance,
    required this.scale,
    required this.rotation,
  });
}

class BurstPainter extends CustomPainter {
  final List<BurstParticle> particles;
  final double progress;

  BurstPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final radians = particle.angle * (pi / 180);
      final currentDistance = particle.distance * progress;
      final x = center.dx + cos(radians) * currentDistance;
      final y = center.dy + sin(radians) * currentDistance;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final animatedScale = particle.scale * (1.0 + (progress * 0.5)) * opacity;

      canvas.save();
      canvas.translate(x, y);
      canvas.scale(animatedScale);
      canvas.rotate(particle.rotation * progress * (pi / 180));

      final textPainter = TextPainter(
        text: TextSpan(
          text: particle.emoji,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      textPainter.dispose();

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
