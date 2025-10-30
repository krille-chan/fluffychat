import 'package:fluffychat/pangea/course_plans/course_locations/course_location_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location.dart';
import 'package:fluffychat/pangea/payload_client/paginated_response.dart';

class CourseLocationResponse {
  final List<CourseLocationModel> locations;

  CourseLocationResponse({
    required this.locations,
  });

  factory CourseLocationResponse.fromCmsResponse(
    PayloadPaginatedResponse<CmsCoursePlanTopicLocation> response,
  ) {
    final locations = response.docs
        .map((location) => location.toCourseLocationModel())
        .toList();

    return CourseLocationResponse(locations: locations);
  }
}
