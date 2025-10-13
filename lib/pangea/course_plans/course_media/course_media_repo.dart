import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_info_batch_request.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_info.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_response.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseMediaRepo {
  static final Map<String, Completer<CourseMediaResponse>> _cache = {};
  static final GetStorage _storage = GetStorage('course_media_storage');

  static Future<CourseMediaResponse> get(
    CourseInfoBatchRequest request,
  ) async {
    final urls = <CourseMediaInfo>[];

    await _storage.initStorage;
    urls.addAll(getCached(request).mediaUrls);

    final toFetch = request.uuids
        .where((uuid) => !urls.any((e) => e.uuid == uuid))
        .toList();

    if (toFetch.isNotEmpty) {
      final fetchedUrls = await _fetch(
        CourseInfoBatchRequest(
          batchId: request.batchId,
          uuids: toFetch,
        ),
      );
      urls.addAll(fetchedUrls.mediaUrls);
      await _setCached(fetchedUrls);
    }

    return CourseMediaResponse(mediaUrls: urls);
  }

  static Future<CourseMediaResponse> _fetch(
    CourseInfoBatchRequest request,
  ) async {
    if (_cache.containsKey(request.batchId)) {
      return _cache[request.batchId]!.future;
    }

    final completer = Completer<CourseMediaResponse>();
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
      final cmsCoursePlanMediaResult = await payload.find(
        CmsCoursePlanMedia.slug,
        CmsCoursePlanMedia.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      if (cmsCoursePlanMediaResult.docs.isEmpty) {
        return CourseMediaResponse(mediaUrls: []);
      }

      final response = CourseMediaResponse.fromCmsResponse(
        cmsCoursePlanMediaResult,
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

  static CourseMediaResponse getCached(CourseInfoBatchRequest request) {
    final urls = <CourseMediaInfo>[];

    for (final uuid in request.uuids) {
      final cached = _storage.read(uuid);
      if (cached != null && cached is String) {
        urls.add(
          CourseMediaInfo(
            uuid: uuid,
            url: cached,
          ),
        );
      }
    }

    return CourseMediaResponse(mediaUrls: urls);
  }

  static Future<void> _setCached(CourseMediaResponse response) async {
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
