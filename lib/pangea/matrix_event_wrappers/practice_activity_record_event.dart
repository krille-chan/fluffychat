import 'dart:developer';

import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

class PracticeActivityRecordEvent {
  Event event;

  PracticeActivityRecordModel? _content;

  PracticeActivityRecordEvent({required this.event}) {
    if (event.type != PangeaEventTypes.activityRecord) {
      throw Exception(
        "${event.type} should not be used to make a PracticeActivityRecordEvent",
      );
    }
  }

  PracticeActivityRecordModel get record {
    _content ??= event.getPangeaContent<PracticeActivityRecordModel>();
    return _content!;
  }

  Future<List<OneConstructUse>> uses(Timeline timeline) async {
    try {
      final String? parent = event.relationshipEventId;
      if (parent == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "PracticeActivityRecordEvent has null event.relationshipEventId",
          data: event.toJson(),
        );
        return [];
      }

      final Event? practiceEvent =
          await timeline.getEventById(event.relationshipEventId!);

      if (practiceEvent == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "PracticeActivityRecordEvent has null practiceActivityEvent with id $parent",
          data: event.toJson(),
        );
        return [];
      }

      final PracticeActivityEvent practiceActivity = PracticeActivityEvent(
        event: practiceEvent,
        timeline: timeline,
      );

      final List<OneConstructUse> uses = [];

      final List<ConstructIdentifier> constructIds =
          practiceActivity.practiceActivity.tgtConstructs;

      for (final construct in constructIds) {
        uses.add(
          OneConstructUse(
            lemma: construct.lemma,
            constructType: construct.type,
            useType: record.useType,
            //TODO - find form of construct within the message
            //this is related to the feature of highlighting the target construct in the message
            form: construct.lemma,
            chatId: event.roomId ?? practiceEvent.roomId ?? timeline.room.id,
            msgId: practiceActivity.parentMessageId,
            timeStamp: event.originServerTs,
          ),
        );
      }

      return uses;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: event.toJson());
      rethrow;
    }
  }
}
