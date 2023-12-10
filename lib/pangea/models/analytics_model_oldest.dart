// import 'dart:convert';

// class BaseDataModel {
//   late int spanTotal;
//   late int spanIT;
//   late int spanIGC;
//   late int spanDirect;

//   BaseDataModel(Map<String, dynamic> json) {
//     fromJson(json);
//   }

//   fromJson(Map<String, dynamic> json) {
//     spanTotal = json["total"];
//     spanIT = json["it"];
//     spanIGC = json["igc"];
//     spanDirect = json["direct"];
//   }
// }

// class TimeSeriesInterval extends BaseDataModel {
//   //note: always in UTC
//   late DateTime start;
//   late DateTime end;

//   TimeSeriesInterval(Map<String, dynamic> json) : super(json) {
//     fromJsonTimeSeriesInterval(json);
//   }

//   fromJsonTimeSeriesInterval(Map<String, dynamic> json) {
//     start = DateTime.parse(json["start"]);
//     end = DateTime.parse(json["end"]);
//   }
// }

// class chartAnalytics extends BaseDataModel {
//   late String id;
//   late int allTotal;
//   late int allIT;
//   late int allIGC;
//   late int allDirect;
//   late String timeSpan;
//   late DateTime fetchedAt;
//   late List<String>? chatIds;
//   late List<String>? userIds;
//   late List<String>? classIds;
//   late List<TimeSeriesInterval> timeSeries;

//   chartAnalytics(Map<String, dynamic> json) : super(json) {
//     fromJsonchartAnalytics(json);
//     fetchedAt = DateTime.now();
//   }

//   fromJsonchartAnalytics(Map<String, dynamic> json) {
//     id = json["id"];
//     timeSpan = json["timespan"];
//     allTotal = json["alltime"]["total"];
//     allIT = json["alltime"]["it"];
//     allIGC = json["alltime"]["igc"];
//     allDirect = json["alltime"]["direct"];
//     timeSeries = (json["timeseries"] as Iterable<dynamic>)
//         .map(
//           (timeSeriesJsonEntry) => TimeSeriesInterval(timeSeriesJsonEntry),
//         )
//         .toList()
//         .cast<TimeSeriesInterval>();
//     chatIds = json["chats"] != null && json["chats"] != []
//         ? (json["chats"] as List<dynamic>).cast<String>()
//         : null;
//     userIds = json["users"] != null && json["userIds"] != []
//         ? (json["users"] as List<dynamic>).cast<String>()
//         : null;
//     classIds = json["classes"] != null && json["classes"] != []
//         ? (json["classes"] as List<dynamic>).cast<String>()
//         : null;
//   }
// }
