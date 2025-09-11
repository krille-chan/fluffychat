import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import '../../widgets/avatar.dart';

class ActivityArchive extends StatelessWidget {
  const ActivityArchive({super.key});

  List<Room> get archive =>
      MatrixState.pangeaController.getAnalytics.archivedActivities;

  @override
  Widget build(BuildContext context) {
    return MaxWidthBody(
      withScrolling: false,
      child: Builder(
        builder: (BuildContext context) {
          if (archive.isEmpty) {
            return const Center(
              child: Icon(Icons.archive_outlined, size: 80),
            );
          }
          return ListView.builder(
            itemCount: archive.length,
            itemBuilder: (BuildContext context, int i) => AnalyticsActivityItem(
              room: archive[i],
            ),
          );
        },
      ),
    );
  }
}

class AnalyticsActivityItem extends StatelessWidget {
  final Room room;
  const AnalyticsActivityItem({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    final objective = room.activityPlan?.learningObjective ?? '';
    final cefrLevel = room.activitySummary?.summary?.participants
        .firstWhereOrNull(
          (p) => p.participantId == room.client.userID,
        )
        ?.cefrLevel;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -0.5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: HoverBuilder(
            builder: (context, hovered) => AnimatedScale(
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              scale: hovered ? 1.1 : 1.0,
              child: Avatar(
                borderRadius: BorderRadius.circular(4.0),
                mxContent: room.avatar,
                name: room.getLocalizedDisplayname(),
              ),
            ),
          ),
          title: Text(
            objective,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.0),
          ),
          trailing: cefrLevel != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    cefrLevel.toUpperCase(),
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              : null,
          onTap: () => context.go(
            '/rooms/analytics/activities/${room.id}',
          ),
        ),
      ),
    );
  }
}
