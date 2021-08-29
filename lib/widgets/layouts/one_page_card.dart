import 'dart:math';

import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

import '../background_gradient_box.dart';

class OnePageCard extends StatelessWidget {
  final Widget child;

  const OnePageCard({Key key, this.child}) : super(key: key);

  static const int alpha = 12;
  static num breakpoint = FluffyThemes.columnWidth * 2;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width <= breakpoint
        ? child
        : Material(
            color: Theme.of(context).backgroundColor,
            child: BackgroundGradientBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      max((MediaQuery.of(context).size.width - 600) / 2, 12),
                  vertical:
                      max((MediaQuery.of(context).size.height - 800) / 2, 12),
                ),
                child: SafeArea(child: Card(elevation: 3, child: child)),
              ),
            ),
          );
  }
}
