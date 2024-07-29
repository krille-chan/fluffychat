// import 'dart:developer';

// import 'package:fluffychat/pangea/enum/time_span.dart';
// import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
// import 'package:flutter/foundation.dart';

// import '../../enum/use_type.dart';

// class TimeSeriesTotals {
//   int ta;
//   int ga;
//   int wa;
//   int un;

//   int get all => ta + ga + wa + un;

//   TimeSeriesTotals({
//     required this.ta,
//     required this.ga,
//     required this.wa,
//     required this.un,
//   });

//   Map<String, dynamic> toJson() => {
//         UseType.ta.string: ta,
//         UseType.ga.string: ga,
//         UseType.wa.string: wa,
//         UseType.un.string: un,
//       };

//   factory TimeSeriesTotals.fromJson(json) => TimeSeriesTotals(
//         ta: json[UseType.ta.string],
//         ga: json[UseType.ga.string],
//         wa: json[UseType.wa.string],
//         un: json[UseType.un.string],
//       );

//   static get empty => TimeSeriesTotals(ta: 0, ga: 0, wa: 0, un: 0);

//   int get taPercent => all != 0 ? (ta / all * 100).round() : 0;
//   int get gaPercent => all != 0 ? (ga / all * 100).round() : 0;
//   int get waPercent => all != 0 ? (wa / all * 100).round() : 0;
//   int get unPercent => all != 0 ? (un / all * 100).round() : 0;

//   void increment(RecentMessageRecord msg) {
//     switch (msg.useType) {
//       case UseType.ta:
//         ta += 1;
//         break;
//       case UseType.wa:
//         wa += 1;
//         break;
//       case UseType.ga:
//         ga += 1;
//         break;
//       case UseType.un:
//         un += 1;
//         break;
//       default:
//         debugger(when: kDebugMode);
//         debugPrint("message with bad type ${msg.toJson()}");
//     }
//   }
// }

// class TimeSeriesInterval {
//   DateTime start;
//   DateTime end;
//   TimeSeriesTotals totals;

//   TimeSeriesInterval({
//     required this.start,
//     required this.end,
//     required this.totals,
//   });

//   Map<String, dynamic> toJson() => {
//         "strt": start.toIso8601String(),
//         "end": end.toIso8601String(),
//         "totals": totals.toJson(),
//       };

//   factory TimeSeriesInterval.fromJson(json) => TimeSeriesInterval(
//         start: DateTime.parse(json["strt"]),
//         end: DateTime.parse(json["end"]),
//         totals: TimeSeriesTotals.fromJson(json["totals"]),
//       );
// }

// class ChartAnalyticsModel {
//   final TimeSpan timeSpan;
//   final TimeSeriesTotals totals = TimeSeriesTotals.empty;
//   final List<RecentMessageRecord> msgs;
//   final String? chatId;

//   late DateTime fetchedAt;
//   late List<TimeSeriesInterval> timeSeries;
//   DateTime? lastMessage;

//   ChartAnalyticsModel({
//     required this.timeSpan,
//     required this.msgs,
//     this.chatId,
//   }) {
//     fetchedAt = DateTime.now();
//     calculate();
//   }

//   bool get isEmpty => (totals.ga + totals.ta + totals.wa == 0);

//   void calculate() {
//     final Map<String, TimeSeriesInterval> intervals = timeSpan.emptyIntervals;
//     final DateTime cutOff = timeSpan.cutOffDate;

//     final filtered = msgs.where(
//       (msg) =>
//           (chatId == null || msg.chatId == chatId) && msg.time.isAfter(cutOff),
//     );

//     //remove msgs with duplicate ids
//     final Map<String, RecentMessageRecord> unique = {};
//     for (final msg in filtered) {
//       if (unique[msg.eventId] == null) {
//         unique[msg.eventId] = msg;
//       }
//     }

//     for (final msg in unique.values) {
//       final String key = timeSpan.getMapKey(msg.time);
//       if (intervals[key] == null) {
//         debugger(when: kDebugMode);
//       } else {
//         intervals[key]!.totals.increment(msg);
//         totals.increment(msg);
//         lastMessage = msg.time;
//       }
//     }
//     timeSeries = intervals.values.toList().reversed.toList();
//   }

//   DateTime? get lastMessageTime {
//     if (msgs.isEmpty) {
//       return null;
//     }
//     return msgs.map((msg) => msg.time).reduce(
//           (compare, recent) => compare.isAfter(recent) ? compare : recent,
//         );
//   }
// }
