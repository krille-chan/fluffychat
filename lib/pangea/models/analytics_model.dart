abstract class AnalyticsModel {
  DateTime? lastUpdated;
  String? prevEventId;
  DateTime? prevLastUpdated;

  AnalyticsModel({
    this.lastUpdated,
    this.prevEventId,
    this.prevLastUpdated,
  });
}
