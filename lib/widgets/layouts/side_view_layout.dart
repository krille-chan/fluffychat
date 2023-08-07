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
    return sideView == null
        ? mainView
        : hideSideView
            ? sideView
            : Row(
                children: [
                  Expanded(
                    child: ClipRRect(child: mainView),
                  ),
                  Container(
                    width: 1.0,
                    color: Theme.of(context).dividerColor,
                  ),
                  AnimatedContainer(
                    duration: FluffyThemes.animationDuration,
                    curve: FluffyThemes.animationCurve,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    width: hideSideView ? 0 : 360.0,
                    child: hideSideView ? null : sideView,
                  ),
                ],
              );
  }
}
