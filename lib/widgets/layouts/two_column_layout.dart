import 'package:flutter/material.dart';

import '../../config/themes.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;

  const TwoColumnLayout({
    Key? key,
    required this.mainView,
    required this.sideView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listenable = FluffyThemes.getDisplayNavigationRail(context);
    return ScaffoldMessenger(
      child: Scaffold(
        body: Row(
          children: [
            // otherwise, we'd have an ugly animation where we don't want any...
            listenable == null
                ? _FirstColumnChild(child: mainView)
                : ValueListenableBuilder<bool>(
                    valueListenable: listenable,
                    child: mainView,
                    builder: (context, open, child) =>
                        LayoutBuilder(builder: (context, constraints) {
                      final width = open &&
                              MediaQuery.of(context).size.width >
                                  FluffyThemes.hugeScreenBreakpoint
                          ? 256.0
                          : 64.0;
                      return _FirstColumnChild(
                        drawerWidth: width,
                        child: child,
                      );
                    }),
                  ),
            Container(
              width: 1.0,
              color: Theme.of(context).dividerColor,
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

class _FirstColumnChild extends StatelessWidget {
  final Widget? child;
  final double drawerWidth;

  const _FirstColumnChild({Key? key, required this.child, this.drawerWidth = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      width: 360.0 + drawerWidth,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
