import 'package:fluffychat/pages/views/empty_page_view.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).loginState != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => VRouter.of(context).to(
          Matrix.of(context).loginState == LoginState.logged
              ? '/rooms'
              : '/home',
          queryParameters: VRouter.of(context).queryParameters,
        ),
      );
    }
    return EmptyPage(loading: true);
  }
}
