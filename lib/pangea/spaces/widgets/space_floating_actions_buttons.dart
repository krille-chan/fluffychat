import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

class SpaceFloatingActionButtons extends StatelessWidget {
  const SpaceFloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          FloatingActionButton.extended(
            onPressed: () => SpaceCodeUtil.joinWithSpaceCodeDialog(context),
            icon: const Icon(Icons.join_right_outlined),
            label: Text(
              L10n.of(context).join,
              overflow: TextOverflow.fade,
            ),
          ),
          FloatingActionButton.extended(
            onPressed: () => context.go('/rooms/newspace'),
            icon: const Icon(Icons.add),
            label: Text(
              L10n.of(context).space,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
