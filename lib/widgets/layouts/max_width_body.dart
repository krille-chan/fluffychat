import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

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

          const desiredWidth = FluffyThemes.columnWidth * 1.5;
          final body = constraints.maxWidth <= desiredWidth
              ? child
              : Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: FluffyThemes.columnWidth * 1.5,
                    ),
                    child: Material(
                      elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
                      clipBehavior: Clip.hardEdge,
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      shadowColor: theme.appBarTheme.shadowColor,
                      child: child,
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
