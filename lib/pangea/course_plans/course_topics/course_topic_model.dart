import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_translation_request.dart';
import 'package:fluffychat/pangea/course_plans/course_info_batch_request.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Represents a topic in the course planner response.
class CourseTopicModel {
  final String title;
  final String description;
  final String uuid;
  final List<String> locationIds;
  final List<String> activityIds;

  CourseTopicModel({
    required this.title,
    required this.description,
    required this.uuid,
    required this.activityIds,
    required this.locationIds,
  });

  bool get locationListComplete =>
      locationIds.length == loadedLocations.locations.length;

  CourseLocationResponse get loadedLocations => CourseLocationRepo.getCached(
        CourseInfoBatchRequest(
          batchId: uuid,
          uuids: locationIds,
        ),
      );
  Future<CourseLocationResponse> fetchLocations() => CourseLocationRepo.get(
        CourseInfoBatchRequest(
          batchId: uuid,
          uuids: locationIds,
        ),
      );

  String? get location => loadedLocations.locations.firstOrNull?.name;

  bool get locationMediaListComplete =>
      loadedLocationMediaIds.length ==
      loadedLocations.locations
          .map((e) => e.mediaIds.length)
          .fold(0, (a, b) => a + b);

  List<String> get loadedLocationMediaIds => loadedLocations.locations
      .map(
        (location) => CourseLocationMediaRepo.getCached(
          CourseInfoBatchRequest(
            batchId: uuid,
            uuids: location.mediaIds,
          ),
        ).mediaUrls,
      )
      .expand((e) => e)
      .map((e) => e.url)
      .toList();

  Future<List<String>> fetchLocationMedia() async {
    final allLocationMedia = <String>[];
    final locationResp = await fetchLocations();
    for (final location in locationResp.locations) {
      final mediaResp = await CourseLocationMediaRepo.get(
        CourseInfoBatchRequest(
          batchId: uuid,
          uuids: location.mediaIds,
        ),
      );

      allLocationMedia.addAll(mediaResp.mediaUrls.map((e) => e.url));
    }
    return allLocationMedia;
  }

  String? get imageUrl => loadedLocationMediaIds.isEmpty
      ? null
      : "${Environment.cmsApi}${loadedLocationMediaIds.first}";

  bool get activityListComplete =>
      activityIds.length == loadedActivities.length;

  Map<String, ActivityPlanModel> get loadedActivities =>
      CourseActivityRepo.getCached(
        TranslateActivityRequest(
          activityIds: activityIds,
          l1: MatrixState.pangeaController.languageController.activeL1Code()!,
        ),
      ).plans;

  Future<Map<String, ActivityPlanModel>> fetchActivities() async {
    final resp = await CourseActivityRepo.get(
      TranslateActivityRequest(
        activityIds: activityIds,
        l1: MatrixState.pangeaController.languageController.activeL1Code()!,
      ),
      uuid,
    );

    return resp.plans;
  }

  /// Deserialize from JSON
  factory CourseTopicModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? activityIdsEntry =
        json['activity_ids'] as List<dynamic>? ??
            json['activityIds'] as List<dynamic>?;
    final List<dynamic>? locationIdsEntry =
        json['location_ids'] as List<dynamic>? ??
            json['locationIds'] as List<dynamic>?;

    return CourseTopicModel(
      title: json['title'] as String,
      description: json['description'] as String,
      uuid: json['uuid'] as String,
      activityIds: activityIdsEntry?.map((e) => e as String).toList() ?? [],
      locationIds: locationIdsEntry?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'uuid': uuid,
      'activity_ids': activityIds,
      'location_ids': locationIds,
    };
  }
}
