import 'package:flutter/material.dart';

import 'package:hermes/config/app_config.dart';
import 'package:hermes/config/themes.dart';

class MaxWidthBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool withScrolling;
  final EdgeInsets? innerPadding;

  const MaxWidthBody({
    required this.child,
    this.maxWidth = 600,
    this.withScrolling = true,
    this.innerPadding,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final theme = Theme.of(context);

          const desiredWidth = PantheonThemes.columnWidth * 1.5;
          final body = constraints.maxWidth <= desiredWidth
              ? child
              : Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: PantheonThemes.columnWidth * 1.5,
                    ),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius),
                        side: BorderSide(
                          color: theme.dividerColor,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: child,
                      ),
                    ),
                  ),
                );
          if (!withScrolling) return body;

          return SingleChildScrollView(
            padding: innerPadding,
            physics: const ScrollPhysics(),
            child: body,
          );
        },
      ),
    );
  }
}
