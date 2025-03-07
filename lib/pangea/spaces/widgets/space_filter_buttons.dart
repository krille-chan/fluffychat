import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

class SpaceFilterButtons extends StatelessWidget {
  const SpaceFilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () => SpaceCodeUtil.joinWithSpaceCodeDialog(context),
              child: Row(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.join_right_outlined,
                    color: theme.colorScheme.onPrimary,
                  ),
                  Text(
                    L10n.of(context).joinByCode,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 2.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () => context.go('/rooms/newspace'),
              child: Row(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: theme.colorScheme.onPrimary,
                  ),
                  Text(
                    L10n.of(context).createASpace,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
