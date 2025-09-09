import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location_media.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseLocationMediaRepo {
  static final Map<String, Completer<Map<String, String>>> _cache = {};
  static final GetStorage _storage =
      GetStorage('course_location_media_storage');

  static String? _getCached(String uuid) {
    try {
      return _storage.read(uuid) as String?;
    } catch (e) {
      // If parsing fails, remove the corrupted cache entry
      _storage.remove(uuid);
    }
    return null;
  }

  static Future<void> _setCached(String uuid, String url) =>
      _storage.write(uuid, url);

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

  static Future<List<String>> get(String topicId, List<String> uuids) async {
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
      final fetched = await _fetch(topicId, toFetch);
      urls.addAll(fetched.values);
      for (final entry in fetched.entries) {
        await _setCached(entry.key, entry.value);
      }
    }

    return urls;
  }

  static Future<Map<String, String>> _fetch(
    String topicId,
    List<String> uuids,
  ) async {
    if (_cache.containsKey(topicId)) {
      return _cache[topicId]!.future;
    }

    final completer = Completer<Map<String, String>>();
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
      final cmsCoursePlanTopicLocationMediasResult = await payload.find(
        CmsCoursePlanTopicLocationMedia.slug,
        CmsCoursePlanTopicLocationMedia.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final media = Map.fromEntries(
        cmsCoursePlanTopicLocationMediasResult.docs
            .map((e) => MapEntry(e.id, e.url!)),
      );
      completer.complete(media);
      return media;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(topicId);
    }
  }
}
