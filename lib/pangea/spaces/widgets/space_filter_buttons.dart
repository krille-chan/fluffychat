import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

class SpaceFilterButtons extends StatelessWidget {
  const SpaceFilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: SizedBox(
                width: 100.0,
                child: FloatingActionButton.extended(
                  onPressed: () =>
                      SpaceCodeUtil.joinWithSpaceCodeDialog(context),
                  icon: const Icon(Icons.join_right_outlined),
                  label: Text(
                    L10n.of(context).join,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: SizedBox(
                width: 100.0,
                child: FloatingActionButton.extended(
                  onPressed: () => context.go('/rooms/newspace'),
                  icon: const Icon(Icons.add),
                  label: Text(
                    L10n.of(context).space,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
