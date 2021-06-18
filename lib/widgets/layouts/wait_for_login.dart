import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart';

import '../matrix.dart';

class WaitForInitPage extends StatelessWidget {
  final Widget page;
  const WaitForInitPage(this.page, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).loginState == null) {
      return StreamBuilder<LoginState>(
          stream: Matrix.of(context).client.onLoginStateChanged.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return page;
          });
    }
    return page;
  }
}
