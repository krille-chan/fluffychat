import 'dart:math';

import 'package:flutter/material.dart';

class MaxWidthBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool withScrolling;

  const MaxWidthBody({
    this.child,
    this.maxWidth = 600,
    this.withScrolling = false,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = EdgeInsets.symmetric(
          horizontal: max(0, (constraints.maxWidth - maxWidth) / 2),
        );
        return withScrolling
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              )
            : Padding(
                padding: padding,
                child: child,
              );
      },
    );
  }
}
