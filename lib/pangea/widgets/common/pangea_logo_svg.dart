import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class PangeaLogoSvg extends StatelessWidget {
  const PangeaLogoSvg({super.key, required this.width, this.forceColor});

  final double width;
  final Color? forceColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/pangea/pangea_logo.svg',
      width: width,
      height: width,
      colorFilter: ColorFilter.mode(
        forceColor ??
            (Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary),
        BlendMode.srcIn,
      ),
    );
  }
}
