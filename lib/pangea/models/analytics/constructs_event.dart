import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:matrix/matrix.dart';

import '../../constants/pangea_event_types.dart';

class ConstructAnalyticsEvent extends AnalyticsEvent {
  ConstructAnalyticsEvent({required Event event}) : super(event: event) {
    if (event.type != PangeaEventTypes.construct) {
      throw Exception(
        "${event.type} should not be used to make a ConstructAnalyticsEvent",
      );
    }
  }

  @override
  ConstructAnalyticsModel get content {
    contentCache ??= ConstructAnalyticsModel.fromJson(event.content);
    return contentCache as ConstructAnalyticsModel;
  }
}
