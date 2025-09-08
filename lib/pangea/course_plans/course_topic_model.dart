import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_location_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_location_model.dart';
import 'package:fluffychat/pangea/course_plans/course_location_repo.dart';

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

  bool get locationListComplete => locationIds.length == loadedLocations.length;
  List<CourseLocationModel> get loadedLocations =>
      CourseLocationRepo.getSync(locationIds);
  Future<List<CourseLocationModel>> fetchLocations() =>
      CourseLocationRepo.get(uuid, locationIds);
  String? get location => loadedLocations.firstOrNull?.name;

  bool get locationMediaListComplete =>
      loadedLocationMediaIds.length ==
      loadedLocations.map((e) => e.mediaIds.length).fold(0, (a, b) => a + b);
  List<String> get loadedLocationMediaIds => loadedLocations
      .map((location) => CourseLocationMediaRepo.getSync(location.mediaIds))
      .expand((e) => e)
      .toList();
  Future<List<String>> fetchLocationMedia() async {
    final allLocationMedia = <String>[];
    for (final location in await fetchLocations()) {
      allLocationMedia.addAll(
        await CourseLocationMediaRepo.get(uuid, location.mediaIds),
      );
    }
    return allLocationMedia;
  }

  String? get imageUrl => loadedLocationMediaIds.isEmpty
      ? null
      : "${Environment.cmsApi}${loadedLocationMediaIds.first}";

  bool get activityListComplete =>
      activityIds.length == loadedActivities.length;
  List<ActivityPlanModel> get loadedActivities =>
      CourseActivityRepo.getSync(activityIds);
  Future<List<ActivityPlanModel>> fetchActivities() =>
      CourseActivityRepo.get(uuid, activityIds);

  /// Deserialize from JSON
  factory CourseTopicModel.fromJson(Map<String, dynamic> json) {
    return CourseTopicModel(
      title: json['title'] as String,
      description: json['description'] as String,
      uuid: json['uuid'] as String,
      activityIds: (json['activity_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      locationIds: (json['location_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
