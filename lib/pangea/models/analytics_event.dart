import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/models/analytics_model.dart';
import 'package:fluffychat/pangea/models/constructs_model.dart';
import 'package:fluffychat/pangea/models/summary_analytics_model.dart';
import 'package:matrix/matrix.dart';

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
}
