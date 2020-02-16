import 'package:flutter/material.dart';

enum FocusPage { FIRST, SECOND }

class AdaptivePageLayout extends StatelessWidget {
  final Widget firstScaffold;
  final Widget secondScaffold;
  final FocusPage primaryPage;
  final double minWidth;

  static const double defaultMinWidth = 400;
  static bool columnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > 2 * defaultMinWidth;

  AdaptivePageLayout(
      {this.firstScaffold,
      this.secondScaffold,
      this.primaryPage = FocusPage.FIRST,
      this.minWidth = defaultMinWidth,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait || !columnMode(context)) {
        if (primaryPage == FocusPage.FIRST) {
          return firstScaffold;
        } else {
          return secondScaffold;
        }
      }
      return Row(
        children: <Widget>[
          Container(
            width: minWidth,
            child: firstScaffold,
          ),
          Container(
            width: 1,
            color: Theme.of(context).secondaryHeaderColor, //Color(0xFFE8E8E8),
          ),
          Expanded(
            child: Container(
              child: secondScaffold,
            ),
          )
        ],
      );
    });
  }
}
