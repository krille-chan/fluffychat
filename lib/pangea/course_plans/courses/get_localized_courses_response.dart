import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';

class GetLocalizedCoursesResponse {
  final Map<String, CoursePlanModel> coursePlans;

  GetLocalizedCoursesResponse({required this.coursePlans});

  factory GetLocalizedCoursesResponse.fromJson(Map<String, dynamic> json) {
    final plansEntry = json['course_plans'] as Map<String, dynamic>;
    return GetLocalizedCoursesResponse(
      coursePlans: plansEntry.map(
        (key, value) => MapEntry(
          key,
          CoursePlanModel.fromJson(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "course_plans": coursePlans.map(
          (key, value) => MapEntry(
            key,
            value.toJson(),
          ),
        ),
      };
}
