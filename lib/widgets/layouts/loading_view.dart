import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).loginState != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.vRouter.push(
          Matrix.of(context).loginState == LoginState.logged
              ? '/rooms'
              : '/home'));
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
