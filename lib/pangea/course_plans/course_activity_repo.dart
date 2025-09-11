import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
      final PayloadClient payload = PayloadClient(
        baseUrl: Environment.cmsApi,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );

      final cmsCoursePlanActivitiesResult = await payload.find(
        CmsCoursePlanActivity.slug,
        CmsCoursePlanActivity.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final imageUrls = await _fetchImageUrls(
        cmsCoursePlanActivitiesResult.docs,
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
    List<CmsCoursePlanActivity> activities,
  ) async {
    // map of mediaId to activityId
    final activityToMediaId = Map.fromEntries(
      activities
          .where((a) => a.coursePlanActivityMedia?.docs?.isNotEmpty ?? false)
          .map((a) {
        final mediaIds = a.coursePlanActivityMedia?.docs;
        return MapEntry(mediaIds?.firstOrNull, a.id);
      }),
    );

    final mediaIds = activityToMediaId.keys.whereType<String>().toList();
    final where = {
      "id": {"in": mediaIds.join(",")},
    };
    final limit = mediaIds.length;

    final PayloadClient payload = PayloadClient(
      baseUrl: Environment.cmsApi,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );
    final cmsCoursePlanActivityMediasResult = await payload.find(
      CmsCoursePlanActivityMedia.slug,
      CmsCoursePlanActivityMedia.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );

    return Map.fromEntries(
      cmsCoursePlanActivityMediasResult.docs.map((media) {
        final activityId = activityToMediaId[media.id];
        if (activityId != null && media.url != null) {
          return MapEntry(activityId, '${Environment.cmsApi}${media.url!}');
        }
        return null;
      }).whereType<MapEntry<String, String>>(),
    );
  }
}
