import 'package:fluffychat/pages/views/empty_page_view.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context)
        .widget
        .clients
        .every((client) => client.loginState != null)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => VRouter.of(context).to(
          Matrix.of(context)
                  .widget
                  .clients
                  .any((client) => client.loginState == LoginState.loggedIn)
              ? '/rooms'
              : '/home',
          queryParameters: VRouter.of(context).queryParameters,
        ),
      );
    }
    return EmptyPage(loading: true);
  }
}
