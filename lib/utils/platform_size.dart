import 'package:flutter/widgets.dart';

class PlatformWidth {
  static double? webWidth;

  static void initialize(BuildContext context) {
    webWidth = MediaQuery.of(context).size.width / 2;
  }
}
