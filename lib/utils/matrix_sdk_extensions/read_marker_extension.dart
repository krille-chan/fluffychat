// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:collection/collection.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:matrix/matrix.dart';

extension ReadMarkerTimelineExtension on Timeline {
  /// Marks the timeline as read up to [eventId] or completely if [eventId] is
  /// null.
  ///
  /// The read receipt is also moved over hidden events which directly follow,
  /// like reactions. The server counts encrypted reactions as notifications,
  /// because it can not see that they are reactions. So if the read receipt
  /// stays on the last visible message, the room would stay unread forever.
  /// The fully read marker stays on a visible event, because it is used to
  /// display the "new messages" divider.
  Future<void> markAsRead({String? eventId}) async {
    final syncedEvents = events
        .where((event) => event.status.isSynced)
        .toList();

    final String fullyReadEventId;
    var receiptEventId = eventId;

    if (eventId == null) {
      final latestEventId = syncedEvents.firstOrNull?.eventId;
      if (latestEventId == null) return;
      receiptEventId = latestEventId;
      fullyReadEventId =
          syncedEvents.filterByVisibleInGui().firstOrNull?.eventId ??
          latestEventId;
    } else {
      fullyReadEventId = eventId;
      final index = syncedEvents.indexWhere((e) => e.eventId == eventId);
      for (var i = index - 1; i >= 0; i--) {
        if (syncedEvents[i].isVisibleInGui) break;
        receiptEventId = syncedEvents[i].eventId;
      }
    }

    await room.setReadMarker(
      fullyReadEventId,
      mRead: receiptEventId,
      public: AppSettings.sendPublicReadReceipts.value,
    );
  }
}

extension MarkAsReadRoomExtension on Room {
  /// Marks the room as read without an open timeline. See
  /// [ReadMarkerTimelineExtension.markAsRead].
  Future<void> markAsRead({String? eventId}) async {
    final timeline = await getTimeline();
    try {
      await timeline.markAsRead(eventId: eventId);
    } finally {
      timeline.cancelSubscriptions();
    }
    if (markedUnread) await markUnread(false);
  }
}
