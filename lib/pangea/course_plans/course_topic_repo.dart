import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseTopicRepo {
  static final Map<String, Completer<List<CourseTopicModel>>> _cache = {};
  static final GetStorage _storage = GetStorage('course_topic_storage');

  static List<CourseTopicModel> getSync(List<String> uuids) {
    final topics = <CourseTopicModel>[];

    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        topics.add(cached);
      }
    }

    return topics;
  }

  static Future<List<CourseTopicModel>> get(
    String courseId,
    List<String> uuids,
  ) async {
    final topics = <CourseTopicModel>[];
    final toFetch = <String>[];

    await _storage.initStorage;
    for (final uuid in uuids) {
      final cached = _getCached(uuid);
      if (cached != null) {
        topics.add(cached);
      } else {
        toFetch.add(uuid);
      }
    }

    if (toFetch.isNotEmpty) {
      final fetchedTopics = await _fetch(courseId, toFetch);
      topics.addAll(fetchedTopics);
      await _setCached(fetchedTopics);
    }

    return topics;
  }

  static CourseTopicModel? _getCached(String uuid) {
    final json = _storage.read(uuid);
    if (json != null) {
      try {
        return CourseTopicModel.fromJson(Map<String, dynamic>.from(json));
      } catch (e) {
        _storage.remove(uuid);
      }
    }
    return null;
  }

  static Future<void> _setCached(List<CourseTopicModel> topics) async {
    for (final topic in topics) {
      await _storage.write(topic.uuid, topic.toJson());
    }
  }

  static Future<List<CourseTopicModel>> _fetch(
    String courseId,
    List<String> uuids,
  ) async {
    if (_cache.containsKey(courseId)) {
      return _cache[courseId]!.future;
    }

    final completer = Completer<List<CourseTopicModel>>();
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
      final cmsCourseTopicsResult = await payload.find(
        CmsCoursePlanTopic.slug,
        CmsCoursePlanTopic.fromJson,
        where: where,
        limit: limit,
        page: 1,
        sort: "createdAt",
      );

      final topics = cmsCourseTopicsResult.docs.map((topic) {
        return topic.toCourseTopicModel();
      }).toList();

      completer.complete(topics);
      return topics;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(courseId);
    }
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }
}
