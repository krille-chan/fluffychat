import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class ActivityParticipantList extends StatelessWidget {
  final ActivityPlanModel activity;
  final Room? room;
  final Room? course;
  final Function(String)? onTap;

  final bool Function(String)? canSelect;
  final bool Function(String)? isSelected;
  final double Function(ActivityRoleModel?)? getOpacity;

  const ActivityParticipantList({
    super.key,
    required this.activity,
    this.room,
    this.course,
    this.onTap,
    this.canSelect,
    this.isSelected,
    this.getOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return LoadParticipantsBuilder(
      room: room,
      builder: (context, participants) {
        final theme = Theme.of(context);
        final availableRoles = activity.roles;
        final assignedRoles = room?.assignedRoles ?? {};

        final remainingMembers = participants.participants.where(
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
                final selected =
                    isSelected != null ? isSelected!(availableRole.id) : false;

                final assignedRole = assignedRoles[availableRole.id] ??
                    (selected
                        ? ActivityRoleModel(
                            id: availableRole.id,
                            userId: Matrix.of(context).client.userID!,
                            role: availableRole.name,
                          )
                        : null);

                final User? user = participants.participants.firstWhereOrNull(
                      (u) => u.id == assignedRole?.userId,
                    ) ??
                    course?.getParticipants().firstWhereOrNull(
                          (u) => u.id == assignedRole?.userId,
                        );

                final selectable =
                    canSelect != null ? canSelect!(availableRole.id) : true;

                return ActivityParticipantIndicator(
                  name: availableRole.name,
                  userId: assignedRole?.userId,
                  opacity: getOpacity != null ? getOpacity!(assignedRole) : 1.0,
                  user: user,
                  onTap: onTap != null && selectable
                      ? () => onTap!(availableRole.id)
                      : null,
                  selected: selected,
                  selectable: selectable,
                );
              }).toList(),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: remainingMembers.map((member) {
                return InkWell(
                  onTap: () => showMemberActionsPopupMenu(
                    context: context,
                    user: member,
                  ),
                  child: Container(
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
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
