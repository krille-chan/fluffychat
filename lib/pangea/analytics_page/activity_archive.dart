import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_page/activity_archive_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityArchive extends StatefulWidget {
  const ActivityArchive({super.key});

  @override
  ActivityArchiveState createState() => ActivityArchiveState();
}

class ActivityArchiveState extends State<ActivityArchive> {
  List<Room> get archive =>
      MatrixState.pangeaController.getAnalytics.archivedActivities;

  Future<void> removeArchivedChat(Room room) async {
    await room.leave();
    await MatrixState.pangeaController.putAnalytics
        .removeActivityAnalytics(room.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => ActivityArchiveView(controller: this);
}
