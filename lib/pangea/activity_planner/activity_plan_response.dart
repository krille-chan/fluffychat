import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';

class ActivityPlanResponse {
  final List<ActivityPlanModel> activityPlans;

  ActivityPlanResponse({required this.activityPlans});

  factory ActivityPlanResponse.fromJson(Map<String, dynamic> json) {
    return ActivityPlanResponse(
      activityPlans: (json['activity_plans'] as List)
          .map((e) => ActivityPlanModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_plans': activityPlans.map((e) => e.toJson()).toList(),
    };
  }
}
