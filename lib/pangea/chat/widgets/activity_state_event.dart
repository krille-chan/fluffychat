import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/events/state_message.dart';
import 'package:fluffychat/pangea/activity_planner/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_room_extension.dart';

class ActivityStateEvent extends StatelessWidget {
  final Event event;
  const ActivityStateEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    try {
      final activity = ActivityPlanModel.fromJson(event.content);
      final roles = event.room.activityRoles;

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Column(
          spacing: 12.0,
          children: [
            Text(activity.markdown),
            if (roles.isNotEmpty)
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: event.room.activityRoles.map((role) {
                  return ActivityParticipantIndicator(
                    role: role,
                    displayname: role.userId.localpart,
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
