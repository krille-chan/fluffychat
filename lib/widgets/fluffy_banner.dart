import 'package:flutter/material.dart';

class FluffyBanner extends StatelessWidget {
  const FluffyBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(Theme.of(context).brightness == Brightness.dark
        ? 'assets/banner_dark.png'
        : 'assets/banner.png');
  }
}
