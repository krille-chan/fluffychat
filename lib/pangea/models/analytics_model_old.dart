// import 'dart:convert';

// class UserTimeSeriesInterval {
//   String? userId;
//   int? taTotal;
//   int? gaTotal;
//   int? waTotal;

//   UserTimeSeriesInterval({
//     required this.userId,
//     required this.taTotal,
//     required this.gaTotal,
//     required this.waTotal,
//   });

//   Map<String, dynamic> toJson() =>
//       {"usr": userId, "ta": taTotal, "ga": gaTotal, "wa": waTotal};

//   factory UserTimeSeriesInterval.fromJson(json) => UserTimeSeriesInterval(
//         userId: json["usr"],
//         taTotal: json["ta"],
//         gaTotal: json["ga"],
//         waTotal: json["wa"],
//       );
// }

// class TimeSeriesInterval {
//   DateTime start;
//   DateTime end;
//   List<UserTimeSeriesInterval> users;

//   TimeSeriesInterval({
//     required this.start,
//     required this.end,
//     required this.users,
//   });

//   Map<String, dynamic> toJson() => {
//         "strt": start,
//         "end": end,
//         "usrs": jsonEncode(users.map((e) => e.toJson()).toList())
//       };

//   factory TimeSeriesInterval.fromJson(json) => TimeSeriesInterval(
//         start: json["strt"],
//         end: json["end"],
//         users: ((jsonDecode(json["usrs"]) as Iterable)
//             .map((e) => UserTimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<UserTimeSeriesInterval>()),
//       );
// }

// class RoomAnalyticsSummary {
//   List<TimeSeriesInterval> monthlyTotalsForAllTime;
//   List<TimeSeriesInterval> dailyTotalsForLast30Days;
//   List<TimeSeriesInterval> hourlyTotalsForLast24Hours;

//   DateTime? updatedAt;

//   RoomAnalyticsSummary({
//     required this.monthlyTotalsForAllTime,
//     required this.dailyTotalsForLast30Days,
//     required this.hourlyTotalsForLast24Hours,
//   });

//   Map<String, dynamic> toJson() => {
//         "mnths":
//             jsonEncode(monthlyTotalsForAllTime.map((e) => e.toJson()).toList()),
//         "dys": jsonEncode(
//             dailyTotalsForLast30Days.map((e) => e.toJson()).toList()),
//         "hrs": jsonEncode(
//             hourlyTotalsForLast24Hours.map((e) => e.toJson()).toList()),
//       };

//   factory RoomAnalyticsSummary.fromJson(json) => RoomAnalyticsSummary(
//         monthlyTotalsForAllTime: (jsonDecode(json["mnths"]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//         dailyTotalsForLast30Days: (jsonDecode(json["dys"]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//         hourlyTotalsForLast24Hours: (jsonDecode(json["hrs"]) as Iterable)
//             .map((e) => TimeSeriesInterval.fromJson(e))
//             .toList()
//             .cast<TimeSeriesInterval>(),
//       );
// }

// class UserDirectChatAnalyticsSummary {
//   // directChatRoomIds and analytics for those rooms
//   // updated by user;
//   Map<String, RoomAnalyticsSummary>? directChatSummaries;

//   Map<String, dynamic> toJson() => {};
// }

// // maybe search how to do date ranges in dart