import 'package:flutter/material.dart';

extension StringColor on String {
  Color get color {
    var number = 0.0;
    for (var i = 0; i < length; i++) {
      number += codeUnitAt(i);
    }
    number = (number % 12) * 25.5;
    return HSLColor.fromAHSL(1, number, 1, 0.35).toColor();
  }

  Color get darkColor {
    var number = 0.0;
    for (var i = 0; i < length; i++) {
      number += codeUnitAt(i);
    }
    number = (number % 12) * 25.5;
    return HSLColor.fromAHSL(1, number, 1, 0.2).toColor();
  }

  Color get lightColor {
    var number = 0.0;
    for (var i = 0; i < length; i++) {
      number += codeUnitAt(i);
    }
    number = (number % 12) * 25.5;
    return HSLColor.fromAHSL(1, number, 1, 0.8).toColor();
  }
}
