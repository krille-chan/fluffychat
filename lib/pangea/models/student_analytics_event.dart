import 'dart:developer';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/extensions/client_extension.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';
import 'chart_analytics_model.dart';

class StudentAnalyticsEvent {
  late Event _event;
  StudentAnalyticsSummary? _contentCache;
  List<RecentMessageRecord> _messagesToSave = [];

  StudentAnalyticsEvent({required Event event}) {
    if (event.type != PangeaEventTypes.studentAnalyticsSummary) {
      throw Exception(
        "${event.type} should not be used to make a StudentAnalyticsEvent",
      );
    }
    _event = event;
    if (!classRoom.isSpace) {
      throw Exception(
        "non-class room should not be used to make a StudentAnalyticsEvent",
      );
    }
    _event = event;

    _messagesToSave = [];
  }

  Room get classRoom => _event.room;

  Event get event => _event;

  StudentAnalyticsSummary get content {
    _contentCache ??= StudentAnalyticsSummary.fromJson(event.content);
    return _contentCache!;
  }

  Future<void> removeEdittedMessages(
    RecentMessageRecord message,
  ) async {
    final List<String> removeIds = await classRoom.client.getEditHistory(
      message.chatId,
      message.eventId,
    );
    if (removeIds.isEmpty) return;
    _messagesToSave.removeWhere(
      (msg) => removeIds.any((e) => e == msg.eventId),
    );
    content.removeEdittedMessages(
      classRoom.client,
      removeIds,
    );
  }

  Future<void> handleNewMessage(
    RecentMessageRecord message, {
    isEdit = false,
  }) async {
    if (classRoom.client.userID != _event.stateKey) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be in handleNewMessage ${classRoom.client.userID} != ${_event.stateKey}",
      );
      return;
    }

    if (isEdit) {
      await removeEdittedMessages(message);
    }
    _addMessage(message);

    if (DateTime.now().difference(content.lastUpdated).inMinutes >
        ClassDefaultValues.minutesDelayToUpdateMyAnalytics) {
      _updateStudentAnalytics();
    }
  }

  Future<void> bulkUpdate(List<RecentMessageRecord> messages) async {
    if (classRoom.client.userID != _event.stateKey) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be in bulkUpdate ${classRoom.client.userID} != ${_event.stateKey}",
      );
      return;
    }
    for (final message in messages) {
      await removeEdittedMessages(message);
    }

    _messagesToSave.addAll(messages);
    _updateStudentAnalytics();
  }

  Future<void> _updateStudentAnalytics() async {
    content.lastUpdated = DateTime.now();
    content.addAll(_messagesToSave);
    debugPrint("updating student analytics");
    _clearMessages();

    await classRoom.client.setRoomStateWithKey(
      classRoom.id,
      _event.type,
      _event.stateKey!,
      content.toJson(),
    );
  }

  _addMessage(RecentMessageRecord message) {
    if (_messagesToSave.every((e) => e.eventId != message.eventId)) {
      _messagesToSave.add(message);
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "adding message twice in StudentAnalyticsEvent._addMessage",
      );
    }
    //PTODO - save to local storagge
  }

  _clearMessages() {
    _messagesToSave.clear();
    //PTODO - clear local storagge
  }

  Future<TimeSeriesTotals> getTotals(String? chatId) async {
    final TimeSeriesTotals totals = TimeSeriesTotals.empty;
    final msgs = chatId == null
        ? content.messages
        : content.messages.where((msg) => msg.chatId == chatId);
    for (final msg in msgs) {
      totals.increment(msg);
    }
    return totals;
  }

  Future<TimeSeriesInterval> getTimeServiesInterval(
    DateTime start,
    DateTime end,
    String? chatId,
  ) async {
    final TimeSeriesInterval interval = TimeSeriesInterval(
      start: start,
      end: end,
      totals: TimeSeriesTotals.empty,
    );
    for (final msg in content.messages) {
      if (msg.time.isAfter(start) &&
          msg.time.isBefore(end) &&
          (chatId == null || chatId == msg.chatId)) {
        interval.totals.increment(msg);
      }
    }
    return interval;
  }
}
