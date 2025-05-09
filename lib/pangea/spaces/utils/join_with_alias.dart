import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import 'package:fluffychat/widgets/matrix.dart';

class JoinWithAlias extends StatefulWidget {
  final String? alias;
  const JoinWithAlias({super.key, this.alias});

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
    if (widget.alias == null || widget.alias!.isEmpty) {
      context.go("/rooms");
      return;
    }

    await MatrixState.pangeaController.classController.joinCachedRoomAlias(
      widget.alias!,
      context,
    );
  }

  @override
  Widget build(BuildContext context) => const EmptyPage();
}
