import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/events/state_message.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ActivityStateEvent extends StatelessWidget {
  final Event event;
  const ActivityStateEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    if (event.room.activityPlan == null) {
      return const SizedBox();
    }

    try {
      final activity = ActivityPlanModel.fromJson(event.content);
      final availableRoles = event.room.activityPlan!.roles;
      final assignedRoles = event.room.activityRoles?.roles ?? {};

      final remainingMembers = event.room.getParticipants().where(
            (p) => !assignedRoles.values.any((r) => r.userId == p.id),
          );

      final theme = Theme.of(context);

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.maxTimelineWidth,
        ),
        child: Column(
          spacing: 12.0,
          children: [
            Text(
              activity.markdown,
              style: const TextStyle(fontSize: 14.0),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: availableRoles.values.map((availableRole) {
                final assignedRole = assignedRoles[availableRole.id];
                final user = event.room.getParticipants().firstWhereOrNull(
                      (u) => u.id == assignedRole?.userId,
                    );

                return ActivityParticipantIndicator(
                  availableRole: availableRole,
                  assignedRole: assignedRole,
                  opacity: assignedRole == null || assignedRole.isFinished
                      ? 0.5
                      : 1.0,
                  avatarUrl:
                      availableRole.avatarUrl ?? user?.avatarUrl?.toString(),
                );
              }).toList(),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: remainingMembers.map((member) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: Row(
                      spacing: 4.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Avatar(
                          size: 18.0,
                          mxContent: member.avatarUrl,
                          name: member.calcDisplayname(),
                          userId: member.id,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 80.0,
                          ),
                          child: Text(
                            member.calcDisplayname(),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    } catch (e) {
      return StateMessage(event);
    }
  }
}
