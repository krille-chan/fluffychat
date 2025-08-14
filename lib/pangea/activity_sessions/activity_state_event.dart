import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/events/state_message.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';

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
            if (event.room.ownRole != null ||
                event.room.remainingRoles == 0) ...[
              ActivityParticipantList(
                room: event.room,
                getOpacity: (role) =>
                    role == null || role.isFinished ? 0.5 : 1.0,
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      return StateMessage(event);
    }
  }
}
