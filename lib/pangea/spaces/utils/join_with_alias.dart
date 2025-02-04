import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import 'package:fluffychat/widgets/matrix.dart';

class JoinWithAlias extends StatefulWidget {
  const JoinWithAlias({super.key});

  @override
  State<JoinWithAlias> createState() => _JoinWithAliasState();
}

class _JoinWithAliasState extends State<JoinWithAlias> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showFutureLoadingDialog(
        context: context,
        future: () async => _joinRoom(),
      ),
    );
  }

  Future<void> _joinRoom() async {
    final String? alias =
        GoRouterState.of(context).uri.queryParameters['alias'];

    if (alias == null || alias.isEmpty) {
      context.go("/rooms");
      return;
    }

    await MatrixState.pangeaController.classController.joinCachedRoomAlias(
      alias,
      context,
    );
  }

  @override
  Widget build(BuildContext context) => const EmptyPage();
}
