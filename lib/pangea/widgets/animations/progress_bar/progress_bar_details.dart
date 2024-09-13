import 'dart:ui';

class LevelBarDetails {
  final Color fillColor;
  final int currentPoints;

  const LevelBarDetails({
    required this.fillColor,
    required this.currentPoints,
  });
}

class ProgressBarDetails {
  final double totalWidth;
  final Color borderColor;
  final double height;

  const ProgressBarDetails({
    required this.totalWidth,
    required this.borderColor,
    this.height = 16,
  });
}
