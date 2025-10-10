import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_location_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseLocationRepo {
  static final Map<String, Completer<List<CourseLocationModel>>> _cache = {};
  static final GetStorage _storage = GetStorage('course_location_storage');

  static CourseLocationModel? _getCached(String uuid) {
    final json = _storage.read(uuid);
    if (json != null) {
      try {
        return CourseLocationModel.fromJson(Map<String, dynamic>.from(json));
      } catch (e) {
        // If parsing fails, remove the corrupted cache entry
        _storage.remove(uuid);
      }
    }
    return null;
  }

  static Future<void> _setCached(String uuid, CourseLocationModel location) =>
      _storage.write(uuid, location.toJson());

  static List<CourseLocationModel> getSync(List<String> uuids) {
    final locations = <CourseLocationModel>[];
    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        locations.add(cached);
      }
    }

    return locations;
  }

  static Future<List<CourseLocationModel>> get(
    String courseId,
    List<String> uuids,
  ) async {
    final locations = <CourseLocationModel>[];
    final toFetch = <String>[];

    await _storage.initStorage;
    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        locations.add(cached);
      } else {
        toFetch.add(uuid);
      }
    }

    if (toFetch.isNotEmpty) {
      final fetchedLocations = await _fetch(courseId, toFetch);
      locations.addAll(fetchedLocations);
      for (int i = 0; i < fetchedLocations.length; i++) {
        final location = fetchedLocations[i];
        await _setCached(location.uuid, location);
      }
    }

    return locations;
  }

  static Future<List<CourseLocationModel>> _fetch(
    String topicId,
    List<String> uuids,
  ) async {
    if (_cache.containsKey(topicId)) {
      return _cache[topicId]!.future;
    }

    final completer = Completer<List<CourseLocationModel>>();
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
      final cmsCoursePlanTopicLocationsResult = await payload.find(
        CmsCoursePlanTopicLocation.slug,
        CmsCoursePlanTopicLocation.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final locations = cmsCoursePlanTopicLocationsResult.docs
          .map((location) => location.toCourseLocationModel())
          .toList();

      completer.complete(locations);
      return locations;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(topicId);
    }
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }
}
