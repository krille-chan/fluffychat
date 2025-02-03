import 'dart:ui';

class LevelBarDetails {
  final Color fillColor;
  final int currentPoints;
  final double widthMultiplier;

  const LevelBarDetails({
    required this.fillColor,
    required this.currentPoints,
    required this.widthMultiplier,
  });
}

class ProgressBarDetails {
  final double totalWidth;
  final Color borderColor;
  final double height;

  const ProgressBarDetails({
    required this.totalWidth,
    required this.borderColor,
    this.height = 14,
  });
}
