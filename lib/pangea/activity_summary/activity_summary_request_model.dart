// Add this import for the participant summary model

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';

class ActivitySummaryResultsMessage {
  final String userId;
  final String sent;
  final String? written;
  final List<String> tool;
  final DateTime time;

  ActivitySummaryResultsMessage({
    required this.userId,
    required this.sent,
    this.written,
    required this.tool,
    required this.time,
  });

  factory ActivitySummaryResultsMessage.fromJson(Map<String, dynamic> json) {
    return ActivitySummaryResultsMessage(
      userId: json['user_id'] as String,
      sent: json['sent'] as String,
      written: json['written'] as String?,
      tool: (json['tool'] as List).map((e) => e as String).toList(),
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'sent': sent,
      if (written != null) 'written': written,
      'tool': tool,
      'time': time.toIso8601String(),
    };
  }
}

class ContentFeedbackModel {
  final String feedback;
  final ActivitySummaryResponseModel content;

  ContentFeedbackModel({
    required this.feedback,
    required this.content,
  });

  factory ContentFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ContentFeedbackModel(
      feedback: json['feedback'] as String,
      content: ActivitySummaryResponseModel.fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback': feedback,
      'content': content.toJson(),
    };
  }
}

class ActivitySummaryRequestModel {
  final ActivityPlanModel activity;
  final ActivityRolesModel? roleState;
  final List<ActivitySummaryResultsMessage> activityResults;
  final List<ContentFeedbackModel> contentFeedback;
  final ActivitySummaryAnalyticsModel analytics;

  ActivitySummaryRequestModel({
    required this.activity,
    required this.activityResults,
    required this.contentFeedback,
    required this.analytics,
    this.roleState,
  });

  Map<String, dynamic> toJson() {
    return {
      'activity': activity.toJson(),
      'activity_results': activityResults.map((e) => e.toJson()).toList(),
      'content_feedback': contentFeedback.map((e) => e.toJson()).toList(),
      'analytics': analytics.toJson(),
      'role_state': roleState?.toJson() ?? {},
    };
  }
}
