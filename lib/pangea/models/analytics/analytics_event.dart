import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
import 'package:matrix/matrix.dart';

// superclass for all analytics events
abstract class AnalyticsEvent {
  late Event _event;
  AnalyticsModel? contentCache;

  AnalyticsEvent({required Event event}) {
    _event = event;
  }

  Event get event => _event;

  AnalyticsModel get content {
    switch (_event.type) {
      case PangeaEventTypes.summaryAnalytics:
        contentCache ??= SummaryAnalyticsModel.fromJson(event.content);
        break;
      case PangeaEventTypes.construct:
        contentCache ??= ConstructAnalyticsModel.fromJson(event.content);
        break;
    }
    return contentCache!;
  }

  static List<String> analyticsEventTypes = [
    PangeaEventTypes.summaryAnalytics,
    PangeaEventTypes.construct,
  ];

  static Future<String?> sendEvent(
    Room analyticsRoom,
    String type,
    List<dynamic> analyticsContent,
  ) async {
    String? eventId;
    switch (type) {
      case PangeaEventTypes.summaryAnalytics:
        eventId = await SummaryAnalyticsEvent.sendSummaryAnalyticsEvent(
          analyticsRoom,
          analyticsContent.cast<RecentMessageRecord>(),
        );
        break;
      case PangeaEventTypes.construct:
        eventId = await ConstructAnalyticsEvent.sendConstructsEvent(
          analyticsRoom,
          analyticsContent.cast<OneConstructUse>(),
        );
        break;
    }
    return eventId;
  }
}
