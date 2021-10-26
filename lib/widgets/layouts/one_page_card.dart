import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OnePageCard extends StatelessWidget {
  final Widget child;

  const OnePageCard({Key key, this.child}) : super(key: key);

  static const int alpha = 12;
  static num breakpoint = FluffyThemes.columnWidth * 2;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width <= breakpoint ||
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
              padding: EdgeInsets.symmetric(
                horizontal:
                    max((MediaQuery.of(context).size.width - 600) / 2, 24),
                vertical:
                    max((MediaQuery.of(context).size.height - 800) / 2, 24),
              ),
              child: SafeArea(child: Card(elevation: 5, child: child)),
            ),
          );
  }
}
