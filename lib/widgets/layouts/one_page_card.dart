//@dart=2.12

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OnePageCard extends StatelessWidget {
  final Widget child;

  /// This will cause the "isLogged()" check to be skipped and force a
  /// OnePageCard without login wallpaper. This can be used in situations where
  /// "Matrix.of(context) is not yet available, e.g. in the LockScreen widget.
  final bool forceBackgroundless;

  const OnePageCard(
      {Key? key, required this.child, this.forceBackgroundless = false})
      : super(key: key);

  static const int alpha = 12;
  static num breakpoint = FluffyThemes.columnWidth * 2;
  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        max<double>((MediaQuery.of(context).size.width - 600) / 2, 24);
    return MediaQuery.of(context).size.width <= breakpoint ||
            forceBackgroundless ||
            Matrix.of(context).client.isLogged()
        ? child
        : Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: max((MediaQuery.of(context).size.height - 600) / 2, 24),
              ),
              child: SafeArea(child: Card(elevation: 16, child: child)),
            ),
          );
  }
}
