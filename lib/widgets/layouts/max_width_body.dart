import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class MaxWidthBody extends StatelessWidget {
  final Widget? child;
  final double maxWidth;
  final bool withFrame;
  final bool withScrolling;
  final EdgeInsets? innerPadding;

  const MaxWidthBody({
    this.child,
    this.maxWidth = 600,
    this.withFrame = true,
    this.withScrolling = true,
    this.innerPadding,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final paddingVal = max(0, (constraints.maxWidth - maxWidth) / 2);
          final hasPadding = paddingVal > 0;
          final padding = EdgeInsets.symmetric(
            vertical: hasPadding ? 32 : 0,
            horizontal: max(0, (constraints.maxWidth - maxWidth) / 2),
          );
          final childWithPadding = Padding(
            padding: padding,
            child: withFrame && hasPadding
                ? Material(
                    elevation:
                        Theme.of(context).appBarTheme.scrolledUnderElevation ??
                            4,
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    shadowColor: Theme.of(context).appBarTheme.shadowColor,
                    child: child,
                  )
                : child,
          );
          if (!withScrolling) {
            return Padding(
              padding: innerPadding ?? EdgeInsets.zero,
              child: childWithPadding,
            );
          }
          return SingleChildScrollView(
            padding: innerPadding,
            physics: const ScrollPhysics(),
            child: childWithPadding,
          );
        },
      ),
    );
  }
}
