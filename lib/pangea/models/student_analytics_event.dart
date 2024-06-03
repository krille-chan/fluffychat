// import 'dart:developer';

// import 'package:fluffychat/pangea/extensions/client_extension.dart';
// import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
// import 'package:fluffychat/pangea/utils/error_handler.dart';
// import 'package:flutter/foundation.dart';
// import 'package:matrix/matrix.dart';

// import '../constants/pangea_event_types.dart';
// import 'chart_analytics_model.dart';

// class StudentAnalyticsEvent {
//   late Event _event;
//   StudentAnalyticsSummary? _contentCache;
//   List<RecentMessageRecord> _messagesToSave = [];

//   StudentAnalyticsEvent({required Event event}) {
//     if (event.type != PangeaEventTypes.studentAnalyticsSummary) {
//       throw Exception(
//         "${event.type} should not be used to make a StudentAnalyticsEvent",
//       );
//     }
//     _event = event;
//     _messagesToSave = [];
//   }

//   Event get event => _event;

//   StudentAnalyticsSummary get content {
//     _contentCache ??= StudentAnalyticsSummary.fromJson(event.content);
//     return _contentCache!;
//   }

//   Future<void> removeEdittedMessages(
//     RecentMessageRecord message,
//   ) async {
//     final List<String> removeIds = await event.room.client.getEditHistory(
//       message.chatId,
//       message.eventId,
//     );
//     if (removeIds.isEmpty) return;
//     _messagesToSave.removeWhere(
//       (msg) => removeIds.any((e) => e == msg.eventId),
//     );
//     content.removeEdittedMessages(
//       event.room.client,
//       removeIds,
//     );
//   }

//   // Future<void> handleNewMessage(
//   //   RecentMessageRecord message, {
//   //   isEdit = false,
//   // }) async {
//   //   if (isEdit) {
//   //     await removeEdittedMessages(message);
//   //   }
//   //   // _addMessage(message);
//   //   _messagesToSave.add(message);
//   //   debugPrint("messages to save is now: ${_messagesToSave.length}");

//   //   if (DateTime.now().difference(content.lastUpdated).inMinutes >
//   //       ClassDefaultValues.minutesDelayToUpdateMyAnalytics) {
//   //     _updateStudentAnalytics();
//   //   }
//   // }

//   // Future<void> bulkUpdate(List<RecentMessageRecord> messages) async {
//   //   // if (event.room.client.userID != _event.stateKey) {
//   //   //   debugger(when: kDebugMode);
//   //   //   ErrorHandler.logError(
//   //   //     m: "should not be in bulkUpdate ${event.room.client.userID} != ${_event.stateKey}",
//   //   //   );
//   //   //   return;
//   //   // }
//   //   for (final message in messages) {
//   //     await removeEdittedMessages(message);
//   //   }

//   //   _messagesToSave.addAll(messages);
//   //   await _updateStudentAnalytics();
//   // }

//   // Future<void> _updateStudentAnalytics() async {
//   //   content.lastUpdated = DateTime.now();
//   //   content.addAll(_messagesToSave);
//   //   _clearMessages();

//   //   await event.room.client.setRoomStateWithKey(
//   //     event.room.id,
//   //     _event.type,
//   //     '',
//   //     content.toJson(),
//   //   );
//   // }

//   Future<void> updateStudentAnalytics() async {
//     content.lastUpdated = DateTime.now();
//     // content.addAll(_messagesToSave);
//     // _clearMessages();

//     await event.room.client.setRoomStateWithKey(
//       event.room.id,
//       _event.type,
//       '',
//       content.toJson(),
//     );
//     await event.room.postLoad();
//   }

//   _addMessage(RecentMessageRecord message) {
//     if (_messagesToSave.every((e) => e.eventId != message.eventId)) {
//       _messagesToSave.add(message);
//     } else {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(
//         m: "adding message twice in StudentAnalyticsEvent._addMessage",
//       );
//     }
//     //PTODO - save to local storagge
//   }

//   _clearMessages() {
//     _messagesToSave.clear();
//     //PTODO - clear local storagge
//   }

//   Future<TimeSeriesTotals> getTotals(String? chatId) async {
//     final TimeSeriesTotals totals = TimeSeriesTotals.empty;
//     final msgs = chatId == null
//         ? content.messages
//         : content.messages.where((msg) => msg.chatId == chatId);
//     for (final msg in msgs) {
//       totals.increment(msg);
//     }
//     return totals;
//   }

//   Future<TimeSeriesInterval> getTimeServiesInterval(
//     DateTime start,
//     DateTime end,
//     String? chatId,
//   ) async {
//     final TimeSeriesInterval interval = TimeSeriesInterval(
//       start: start,
//       end: end,
//       totals: TimeSeriesTotals.empty,
//     );
//     for (final msg in content.messages) {
//       if (msg.time.isAfter(start) &&
//           msg.time.isBefore(end) &&
//           (chatId == null || chatId == msg.chatId)) {
//         interval.totals.increment(msg);
//       }
//     }
//     return interval;
//   }

//   bool isAlreadyAdded(RecentMessageRecord message) {
//     return content.messages.any(
//       (element) => element.eventId == message.eventId,
//     );
//   }
// }
