import 'package:flutter/material.dart';
import 'package:tawkie/utils/platform_infos.dart';

class OpacityGradientImage extends StatelessWidget {
  const OpacityGradientImage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Determining whether the screen is large
    final isLargeScreen = screenHeight > 900;

    final imageHeight =
        isLargeScreen ? screenHeight * 0.60 : screenHeight * 0.35;
    return SizedBox(
      height: imageHeight,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.6), // Opacity at the top
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0), // Opacity at the bottom
            ],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Image.asset(
          'assets/no_sub.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          height: 260,
        ),
      ),
    );
  }
}