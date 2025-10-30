import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_info_batch_request.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_media_response.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_info.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseLocationMediaRepo {
  static final Map<String, Completer<CourseLocationMediaResponse>> _cache = {};
  static final GetStorage _storage =
      GetStorage('course_location_media_storage');

  static Future<CourseLocationMediaResponse> get(
    CourseInfoBatchRequest request,
  ) async {
    await _storage.initStorage;
    final cached = getCached(request);
    final urls = List<CourseMediaInfo>.from(cached.mediaUrls);
    final toFetch = request.uuids
        .where((uuid) => !cached.mediaUrls.any((e) => e.uuid == uuid))
        .toList();

    if (toFetch.isNotEmpty) {
      final fetched = await _fetch(
        CourseInfoBatchRequest(
          batchId: request.batchId,
          uuids: toFetch,
        ),
      );

      urls.addAll(fetched.mediaUrls);
      await _setCached(fetched);
    }

    return CourseLocationMediaResponse(mediaUrls: urls);
  }

  static Future<CourseLocationMediaResponse> _fetch(
    CourseInfoBatchRequest request,
  ) async {
    if (_cache.containsKey(request.batchId)) {
      return _cache[request.batchId]!.future;
    }

    final completer = Completer<CourseLocationMediaResponse>();
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
      final cmsCoursePlanTopicLocationMediasResult = await payload.find(
        CmsCoursePlanTopicLocationMedia.slug,
        CmsCoursePlanTopicLocationMedia.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final resp = CourseLocationMediaResponse.fromCmsResponse(
        cmsCoursePlanTopicLocationMediasResult,
      );
      completer.complete(resp);
      return resp;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(request.batchId);
    }
  }

  static CourseLocationMediaResponse getCached(
    CourseInfoBatchRequest request,
  ) {
    final List<CourseMediaInfo> urls = [];
    for (final uuid in request.uuids) {
      try {
        final url = _storage.read(uuid) as String?;
        if (url != null) {
          urls.add(
            CourseMediaInfo(
              uuid: uuid,
              url: url,
            ),
          );
        }
      } catch (e) {
        // If parsing fails, remove the corrupted cache entry
        _storage.remove(uuid);
      }
    }
    return CourseLocationMediaResponse(mediaUrls: urls);
  }

  static Future<void> _setCached(CourseLocationMediaResponse response) async {
    final List<Future> futures = [];
    for (final entry in response.mediaUrls) {
      futures.add(_storage.write(entry.uuid, entry.url));
    }
    await Future.wait(futures);
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }
}
