import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_info_batch_request.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_model.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_response.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseLocationRepo {
  static final Map<String, Completer<CourseLocationResponse>> _cache = {};
  static final GetStorage _storage = GetStorage('course_location_storage');

  static Future<CourseLocationResponse> get(
    CourseInfoBatchRequest request,
  ) async {
    await _storage.initStorage;
    final locations = getCached(request).locations;

    final toFetch = request.uuids
        .where(
          (id) => locations.indexWhere((location) => location.uuid == id) == -1,
        )
        .toList();

    if (toFetch.isNotEmpty) {
      final fetchedLocations = await _fetch(
        CourseInfoBatchRequest(
          batchId: request.batchId,
          uuids: toFetch,
        ),
      );
      locations.addAll(fetchedLocations.locations);
      await _setCached(fetchedLocations);
    }

    return CourseLocationResponse(locations: locations);
  }

  static Future<CourseLocationResponse> _fetch(
    CourseInfoBatchRequest request,
  ) async {
    if (_cache.containsKey(request.batchId)) {
      return _cache[request.batchId]!.future;
    }

    final completer = Completer<CourseLocationResponse>();
    _cache[request.batchId] = completer;

    final where = {
      "id": {"in": request.uuids.join(",")},
    };
    final limit = request.uuids.length;

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

      final response = CourseLocationResponse.fromCmsResponse(
        cmsCoursePlanTopicLocationsResult,
      );

      completer.complete(response);
      return response;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(request.batchId);
    }
  }

  static CourseLocationResponse getCached(
    CourseInfoBatchRequest request,
  ) {
    final List<CourseLocationModel> locations = [];
    for (final uuid in request.uuids) {
      final json = _storage.read(uuid);
      if (json != null) {
        try {
          final location =
              CourseLocationModel.fromJson(Map<String, dynamic>.from(json));
          locations.add(location);
        } catch (e) {
          // If parsing fails, remove the corrupted cache entry
          _storage.remove(uuid);
        }
      }
    }

    return CourseLocationResponse(locations: locations);
  }

  static Future<void> _setCached(CourseLocationResponse locations) {
    final List<Future> futures = [];
    for (final location in locations.locations) {
      futures.add(_storage.write(location.uuid, location.toJson()));
    }
    return Future.wait(futures);
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }
}
