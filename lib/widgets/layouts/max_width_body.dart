import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

class MaxWidthBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool withScrolling;
  final EdgeInsets? innerPadding;
  // #Pangea
  final bool showBorder;
  // Pangea#

  const MaxWidthBody({
    required this.child,
    this.maxWidth = 600,
    this.withScrolling = true,
    this.innerPadding,
    // #Pangea
    this.showBorder = true,
    // Pangea#
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
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius),
                        side: BorderSide(
                          // #Pangea
                          // color: theme.dividerColor,
                          color: showBorder
                              ? theme.dividerColor
                              : Colors.transparent,
                          // Pangea#
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
