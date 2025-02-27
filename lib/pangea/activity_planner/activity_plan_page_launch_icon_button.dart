import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

class ActivityPlanPageLaunchIconButton extends StatelessWidget {
  const ActivityPlanPageLaunchIconButton({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.room.isBotDM) {
      return const SizedBox();
    }
    return IconButton(
      icon: const Icon(Icons.event_note_outlined),
      tooltip: L10n.of(context).activityPlannerTitle,
      onPressed: () {
        controller.stopAudioStream.add(null);
        context.go('/rooms/${controller.room.id}/planner');
      },
    );
  }
}
