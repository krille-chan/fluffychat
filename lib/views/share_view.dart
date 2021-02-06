import 'dart:async';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'home_view_parts/chat_list.dart';

class ShareView extends StatelessWidget {
  final StreamController<int> _onAppBarButtonTap =
      StreamController<int>.broadcast();
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
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () => _onAppBarButtonTap.add(1),
          ),
        ],
      ),
      body: ChatList(onAppBarButtonTap: _onAppBarButtonTap.stream),
    );
  }
}
