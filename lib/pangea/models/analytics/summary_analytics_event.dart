import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
import 'package:matrix/matrix.dart';

import '../../constants/pangea_event_types.dart';

class SummaryAnalyticsEvent extends AnalyticsEvent {
  SummaryAnalyticsEvent({required Event event}) : super(event: event) {
    if (event.type != PangeaEventTypes.summaryAnalytics) {
      throw Exception(
        "${event.type} should not be used to make a SummaryAnalyticsEvent",
      );
    }
  }

  @override
  SummaryAnalyticsModel get content {
    contentCache ??= SummaryAnalyticsModel.fromJson(event.content);
    return contentCache as SummaryAnalyticsModel;
  }

  static Future<String?> sendSummaryAnalyticsEvent(
    Room analyticsRoom,
    List<RecentMessageRecord> records,
  ) async {
    final SummaryAnalyticsModel analyticsModel = SummaryAnalyticsModel(
      messages: records,
    );
    final String? eventId = await analyticsRoom.sendEvent(
      analyticsModel.toJson(),
      type: PangeaEventTypes.summaryAnalytics,
    );
    return eventId;
  }
}
