// Flutter imports:
import 'package:flutter/material.dart';

class ChoreoColor {
  static Color containerBG(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color textColor(BuildContext context) =>
      isLightMode(context) ? Colors.black : Colors.white;
  static Color disabled(context) => const Color.fromARGB(255, 211, 211, 211);
  static Color removeButtonColor(context) =>
      Theme.of(context).colorScheme.primary;
  static bool isLightMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? true : false;
}
