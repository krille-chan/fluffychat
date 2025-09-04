import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';

class CachedActivityAnalytics {
  final DateTime timestamp;
  final String lastEventId;
  final ActivitySummaryAnalyticsModel analytics;

  CachedActivityAnalytics(
    this.timestamp,
    this.lastEventId,
    this.analytics,
  );
}

class ActivitySessionAnalyticsRepo {
  static final GetStorage _activityAnalyticsStorage =
      GetStorage('activity_analytics_storage');

  static Duration cacheDuration = const Duration(minutes: 30);

  static CachedActivityAnalytics? get(String roomId) {
    final json = _activityAnalyticsStorage.read(roomId);
    if (json == null) return null;

    try {
      final timestamp = DateTime.parse(json['timestamp'] as String);
      if (DateTime.now().difference(timestamp) > cacheDuration) {
        _activityAnalyticsStorage.remove(roomId);
        return null;
      }

      final lastEventId = json['last_event_id'] as String;
      final analyticsJson = json['analytics'] as Map<String, dynamic>;
      final analytics = ActivitySummaryAnalyticsModel.fromJson(analyticsJson);
      return CachedActivityAnalytics(timestamp, lastEventId, analytics);
    } catch (e) {
      _activityAnalyticsStorage.remove(roomId);
      return null;
    }
  }

  static Future<void> set(
    String roomId,
    String lastEventId,
    ActivitySummaryAnalyticsModel analytics,
  ) async {
    final json = {
      'timestamp': DateTime.now().toIso8601String(),
      'last_event_id': lastEventId,
      'analytics': analytics.toJson(),
    };
    await _activityAnalyticsStorage.write(roomId, json);
  }
}
