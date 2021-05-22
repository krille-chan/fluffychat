import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).loginState != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          AdaptivePageLayout.of(context).pushNamedAndRemoveAllOthers('/'));
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
