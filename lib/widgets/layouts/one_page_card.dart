import 'dart:math';

import 'package:flutter/material.dart';

class OnePageCard extends StatelessWidget {
  final Widget child;

  const OnePageCard({Key key, this.child}) : super(key: key);

  static const int alpha = 12;
  static const int breakpoint = 600;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width <= breakpoint ||
            MediaQuery.of(context).size.height <= breakpoint
        ? child
        : Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9,
                ],
                colors: [
                  Theme.of(context).secondaryHeaderColor.withAlpha(alpha),
                  Theme.of(context).primaryColor.withAlpha(alpha),
                  Theme.of(context).accentColor.withAlpha(alpha),
                  Theme.of(context).backgroundColor.withAlpha(alpha),
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 12),
              vertical: max((MediaQuery.of(context).size.height - 800) / 2, 12),
            ),
            child: SafeArea(child: Card(child: child)),
          );
  }
}
