import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';

class ActivityPlanPageLaunchIconButton extends StatelessWidget {
  const ActivityPlanPageLaunchIconButton({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.event_note_outlined),
      tooltip: L10n.of(context).activityPlannerTitle,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityPlannerPage(room: controller.room),
          ),
        );
      },
    );
  }
}
