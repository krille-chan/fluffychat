import 'dart:math';

import 'package:flutter/material.dart';

class OnePageCard extends StatelessWidget {
  final Widget child;

  const OnePageCard({Key key, this.child}) : super(key: key);

  static const int alpha = 64;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        horizontal: max((MediaQuery.of(context).size.width - 600) / 2, 0),
        vertical: max((MediaQuery.of(context).size.height - 800) / 2, 0),
      ),
      child: Card(child: child),
    );
  }
}
