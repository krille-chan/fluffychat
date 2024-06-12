import 'dart:developer';

import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_acitivity_record_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

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
    if (event.type != PangeaEventTypes.pangeaActivityRes) {
      throw Exception(
        "${event.type} should not be used to make a PracticeActivityEvent",
      );
    }
  }

  PracticeActivityModel get practiceActivity {
    _content ??= event.getPangeaContent<PracticeActivityModel>();
    return _content!;
  }

  //in aggregatedEvents for the event, find all practiceActivityRecordEvents whose sender matches the client's userId
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

  List<PracticeActivityRecordEvent> get userRecords => allRecords
      .where(
        (recordEvent) =>
            recordEvent.event.senderId == recordEvent.event.room.client.userID,
      )
      .toList();

  /// Checks if there are any user records in the list for this activity,
  /// and, if so, then the activity is complete
  bool get isComplete => userRecords.isNotEmpty;
}
