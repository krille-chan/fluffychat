import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

/// Represents an item in the completion cache.
class _RecordCacheItem {
  PracticeActivityRecordModel data;

  Future<Event?> recordEvent;

  _RecordCacheItem({required this.data, required this.recordEvent});
}

/// Controller for handling activity completions.
class PracticeActivityRecordController {
  static final Map<int, _RecordCacheItem> _cache = {};
  late final PangeaController _pangeaController;
  Timer? _cacheClearTimer;

  PracticeActivityRecordController(this._pangeaController) {
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 2);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  /// Sends a practice activity record to the server and returns the corresponding event.
  ///
  /// The [recordModel] parameter is the model representing the practice activity record.
  /// The [practiceActivityEvent] parameter is the event associated with the practice activity.
  /// Note that the system will send a new event if the model has changed in any way ie it is
  /// a new completion of the practice activity. However, it will cache previous sends to ensure
  /// that opening and closing of the widget does not result in multiple sends of the same data.
  /// It allows checks the data to make sure that it contains responses to the practice activity
  /// and does not represent a blank record with no actual completion to be saved.
  ///
  /// Returns a [Future] that completes with the corresponding [Event] object.
  Future<Event?> send(
    PracticeActivityRecordModel recordModel,
    PracticeActivityEvent practiceActivityEvent,
  ) async {
    final int cacheKey = recordModel.hashCode;

    if (recordModel.responses.isEmpty) {
      return null;
    }

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.recordEvent;
    } else {
      final Future<Event?> eventFuture = practiceActivityEvent.event.room
          .sendPangeaEvent(
        content: recordModel.toJson(),
        parentEventId: practiceActivityEvent.event.eventId,
        type: PangeaEventTypes.activityRecord,
      )
          .catchError((e) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: e,
          s: StackTrace.current,
          data: {
            'recordModel': recordModel.toJson(),
            'practiceActivityEvent': practiceActivityEvent.event.toJson(),
          },
        );
        return null;
      });

      _cache[cacheKey] =
          _RecordCacheItem(data: recordModel, recordEvent: eventFuture);

      return _cache[cacheKey]!.recordEvent;
    }
  }
}
