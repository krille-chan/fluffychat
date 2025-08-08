import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_finished_status_message.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_unfinished_status_message.dart';

class ActivityStatusMessage extends StatelessWidget {
  final Room room;

  const ActivityStatusMessage({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    if (!room.showActivityChatUI) {
      return const SizedBox.shrink();
    }

    return Material(
      child: AnimatedSize(
        duration: FluffyThemes.animationDuration,
        child: room.isInactiveInActivity
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: FluffyThemes.isColumnMode(context) ? 32.0 : 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: SingleChildScrollView(
                    child: room.activityIsFinished
                        ? ActivityFinishedStatusMessage(room: room)
                        : ActivityUnfinishedStatusMessage(room: room),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
