import 'dart:math';

import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';

import 'package:fluffychat/config/app_config.dart';

OverlayEntry? _confettiEntry;
ConfettiController? _blastController;
ConfettiController? _rainController;

void rainConfetti(BuildContext context) {
  if (_confettiEntry != null) return; // Prevent duplicates

  _blastController = ConfettiController(duration: const Duration(seconds: 1));
  _rainController = ConfettiController(duration: const Duration(seconds: 3));

  _blastController!.play();
  _rainController!.play();

  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 600;
  final count = isSmallScreen ? 2 : 5;
  final spacing = screenWidth / (count + 1);

  _confettiEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Initial center blast
        Positioned(
          top: 0,
          left: screenWidth / 2,
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController: _blastController!,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: .02,
              numberOfParticles: 40,
              minimumSize: const Size(20, 20),
              maximumSize: const Size(25, 25),
              minBlastForce: 10,
              maxBlastForce: 40,
              gravity: 0.07,
              colors: const [AppConfig.goldLight, AppConfig.gold],
              createParticlePath: drawStar,
            ),
          ),
        ),

        // Rain confetti from the top
        ...List.generate(count, (index) {
          final left = spacing * (index + 1) - 10;

          return Positioned(
            top: -30, // Small buffer above top edge
            left: left,
            child: IgnorePointer(
              child: ConfettiWidget(
                confettiController: _rainController!,
                blastDirectionality: BlastDirectionality.directional,
                blastDirection: 3 * pi / 2,
                shouldLoop: true,
                maxBlastForce: 5,
                minBlastForce: 2,
                minimumSize: const Size(20, 20),
                maximumSize: const Size(25, 25),
                gravity: 0.07,
                emissionFrequency: 0.1,
                numberOfParticles: 2,
                colors: const [AppConfig.goldLight, AppConfig.gold],
                createParticlePath: drawStar,
              ),
            ),
          );
        }),
      ],
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(_confettiEntry!);
}

void stopConfetti() {
  _confettiEntry?.remove();
  _confettiEntry = null;

  _blastController?.dispose();
  _blastController = null;

  _rainController?.dispose();
  _rainController = null;
}

Path drawStar(Size size) {
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(
      halfWidth + externalRadius * cos(step),
      halfWidth + externalRadius * sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * cos(step + halfDegreesPerStep),
      halfWidth + internalRadius * sin(step + halfDegreesPerStep),
    );
  }
  path.close();
  return path;
}
