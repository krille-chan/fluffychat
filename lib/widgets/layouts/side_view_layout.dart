import 'package:flutter/material.dart';

import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/themes.dart';

class SideViewLayout extends StatelessWidget {
  final Widget mainView;
  final Widget? sideView;

  const SideViewLayout({Key? key, required this.mainView, this.sideView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var currentUrl = Uri.decodeFull(VRouter.of(context).url);
    if (!currentUrl.endsWith('/')) currentUrl += '/';
    final hideSideView = currentUrl.split('/').length == 4;
    final sideView = this.sideView;
    return sideView == null
        ? mainView
        : MediaQuery.of(context).size.width < FluffyThemes.columnWidth * 3.5 &&
                !hideSideView
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
