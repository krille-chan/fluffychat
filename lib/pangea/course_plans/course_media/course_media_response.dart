import 'package:fluffychat/pangea/course_plans/course_media/course_media_info.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_media.dart';
import 'package:fluffychat/pangea/payload_client/paginated_response.dart';

class CourseMediaResponse {
  final List<CourseMediaInfo> mediaUrls;

  CourseMediaResponse({
    required this.mediaUrls,
  });

  factory CourseMediaResponse.fromCmsResponse(
    PayloadPaginatedResponse<CmsCoursePlanMedia> response,
  ) {
    return CourseMediaResponse(
      mediaUrls: response.docs
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
