import 'package:flutter/material.dart';

class BackgroundGradientBox extends StatelessWidget {
  final Widget child;
  const BackgroundGradientBox({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).secondaryHeaderColor,
          ],
        ),
      ),
      child: child,
    );
  }
}
