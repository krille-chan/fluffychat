import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;

  const TwoColumnLayout(
      {Key key, @required this.mainView, @required this.sideView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <= FluffyThemes.columnWidth * 2) {
      return mainView;
    }
    return ScaffoldMessenger(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              width: 360.0,
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
