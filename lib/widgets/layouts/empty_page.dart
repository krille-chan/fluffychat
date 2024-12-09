import 'dart:math';

import 'package:fluffychat/pangea/widgets/common/pangea_logo_svg.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 400;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    final theme = Theme.of(context);
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
        // #Pangea
        child: PangeaLogoSvg(width: width),
        // child: Image.asset(
        //   'assets/logo_transparent.png',
        //   color: theme.colorScheme.surfaceContainerHigh,
        //   width: width,
        //   height: width,
        //   filterQuality: FilterQuality.medium,
        // ),
        // Pangea#
      ),
    );
  }
}
