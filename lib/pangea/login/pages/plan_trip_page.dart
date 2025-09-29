import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';

class PlanTripPage extends StatelessWidget {
  final String route;
  const PlanTripPage({
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined),
            Text(L10n.of(context).planTrip),
          ],
        ),
        automaticallyImplyLeading: route == 'registration',
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PangeaLogoSvg(
                  width: 100.0,
                  forceColor: theme.colorScheme.onSurface,
                ),
                Column(
                  spacing: 16.0,
                  children: [
                    Text(
                      L10n.of(context).howAreYouTraveling,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/private',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined),
                          Text(L10n.of(context).unlockPrivateTrip),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/public',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Symbols.map_search),
                          Text(L10n.of(context).joinPublicTrip),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/own',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_outlined),
                          Text(L10n.of(context).startOwnTrip),
                        ],
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: const Icon(Icons.school),
                      title: Text(
                        L10n.of(context).tripPlanDesc,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
