import 'package:flutter/material.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool displayNavigationRail;

  const TwoColumnLayout({
    Key? key,
    required this.mainView,
    required this.sideView,
    required this.displayNavigationRail,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              width: 360.0 + (displayNavigationRail ? 64 : 0),
              child: mainView,
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
