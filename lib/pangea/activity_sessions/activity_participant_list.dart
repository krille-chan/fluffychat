import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ActivityParticipantList extends StatelessWidget {
  final Room room;
  final Function(String)? onTap;

  final bool Function(String)? canSelect;
  final bool Function(String)? isSelected;
  final double Function(ActivityRoleModel?)? getOpacity;

  const ActivityParticipantList({
    super.key,
    required this.room,
    this.onTap,
    this.canSelect,
    this.isSelected,
    this.getOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final availableRoles = room.activityPlan!.roles;
    final assignedRoles = room.assignedRoles ?? {};

    final remainingMembers = room.getParticipants().where(
          (p) => !assignedRoles.values.any((r) => r.userId == p.id),
        );

    return Column(
      spacing: 12.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.0,
          runSpacing: 12.0,
          children: availableRoles.values.map((availableRole) {
            final assignedRole = assignedRoles[availableRole.id];
            final user = room.getParticipants().firstWhereOrNull(
                  (u) => u.id == assignedRole?.userId,
                );

            final selectable =
                canSelect != null ? canSelect!(availableRole.id) : true;

            return ActivityParticipantIndicator(
              availableRole: availableRole,
              assignedRole: assignedRole,
              opacity: getOpacity != null ? getOpacity!(assignedRole) : 1.0,
              avatarUrl: availableRole.avatarUrl ?? user?.avatarUrl?.toString(),
              onTap: onTap != null && selectable
                  ? () => onTap!(availableRole.id)
                  : null,
              selected:
                  isSelected != null ? isSelected!(availableRole.id) : false,
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
    );
  }
}
