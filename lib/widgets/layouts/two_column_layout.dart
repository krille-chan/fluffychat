import 'package:flutter/material.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool displayNavigationRail;

  const TwoColumnLayout({
    super.key,
    required this.mainView,
    required this.sideView,
    required this.displayNavigationRail,
  });
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              width: 360.0 + (displayNavigationRail ? 64 : 0),
              child: mainView,
            ),
            Expanded(
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                child: sideView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
