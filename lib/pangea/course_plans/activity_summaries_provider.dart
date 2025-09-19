import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';

mixin ActivitySummariesProvider<T extends StatefulWidget> on State<T> {
  Map<String, RoomSummaryResponse>? roomSummaries;

  Future<void> loadRoomSummaries(List<String> roomIds) async {
    if (roomIds.isEmpty) {
      roomSummaries = {};
      return;
    }

    try {
      final resp =
          await Matrix.of(context).client.requestRoomSummaries(roomIds);

      if (mounted) {
        setState(() => roomSummaries = resp.summaries);
      }
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s, data: {'roomIds': roomIds});
    }
  }

  Set<String> openSessions(String activityId) {
    if (roomSummaries == null || roomSummaries!.isEmpty) return {};
    final Set<String> sessions = {};

    for (final entry in roomSummaries!.entries) {
      final summary = entry.value;
      final roomId = entry.key;

      if (summary.activityPlan.activityId != activityId) {
        continue;
      }

      final isOpen = summary.activityRoles.roles.length <
          summary.activityPlan.req.numberOfParticipants;

      if (isOpen) {
        sessions.add(roomId);
      }
    }
    return sessions;
  }

  int numOpenSessions(String activityId) => openSessions(activityId).length;
}
