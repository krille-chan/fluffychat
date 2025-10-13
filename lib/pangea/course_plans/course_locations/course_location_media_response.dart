import 'package:fluffychat/pangea/course_plans/course_media/course_media_info.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location_media.dart';
import 'package:fluffychat/pangea/payload_client/paginated_response.dart';

class CourseLocationMediaResponse {
  final List<CourseMediaInfo> mediaUrls;

  CourseLocationMediaResponse({
    required this.mediaUrls,
  });

  factory CourseLocationMediaResponse.fromCmsResponse(
    PayloadPaginatedResponse<CmsCoursePlanTopicLocationMedia>
        cmsCoursePlanTopicLocationMediasResult,
  ) {
    return CourseLocationMediaResponse(
      mediaUrls: cmsCoursePlanTopicLocationMediasResult.docs
          .where((e) => e.url != null)
          .map(
            (e) => CourseMediaInfo(
              uuid: e.id,
              url: e.url!,
            ),
          )
          .toList(),
    );
  }
}
