// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension SeenByExtension on Timeline {
  /// Maps the event ID of every visible event to the users whose read receipt
  /// belongs to it.
  ///
  /// A receipt can point to an event which is not shown in the chat (reaction,
  /// edit, hidden state event, ...). Such a receipt is attributed to the
  /// nearest visible event at or before it. Every user appears only once, at
  /// the newest event they have read. Global, main thread and (if [threadId]
  /// is set) that thread's receipts are taken into account.
  Map<String, List<User>> seenByVisibleEvents(
    List<Event> visibleEvents, {
    String? threadId,
  }) {
    final raw = events; // newest first
    final visibleIds = visibleEvents.map((e) => e.eventId).toSet();
    final indexById = <String, int>{
      for (var i = 0; i < raw.length; i++) raw[i].eventId: i,
    };

    // For every raw index: nearest visible event at the same or an older position.
    final anchor = List<String?>.filled(raw.length, null);
    String? current;
    for (var i = raw.length - 1; i >= 0; i--) {
      if (visibleIds.contains(raw[i].eventId)) current = raw[i].eventId;
      anchor[i] = current;
    }

    // Newest known receipt position per user.
    final state = room.receiptState;
    final newestIndex = <String, int>{};
    void consider(LatestReceiptStateForTimeline? t) {
      t?.otherUsers.forEach((userId, data) {
        final index = indexById[data.eventId];
        if (index == null) return; // outside of the loaded timeline
        final known = newestIndex[userId];
        if (known == null || index < known) newestIndex[userId] = index;
      });
    }

    consider(state.global);
    consider(threadId == null ? state.mainThread : state.byThread[threadId]);

    final senders = {for (final e in raw) e.eventId: e.senderId};
    final result = <String, List<User>>{};
    newestIndex.forEach((userId, index) {
      final eventId = anchor[index];
      if (eventId == null) return;
      if (userId == room.client.userID || userId == senders[eventId]) return;
      (result[eventId] ??= []).add(
        room.unsafeGetUserFromMemoryOrFallback(userId),
      );
    });
    return result;
  }
}
