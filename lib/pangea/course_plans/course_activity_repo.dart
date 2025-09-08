import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_repo.dart';

class CourseActivityRepo {
  static final Map<String, Completer<List<ActivityPlanModel>>> _cache = {};
  static final GetStorage _storage = GetStorage('course_activity_storage');

  static ActivityPlanModel? _getCached(String uuid) {
    final json = _storage.read<Map<String, dynamic>>(uuid);
    if (json != null) {
      try {
        return ActivityPlanModel.fromJson(json);
      } catch (e) {
        // ignore invalid cached data
        _storage.remove(uuid);
      }
    }
    return null;
  }

  static Future<void> _setCached(ActivityPlanModel activity) =>
      _storage.write(activity.activityId, activity.toJson());

  static List<ActivityPlanModel> getSync(List<String> uuids) {
    return uuids
        .map((uuid) => _getCached(uuid))
        .whereType<ActivityPlanModel>()
        .toList();
  }

  static Future<List<ActivityPlanModel>> get(
    String topicId,
    List<String> uuids,
  ) async {
    final activities = <ActivityPlanModel>[];
    final toFetch = <String>[];

    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        activities.add(cached);
      } else {
        toFetch.add(uuid);
      }
    }

    if (toFetch.isNotEmpty) {
      final fetchedActivities = await _fetch(topicId, toFetch);
      activities.addAll(fetchedActivities);
      for (final activity in fetchedActivities) {
        await _setCached(activity);
      }
    }

    return activities;
  }

  static Future<List<ActivityPlanModel>> _fetch(
    String topicId,
    List<String> uuids,
  ) async {
    if (_cache.containsKey(topicId)) {
      return _cache[topicId]!.future;
    }

    final completer = Completer<List<ActivityPlanModel>>();
    _cache[topicId] = completer;

    final where = {
      "id": {"in": uuids.join(",")},
    };
    final limit = uuids.length;

    try {
      final cmsCoursePlanActivitiesResult = await PayloadRepo.payload.find(
        CmsCoursePlanActivity.slug,
        CmsCoursePlanActivity.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final imageUrls = await _fetchImageUrls(
        cmsCoursePlanActivitiesResult.docs.map((a) => a.id).toList(),
      );

      final activities = cmsCoursePlanActivitiesResult.docs
          .map((a) => a.toActivityPlanModel(imageUrls[a.id]))
          .toList();

      completer.complete(activities);
      return activities;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(topicId);
    }
  }

  static Future<Map<String, String>> _fetchImageUrls(
    List<String> activityIds,
  ) async {
    final where = {
      "id": {"in": activityIds.join(",")},
    };
    final limit = activityIds.length;
    final cmsCoursePlanActivityMediasResult = await PayloadRepo.payload.find(
      CmsCoursePlanActivityMedia.slug,
      CmsCoursePlanActivityMedia.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return Map.fromEntries(
      cmsCoursePlanActivityMediasResult.docs.map((e) => MapEntry(e.id, e.url!)),
    );
  }
}
