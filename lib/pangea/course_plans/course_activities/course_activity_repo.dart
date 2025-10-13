import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_translation_request.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_translation_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseActivityRepo {
  static final Map<String, Completer<TranslateActivityResponse>> _cache = {};
  static final GetStorage _storage = GetStorage('course_activity_storage');

  static Future<TranslateActivityResponse> get(
    TranslateActivityRequest request,
    String batchId,
  ) async {
    await _storage.initStorage;
    final activities = getCached(request).plans;

    final toFetch =
        request.activityIds.where((id) => !activities.containsKey(id)).toList();

    if (toFetch.isNotEmpty) {
      final fetchedActivities = await _fetch(request, batchId);
      activities.addAll(fetchedActivities.plans);
      await _setCached(fetchedActivities, request.l1);
    }

    return TranslateActivityResponse(plans: activities);
  }

  static Future<TranslateActivityResponse> translate(
    TranslateActivityRequest request,
  ) async {
    final Requests req = Requests(
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.getLocalizedActivity,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to translate activity: ${res.statusCode} ${res.body}",
      );
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));

    final response = TranslateActivityResponse.fromJson(decodedBody);

    return response;
  }

  static Future<TranslateActivityResponse> _fetch(
    TranslateActivityRequest request,
    String batchId,
  ) async {
    if (_cache.containsKey(batchId)) {
      return _cache[batchId]!.future;
    }

    final completer = Completer<TranslateActivityResponse>();
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

  static TranslateActivityResponse getCached(
    TranslateActivityRequest request,
  ) {
    final Map<String, ActivityPlanModel> activities = {};
    for (final id in request.activityIds) {
      final cacheKey = "${id}_${request.l1}";
      final sentActivityFeedback = sentFeedback[cacheKey];
      if (sentActivityFeedback != null &&
          DateTime.now().difference(sentActivityFeedback) >
              const Duration(minutes: 15)) {
        _storage.remove(cacheKey);
        _clearSentFeedback(cacheKey, request.l1);
        continue;
      }

      final json = _storage.read<Map<String, dynamic>>(cacheKey);
      if (json != null) {
        try {
          final activity = ActivityPlanModel.fromJson(json);
          activities[id] = activity;
        } catch (e) {
          // ignore invalid cached data
          _storage.remove(cacheKey);
        }
      }
    }

    return TranslateActivityResponse(plans: activities);
  }

  static Future<void> _setCached(
    TranslateActivityResponse activities,
    String l1,
  ) async {
    final List<Future> futures = [];
    for (final entry in activities.plans.entries) {
      final cacheKey = "${entry.key}_$l1";
      futures.add(_storage.write(cacheKey, entry.value.toJson()));
    }
    await Future.wait(futures);
  }

  static Future<void> clearCache() async {
    await _storage.erase();
  }

  static Map<String, DateTime> get sentFeedback {
    final entry = _storage.read("sent_feedback");
    if (entry != null && entry is Map<String, dynamic>) {
      try {
        return Map<String, DateTime>.from(
          entry.map((key, value) => MapEntry(key, DateTime.parse(value))),
        );
      } catch (e) {
        _storage.remove("sent_feedback");
      }
    }
    return {};
  }

  static Future<void> setSentFeedback(
    String activityId,
    String l1,
  ) async {
    final currentValue = sentFeedback;
    currentValue["${activityId}_$l1"] = DateTime.now();
    await _storage.write(
      "sent_feedback",
      currentValue.map((key, value) => MapEntry(key, value.toIso8601String())),
    );
  }

  static Future<void> _clearSentFeedback(
    String activityId,
    String l1,
  ) async {
    final currentValue = sentFeedback;
    currentValue.remove("${activityId}_$l1");
    await _storage.write(
      "sent_feedback",
      currentValue.map((key, value) => MapEntry(key, value.toIso8601String())),
    );
  }
}
