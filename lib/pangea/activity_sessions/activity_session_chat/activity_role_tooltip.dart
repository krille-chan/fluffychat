import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';

class ActivityRoleTooltip extends StatefulWidget {
  final Choreographer choreographer;

  const ActivityRoleTooltip({
    required this.choreographer,
    super.key,
  });

  @override
  State<ActivityRoleTooltip> createState() => ActivityRoleTooltipState();
}

class ActivityRoleTooltipState extends State<ActivityRoleTooltip> {
  Room get room => widget.choreographer.chatController.room;
  StreamSubscription? _choreoSub;

  @override
  void initState() {
    super.initState();
    _choreoSub = widget.choreographer.stateStream.stream.listen((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!room.showActivityChatUI ||
        room.ownRole?.goal == null ||
        widget.choreographer.itController.willOpen) {
      return const SizedBox();
    }

    return InlineTooltip(
      message: room.ownRole!.goal!,
      isClosed: room.hasDismissedGoalTooltip,
      onClose: () async {
        await room.dismissGoalTooltip();
        if (mounted) setState(() {});
      },
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
      ),
    );
  }
}
