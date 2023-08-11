import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class SideViewLayout extends StatelessWidget {
  final Widget mainView;
  final Widget? sideView;

  const SideViewLayout({Key? key, required this.mainView, this.sideView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sideView = this.sideView;
    final hideSideView =
        !FluffyThemes.isThreeColumnMode(context) || sideView == null;
    const sideViewWidth = 360.0;
    return Stack(
      children: [
        AnimatedPositioned(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          top: 0,
          left: 0,
          bottom: 0,
          right: hideSideView ? 0 : sideViewWidth,
          child: ClipRRect(child: mainView),
        ),
        AnimatedPositioned(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          bottom: 0,
          top: 0,
          right: 0,
          left: !FluffyThemes.isThreeColumnMode(context) && sideView != null
              ? 0
              : null,
          width: sideView == null
              ? 0
              : !FluffyThemes.isThreeColumnMode(context)
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
