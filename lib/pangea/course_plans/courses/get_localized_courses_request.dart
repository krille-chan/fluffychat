class GetLocalizedCoursesRequest {
  final List<String> coursePlanIds;
  final String l1;

  GetLocalizedCoursesRequest({
    required this.coursePlanIds,
    required this.l1,
  });

  Map<String, dynamic> toJson() => {
        "course_plan_ids": coursePlanIds,
        "l1": l1,
      };

  factory GetLocalizedCoursesRequest.fromJson(Map<String, dynamic> json) {
    return GetLocalizedCoursesRequest(
      coursePlanIds: json['course_plan_ids'] != null
          ? List<String>.from(json['course_plan_ids'])
          : [],
      l1: json['l1'],
    );
  }
}
