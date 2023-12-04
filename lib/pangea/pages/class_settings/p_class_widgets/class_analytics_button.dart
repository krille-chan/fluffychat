import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class ClassAnalyticsButton extends StatelessWidget {
  const ClassAnalyticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = GoRouterState.of(context).pathParameters['roomid'];
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Column(
      children: [
        ListTile(
          title: Text(
            L10n.of(context)!.classAnalytics,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(L10n.of(context)!.classAnalyticsDesc),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.analytics_outlined),
          ),
          onTap: () => context.go('/rooms/analytics/$roomId'),
        ),
      ],
    );
  }
}
