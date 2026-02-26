import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/themes.dart';

class ActivityCardPlaceholder extends StatelessWidget {
  final int activityCount;

  const ActivityCardPlaceholder({super.key, required this.activityCount});

  @override
  Widget build(BuildContext context) {
    final int shimmerCount = activityCount;
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return SizedBox(
      height: isColumnMode ? 290.0 : 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shimmerCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Shimmer.fromColors(
              baseColor: theme.colorScheme.primary.withAlpha(20),
              highlightColor: theme.colorScheme.primary.withAlpha(50),
              child: Container(
                width: isColumnMode ? 160.0 : 120.0,
                height: isColumnMode ? 280.0 : 200.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
