import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';

class TranslateActivityResponse {
  final Map<String, ActivityPlanModel> plans;

  TranslateActivityResponse({required this.plans});

  factory TranslateActivityResponse.fromJson(Map<String, dynamic> json) {
    final plansEntry = json['plans'] as Map<String, dynamic>;
    return TranslateActivityResponse(
      plans: plansEntry.map(
        (key, value) {
          return MapEntry(
            key,
            ActivityPlanModel.fromJson(value),
          );
        },
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "plans": plans.map((key, value) => MapEntry(key, value.toJson())),
      };
}
