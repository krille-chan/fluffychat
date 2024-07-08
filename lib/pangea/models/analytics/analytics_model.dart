import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';

abstract class AnalyticsModel {
  static List<dynamic> formatAnalyticsContent(
    List<PangeaMessageEvent> recentMsgs,
    String type,
  ) {
    switch (type) {
      case PangeaEventTypes.summaryAnalytics:
        return SummaryAnalyticsModel.formatSummaryContent(recentMsgs);
      case PangeaEventTypes.construct:
        final List<OneConstructUse> uses = [];
        for (final msg in recentMsgs) {
          uses.addAll(msg.allConstructUses);
        }
        return uses;
    }
    return [];
  }
}
