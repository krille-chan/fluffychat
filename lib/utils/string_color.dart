import 'package:flutter/material.dart';

extension StringColor on String {
  Color get color {
    double number = 0.0;
    for (var i = 0; i < this.length; i++) {
      number += this.codeUnitAt(i);
    }
    number = (number % 10) * 25.5;
    return HSLColor.fromAHSL(1, number, 1, 0.35).toColor();
  }
}
