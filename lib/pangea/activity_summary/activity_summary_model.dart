import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';

class ActivitySummaryModel {
  final ActivitySummaryResponseModel? summary;
  final DateTime? requestedAt;
  final DateTime? errorAt;
  final ActivitySummaryAnalyticsModel? analytics;

  ActivitySummaryModel({
    this.summary,
    this.requestedAt,
    this.errorAt,
    this.analytics,
  });

  Map<String, dynamic> toJson() {
    return {
      "summary": summary?.toJson(),
      "requested_at": requestedAt?.toIso8601String(),
      "error_at": errorAt?.toIso8601String(),
      "analytics": analytics?.toJson(),
    };
  }

  factory ActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    return ActivitySummaryModel(
      summary: json['summary'] != null
          ? ActivitySummaryResponseModel.fromJson(json['summary'])
          : null,
      requestedAt: json['requested_at'] != null
          ? DateTime.parse(json['requested_at'])
          : null,
      errorAt:
          json['error_at'] != null ? DateTime.parse(json['error_at']) : null,
      analytics: json['analytics'] != null
          ? ActivitySummaryAnalyticsModel.fromJson(json['analytics'])
          : null,
    );
  }

  bool get _hasTimeout =>
      summary == null &&
      requestedAt != null &&
      requestedAt!.isBefore(
        DateTime.now().subtract(const Duration(seconds: 10)),
      );

  bool get hasError => errorAt != null || _hasTimeout;

  bool get isLoading => summary == null && requestedAt != null && !hasError;
}
