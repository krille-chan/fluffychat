import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_translation_request.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_translation_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseTopicRepo {
  static final Map<String, Completer<TranslateTopicResponse>> _cache = {};
  static final GetStorage _storage = GetStorage('course_topic_storage');

  static Future<TranslateTopicResponse> get(
    TranslateTopicRequest request,
    String batchId,
  ) async {
    await _storage.initStorage;
    final topics = getCached(request).topics;

    final toFetch =
        request.topicIds.where((uuid) => !topics.containsKey(uuid)).toList();

    if (toFetch.isNotEmpty) {
      final fetchedTopics = await _fetch(
        TranslateTopicRequest(
          topicIds: toFetch,
          l1: request.l1,
        ),
        batchId,
      );
      topics.addAll(fetchedTopics.topics);
      await _setCached(
        fetchedTopics,
        request.l1,
      );
    }

    return TranslateTopicResponse(topics: topics);
  }

  static Future<TranslateTopicResponse> translate(
    TranslateTopicRequest request,
  ) async {
    final Requests req = Requests(
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.getLocalizedTopic,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to translate topic. Status code: ${res.statusCode}",
      );
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));

    final response = TranslateTopicResponse.fromJson(decodedBody);

    return response;
  }

  static Future<TranslateTopicResponse> _fetch(
    TranslateTopicRequest request,
    String batchId,
  ) async {
    if (_cache.containsKey(batchId)) {
      return _cache[batchId]!.future;
    }

    final completer = Completer<TranslateTopicResponse>();
    _cache[batchId] = completer;

    try {
      final response = await translate(request);
      completer.complete(response);
      return response;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _cache.remove(batchId);
    }
  }

  static TranslateTopicResponse getCached(
    TranslateTopicRequest request,
  ) {
    final Map<String, CourseTopicModel> topics = {};
    for (final uuid in request.topicIds) {
      final cacheKey = "${uuid}_${request.l1}";
      final json = _storage.read(cacheKey);
      if (json != null) {
        try {
          final topic = CourseTopicModel.fromJson(
            Map<String, dynamic>.from(json),
          );
          topics[uuid] = topic;
        } catch (e) {
          _storage.remove(cacheKey);
        }
      }
    }

    return TranslateTopicResponse(topics: topics);
  }

  static Future<void> _setCached(
    TranslateTopicResponse response,
    String l1,
  ) async {
    final List<Future> futures = [];
    for (final entry in response.topics.entries) {
      futures.add(
        _storage.write(
          "${entry.key}_$l1",
          entry.value.toJson(),
        ),
      );
    }
    await Future.wait(futures);
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }
}
