import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 128;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: FluffyThemes.backgroundGradient(context, 128),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/favicon.png',
          width: width,
          height: width,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
