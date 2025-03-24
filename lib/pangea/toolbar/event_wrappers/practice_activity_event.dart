import 'dart:developer';

import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/event_wrappers/practice_activity_record_event.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../../events/constants/pangea_event_types.dart';

class PracticeActivityEvent {
  Event event;
  Timeline? timeline;
  PracticeActivityModel? _content;

  PracticeActivityEvent({
    required this.event,
    required this.timeline,
    content,
  }) {
    if (content != null) {
      if (!kDebugMode) {
        throw Exception(
          "content should not be set on product, just a dev placeholder",
        );
      } else {
        _content = content;
      }
    }
    if (event.type != PangeaEventTypes.pangeaActivity) {
      throw Exception(
        "${event.type} should not be used to make a PracticeActivityEvent",
      );
    }
  }

  PracticeActivityModel get practiceActivity {
    _content ??= event.getPangeaContent<PracticeActivityModel>();
    return _content!;
  }

  /// All completion records assosiated with this activity
  List<PracticeActivityRecordEvent> get allRecords {
    if (timeline == null) {
      debugger(when: kDebugMode);
      return [];
    }
    final List<Event> records = event
        .aggregatedEvents(timeline!, PangeaEventTypes.activityRecord)
        .toList();

    return records
        .map((event) => PracticeActivityRecordEvent(event: event))
        .toList();
  }

  /// Completion record assosiated with this activity
  /// for the logged in user, null if there is none
  // List<PracticeActivityRecordEvent> get allUserRecords => allRecords
  //     .where(
  //       (recordEvent) =>
  //           recordEvent.event.senderId == recordEvent.event.room.client.userID,
  //     )
  //     .toList();

  /// Get the most recent user record for this activity
  // PracticeActivityRecordEvent? get latestUserRecord {
  //   final List<PracticeActivityRecordEvent> userRecords = allUserRecords;
  //   if (userRecords.isEmpty) return null;
  //   return userRecords.reduce(
  //     (a, b) => a.event.originServerTs.isAfter(b.event.originServerTs) ? a : b,
  //   );
  // }

  // DateTime? get lastCompletedAt => latestUserRecord?.event.originServerTs;

  String get parentMessageId => event.relationshipEventId!;
}
