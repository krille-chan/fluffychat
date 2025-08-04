import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_finished_status_message.dart';
import 'package:fluffychat/pangea/activity_planner/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_planner/activity_unfinished_status_message.dart';

class ActivityStatusMessage extends StatefulWidget {
  final Room room;

  const ActivityStatusMessage({
    super.key,
    required this.room,
  });

  @override
  ActivityStatusMessageState createState() => ActivityStatusMessageState();
}

class ActivityStatusMessageState extends State<ActivityStatusMessage> {
  @override
  void initState() {
    super.initState();

    if (widget.room.activityIsFinished && widget.room.activitySummary == null) {
      widget.room.fetchSummaries().then((_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedSize(
        duration: FluffyThemes.animationDuration,
        child: !widget.room.hasJoinedActivity || widget.room.activityIsFinished
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
                    child: widget.room.activityIsFinished
                        ? ActivityFinishedStatusMessage(room: widget.room)
                        : ActivityUnfinishedStatusMessage(room: widget.room),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
