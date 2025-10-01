import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import '../../widgets/avatar.dart';

class ActivityArchive extends StatelessWidget {
  final String? selectedRoomId;
  const ActivityArchive({
    super.key,
    this.selectedRoomId,
  });

  List<Room> get archive =>
      MatrixState.pangeaController.getAnalytics.archivedActivities;

  @override
  Widget build(BuildContext context) {
    return MaxWidthBody(
      withScrolling: false,
      child: ListView.builder(
        itemCount: archive.length + 1,
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) {
            return const InstructionsInlineTooltip(
              instructionsEnum: InstructionsEnum.activityAnalyticsList,
              padding: EdgeInsets.all(8.0),
            );
          }
          i--;
          return AnalyticsActivityItem(
            room: archive[i],
            selected: archive[i].id == selectedRoomId,
          );
        },
      ),
    );
  }
}

class AnalyticsActivityItem extends StatelessWidget {
  final Room room;
  final bool selected;
  const AnalyticsActivityItem({
    super.key,
    required this.room,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final objective = room.activityPlan?.learningObjective ?? '';
    final cefrLevel = room.activitySummary?.summary?.participants
        .firstWhereOrNull(
          (p) => p.participantId == room.client.userID,
        )
        ?.cefrLevel;

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        color: selected ? theme.colorScheme.secondaryContainer : null,
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
