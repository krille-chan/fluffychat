import 'dart:math';

import 'package:flutter/material.dart';

import 'package:confetti/confetti.dart';

import 'package:fluffychat/config/app_config.dart';

class StarRainWidget extends StatefulWidget {
  final bool showBlast;
  final Duration rainDuration;
  final Duration blastDuration;
  final VoidCallback? onFinished;

  const StarRainWidget({
    super.key,
    this.showBlast = true,
    this.rainDuration = const Duration(seconds: 8),
    this.blastDuration = const Duration(seconds: 1),
    this.onFinished,
  });

  @override
  State<StarRainWidget> createState() => _StarRainWidgetState();
}

class _StarRainWidgetState extends State<StarRainWidget> {
  late ConfettiController _blastController;
  late ConfettiController _rainController;
  int numParticles = 2;
  double _fadeOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _blastController = ConfettiController(duration: widget.blastDuration);
    _rainController = ConfettiController(duration: widget.rainDuration);

    if (widget.showBlast) {
      _blastController.play();
    }
    _rainController.play();

    Future.delayed(const Duration(seconds: 4), () {
      if (_rainController.state == ConfettiControllerState.playing) {
        setState(() {
          numParticles = 1;
        });
      }
    });

    _fadeOpacity = 1.0;
    Future.delayed(widget.rainDuration, () async {
      if (mounted) {
        setState(() {
          _fadeOpacity = 0.0;
        });
      }
      await Future.delayed(const Duration(milliseconds: 800));
      widget.onFinished?.call();
      if (mounted) {
        _blastController.stop();
        _rainController.stop();
      }
    });
  }

  @override
  void dispose() {
    _blastController.dispose();
    _rainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const count = 3;
    const spawnOffsets = [0.2, 0.5, 0.8]; // Relative horizontal positions

    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        opacity: _fadeOpacity,
        duration: const Duration(milliseconds: 800),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Initial center blast (top center)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _blastController,
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
            // Rain confetti from the top (3 fixed spawn points)
            ...List.generate(count, (index) {
              return Positioned(
                top: -30,
                left: null,
                right: null,
                child: FractionallySizedBox(
                  widthFactor: 0,
                  alignment: Alignment(spawnOffsets[index] * 2 - 1, -1),
                  child: ConfettiWidget(
                    confettiController: _rainController,
                    blastDirectionality: BlastDirectionality.directional,
                    blastDirection: 3 * pi / 2,
                    shouldLoop: false,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    minimumSize: const Size(20, 20),
                    maximumSize: const Size(25, 25),
                    gravity: 0.07,
                    emissionFrequency: 0.1,
                    numberOfParticles: numParticles,
                    colors: const [AppConfig.goldLight, AppConfig.gold],
                    createParticlePath: drawStar,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
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
