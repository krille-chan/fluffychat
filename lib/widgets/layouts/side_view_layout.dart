import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class SideViewLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool hideSideView;

  const SideViewLayout({
    Key? key,
    required this.mainView,
    required this.sideView,
    required this.hideSideView,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sideView = this.sideView;
    const sideViewWidth = 360.0;
    final threeColumnMode = FluffyThemes.isThreeColumnMode(context);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          top: 0,
          left: 0,
          bottom: 0,
          right: !threeColumnMode || hideSideView ? 0 : sideViewWidth,
          child: ClipRRect(child: mainView),
        ),
        AnimatedPositioned(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          bottom: 0,
          top: 0,
          right: 0,
          left: !threeColumnMode && !hideSideView ? 0 : null,
          width: hideSideView
              ? 0
              : !threeColumnMode
                  ? null
                  : sideViewWidth,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: sideView,
          ),
        ),
      ],
    );
  }
}
