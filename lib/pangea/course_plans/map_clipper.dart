import 'package:flutter/material.dart';

class MapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, h * 0.15);
    path.lineTo(w * 0.33, 0);
    path.lineTo(w * 0.66, h * 0.15);
    path.lineTo(w, 0);
    path.lineTo(w, h * 0.85);
    path.lineTo(w * 0.66, h);
    path.lineTo(w * 0.33, h * 0.85);
    path.lineTo(0, h);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
