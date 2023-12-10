import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/widgets/common/pangea_logo_svg.dart';

class EmptyPage extends StatelessWidget {
  final bool loading;
  static const double _width = 300;
  const EmptyPage({this.loading = false, super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: 'info-logo',
              // #Pangea
              // child: Image.asset(
              //   'assets/favicon.png',
              //   width: width,
              //   height: width,
              //   filterQuality: FilterQuality.medium,
              // ),
              child: PangeaLogoSvg(width: width),
              // Pangea#
            ),
          ),
          if (loading)
            Center(
              child: SizedBox(
                width: width,
                child: const LinearProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
