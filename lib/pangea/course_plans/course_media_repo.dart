import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseMediaRepo {
  static final Map<String, Completer<Map<String, String>>> _cache = {};
  static final GetStorage _storage = GetStorage('course_media_storage');

  static List<String> getSync(List<String> uuids) {
    final urls = <String>[];
    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        urls.add(cached);
      }
    }

    return urls;
  }

  static Future<List<String>> get(String courseId, List<String> uuids) async {
    final urls = <String>[];
    final toFetch = <String>[];

    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        urls.add(cached);
      } else {
        toFetch.add(uuid);
      }
    }

    if (toFetch.isNotEmpty) {
      final fetchedUrls = await _fetch(courseId, toFetch);
      urls.addAll(fetchedUrls.values.toList());
      for (final entry in fetchedUrls.entries) {
        await _setCached(entry.key, entry.value);
      }
    }

    return urls;
  }

  static String? _getCached(String uuid) => _storage.read(uuid);

  static Future<void> _setCached(String uuid, String url) =>
      _storage.write(uuid, url);

  static Future<Map<String, String>> _fetch(
    String courseId,
    List<String> uuids,
  ) async {
    if (_cache.containsKey(courseId)) {
      return _cache[courseId]!.future;
    }

    final completer = Completer<Map<String, String>>();
    _cache[courseId] = completer;

    final where = {
      "id": {"in": uuids.join(",")},
    };
    final limit = uuids.length;

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
        return {};
      }

      final media = Map.fromEntries(
        cmsCoursePlanMediaResult.docs
            .where((media) => media.url != null)
            .map((media) => MapEntry(media.id, media.url!)),
      );

      completer.complete(media);
      return media;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(courseId);
    }
  }
}
