import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  // #Pangea
  final Color? dividerColor;
  // Pangea#

  const TwoColumnLayout({
    super.key,
    required this.mainView,
    required this.sideView,
    // #Pangea
    this.dividerColor,
    // Pangea#
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaffoldMessenger(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              width: FluffyThemes.columnWidth + FluffyThemes.navRailWidth,
              child: mainView,
            ),
            Container(
              width: 1.0,
              // #Pangea
              // color: theme.dividerColor,
              color: dividerColor ?? theme.dividerColor,
              // Pangea#
            ),
            Expanded(
              child: ClipRRect(
                child: sideView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
