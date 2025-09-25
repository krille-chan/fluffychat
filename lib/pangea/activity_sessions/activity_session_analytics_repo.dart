import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';

class CachedActivityAnalytics {
  final DateTime timestamp;
  final DateTime lastUseTimestamp;
  final ActivitySummaryAnalyticsModel analytics;

  CachedActivityAnalytics(
    this.timestamp,
    this.lastUseTimestamp,
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

      final lastUseTimestamp =
          DateTime.parse(json['last_use_timestamp'] as String);
      final analyticsJson = json['analytics'] as Map<String, dynamic>;
      final analytics = ActivitySummaryAnalyticsModel.fromJson(analyticsJson);
      return CachedActivityAnalytics(timestamp, lastUseTimestamp, analytics);
    } catch (e) {
      _activityAnalyticsStorage.remove(roomId);
      return null;
    }
  }

  static Future<void> set(
    String roomId,
    DateTime lastUseTimestamp,
    ActivitySummaryAnalyticsModel analytics,
  ) async {
    final json = {
      'timestamp': DateTime.now().toIso8601String(),
      'last_use_timestamp': lastUseTimestamp.toIso8601String(),
      'analytics': analytics.toJson(),
    };
    await _activityAnalyticsStorage.write(roomId, json);
  }
}
