// import 'dart:convert';

// class ChatTimeSeriesInterval {
//   String? chatId;
//   int? taTotal;
//   int? gaTotal;
//   int? waTotal;

//   ChatTimeSeriesInterval({
//     required this.chatId,
//     required this.taTotal,
//     required this.gaTotal,
//     required this.waTotal,
//   });

//   Map<String, dynamic> toJson() =>
//       {"id": chatId, "ta": taTotal, "ga": gaTotal, "wa": waTotal};

//   factory ChatTimeSeriesInterval.fromJson(json) => ChatTimeSeriesInterval(
//         chatId: json["id"],
//         taTotal: json["ta"],
//         gaTotal: json["ga"],
//         waTotal: json["wa"],
//       );
// }

// class TimeSeriesInterval {
//   DateTime start;
//   DateTime end;
//   List<ChatTimeSeriesInterval> chats;

//   TimeSeriesInterval({
//     required this.start,
//     required this.end,
//     required this.chats,
//   });

//   Map<String, dynamic> toJson() => {
//         "strt": start,
//         "end": end,
//         "usrs": jsonEncode(chats.map((e) => e.toJson()).toList())
//       };

//   factory TimeSeriesInterval.fromJson(json) => TimeSeriesInterval(
//         start: DateTime(json["strt"]),
//         end: DateTime(json["end"]),
//         chats: ((jsonDecode(json["usrs"]) as Iterable)
//             .map((e) => ChatTimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<ChatTimeSeriesInterval>()),
//       );
// }

// // class RecentMessageRecord {
// //   String eventId;
// //   String typeOfUse;
// //   String time;
// // }

// class StudentAnalyticsSummary {
//   /// event statekey = studentId
//   // String studentId;

//   List<TimeSeriesInterval> monthlyTotalsForAllTime;
//   List<TimeSeriesInterval> dailyTotalsForLast30Days;
//   List<TimeSeriesInterval> hourlyTotalsForLast24Hours;

//   // List<RecentMessageRecord> messages;

//   DateTime lastLogin;
//   DateTime lastMessage;

//   DateTime lastUpdated;

//   StudentAnalyticsSummary({
//     // required this.studentId,
//     required this.monthlyTotalsForAllTime,
//     required this.dailyTotalsForLast30Days,
//     required this.hourlyTotalsForLast24Hours,
//     required this.lastLogin,
//     required this.lastMessage,
//     required this.lastUpdated,
//   });

//   // static const _studentIdKey = 'usr';
//   static const _monthKey = "mnths";
//   static const _dayKey = "dys";
//   static const _hoursKey = "hrs";
//   static const _lastLoginKey = "lgn";
//   static const _lastMessageKey = "msg";
//   static const _lastUpdated = "lupt";

//   Map<String, dynamic> toJson() => {
//         _monthKey:
//             jsonEncode(monthlyTotalsForAllTime.map((e) => e.toJson()).toList()),
//         _dayKey: jsonEncode(
//             dailyTotalsForLast30Days.map((e) => e.toJson()).toList()),
//         _hoursKey: jsonEncode(
//             hourlyTotalsForLast24Hours.map((e) => e.toJson()).toList()),
//         // _studentIdKey: studentId,
//         _lastLoginKey: lastLogin.toIso8601String(),
//         _lastMessageKey: lastMessage.toIso8601String(),
//         _lastUpdated: lastUpdated.toIso8601String()
//       };

//   factory StudentAnalyticsSummary.fromJson(json) => StudentAnalyticsSummary(
//         // studentId: json[_studentIdKey],
//         monthlyTotalsForAllTime: (jsonDecode(json[_monthKey]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//         dailyTotalsForLast30Days: (jsonDecode(json[_dayKey]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//         hourlyTotalsForLast24Hours: (jsonDecode(json[_hoursKey]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//         lastLogin: DateTime(json[_lastLoginKey]),
//         lastUpdated: DateTime(json[_lastLoginKey]),
//         lastMessage: DateTime(json[_lastMessageKey]),
//       );
// }
