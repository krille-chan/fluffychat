import 'package:flutter/material.dart';

class PinClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path path = Path();
    path.moveTo(w * 0.1, h * 0.4);
    path.arcToPoint(
      Offset(w * 0.9, h * 0.4),
      radius: const Radius.circular(20),
    );
    path.quadraticBezierTo(w * 0.9, h * 0.75, w / 2, h);
    path.quadraticBezierTo(w * 0.1, h * 0.75, w * 0.1, h * 0.4);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
