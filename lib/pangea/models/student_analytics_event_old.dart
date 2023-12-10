// import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
// import 'package:fluffychat/pangea/models/analytics_model_older.dart';
// import 'package:matrix/matrix.dart';

// import '../constants/pangea_event_types.dart';

// class StudentAnalyticsEvent {
//   late Event _event;
//   StudentAnalyticsSummary? _contentCache;

//   StudentAnalyticsEvent({required Event event}) {
//     if (event.type != PangeaEventTypes.studentAnalyticsSummary) {
//       throw Exception(
//         "${event.type} should not be used to make a StudentAnalyticsEvent",
//       );
//     }
//     _event = event;
//   }

//   Event get event => _event;

//   StudentAnalyticsSummary get _content {
//     _contentCache ??= event.getPangeaContent<StudentAnalyticsSummary>();
//     return _contentCache!;
//   }

//   List<TimeSeriesInterval> get monthly => _content.monthlyTotalsForAllTime;
//   List<TimeSeriesInterval> get daily => _content.dailyTotalsForLast30Days;
//   List<TimeSeriesInterval> get hourly => _content.hourlyTotalsForLast24Hours;

//   // updateLocal
//   // updateServer
//   handleNewMessage() {}

//   /// if monthly.isNotEmpty && last.end.month < now.month
//   ///   push empty intervals until last.end.month >= now.month
//   /// if daily.isEmpty
//   ///   push empty intervals until last.end.day >= now.day
//   /// else if daily.where(e => e.month < now.month)
//   ///   sum and add to monthly
//   ///
//   /// if hourly.isEmpty || last.end.hour < now.hour
//   ///   push empty intervals until last.end.hour >= now.hour
//   /// increment hourly

//   updateLocal() {}

//   // if server copy is older than x, push local version
//   // get new server copy, local version = server copy
//   updateServer() {}
// }
