import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'home_view_parts/chat_list.dart';

class ShareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () {
            Matrix.of(context).shareContent = null;
            AdaptivePageLayout.of(context).pop();
          },
        ),
        title: Text(L10n.of(context).share),
      ),
      body: ChatList(),
    );
  }
}
