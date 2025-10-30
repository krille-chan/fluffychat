import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_locations/course_location_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_repo.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_filter.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_request.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_response.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CoursePlansRepo {
  static final Map<String, Completer<CoursePlanModel>> cache = {};
  static final GetStorage _courseStorage = GetStorage("course_storage");
  static const Duration cacheDuration = Duration(days: 1);

  static DateTime? get lastUpdated {
    final entry = _courseStorage.read("last_updated");
    if (entry != null && entry is String) {
      try {
        return DateTime.parse(entry);
      } catch (e) {
        _courseStorage.remove("last_updated");
      }
    }
    return null;
  }

  // TODO: Currently just getting one course plan at a time
  // Should take advantage of batch fetching
  static Future<CoursePlanModel> get(
    GetLocalizedCoursesRequest request,
  ) async {
    if (request.coursePlanIds.length != 1) {
      throw Exception("Get only supports single course plan ID");
    }

    await _courseStorage.initStorage;
    final cached = _getCached(request);
    if (cached != null) {
      return cached;
    }

    final uuid = request.coursePlanIds.first;
    if (cache.containsKey(uuid)) {
      return cache[uuid]!.future;
    }

    final completer = Completer<CoursePlanModel>();
    cache[uuid] = completer;

    try {
      final translation = await _fetch(request);
      final coursePlan = translation.coursePlans[uuid];
      if (coursePlan == null) {
        throw Exception("Course plan not found after translation");
      }

      await _setCached(coursePlan, uuid, request.l1);
      completer.complete(coursePlan);
      return coursePlan;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      cache.remove(uuid);
    }
  }

  static Future<GetLocalizedCoursesResponse> _fetch(
    GetLocalizedCoursesRequest request,
  ) async {
    final Requests req = Requests(
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.getLocalizedCourse,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        "Failed to translate course plan: ${res.statusCode} ${res.body}",
      );
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));

    final response = GetLocalizedCoursesResponse.fromJson(decodedBody);

    return response;
  }

  static Future<GetLocalizedCoursesResponse> search(
    GetLocalizedCoursesRequest request,
  ) async {
    await _courseStorage.initStorage;

    final missingIds = request.coursePlanIds
        .where(
          (id) => _courseStorage.read("${id}_${request.l1}") == null,
        )
        .toList();

    if (missingIds.isNotEmpty) {
      final searchResult = await _fetch(
        GetLocalizedCoursesRequest(
          coursePlanIds: missingIds,
          l1: request.l1,
        ),
      );

      await _setCachedBatch(
        searchResult,
        request.l1,
      );
    }

    return _getCachedBatch(request);
  }

  static Future<GetLocalizedCoursesResponse> searchByFilter({
    required CourseFilter filter,
  }) async {
    final PayloadClient payload = PayloadClient(
      baseUrl: Environment.cmsApi,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    // Run the search for the given filter, selecting only the course IDs
    final result = await payload.find(
      "course-plans",
      (json) => json["id"] as String,
      page: 1,
      limit: 10,
      where: filter.whereFilter,
      select: {"id": true},
    );

    return search(
      GetLocalizedCoursesRequest(
        coursePlanIds: result.docs,
        l1: MatrixState.pangeaController.languageController.activeL1Code()!,
      ),
    );
  }

  static CoursePlanModel? _getCached(
    GetLocalizedCoursesRequest request,
  ) {
    if (lastUpdated != null &&
        DateTime.now().difference(lastUpdated!) > cacheDuration) {
      clearCache();
      return null;
    }

    if (request.coursePlanIds.length != 1) {
      throw Exception("Get cached only supports single course plan ID");
    }

    final uuid = request.coursePlanIds.first;
    final cacheKey = "${uuid}_${request.l1}";
    final json = _courseStorage.read(cacheKey);
    if (json != null) {
      try {
        return CoursePlanModel.fromJson(json);
      } catch (e) {
        _courseStorage.remove(cacheKey);
      }
    }
    return null;
  }

  static GetLocalizedCoursesResponse _getCachedBatch(
    GetLocalizedCoursesRequest request,
  ) {
    if (lastUpdated != null &&
        DateTime.now().difference(lastUpdated!) > cacheDuration) {
      clearCache();
      return GetLocalizedCoursesResponse(coursePlans: {});
    }

    final Map<String, CoursePlanModel> courses = {};
    for (final uuid in request.coursePlanIds) {
      final cacheKey = "${uuid}_${request.l1}";
      final json = _courseStorage.read(cacheKey);
      if (json != null) {
        try {
          final course = CoursePlanModel.fromJson(
            Map<String, dynamic>.from(json),
          );
          courses[uuid] = course;
        } catch (e) {
          _courseStorage.remove(cacheKey);
        }
      }
    }

    return GetLocalizedCoursesResponse(coursePlans: courses);
  }

  static Future<void> _setCached(
    CoursePlanModel course,
    String courseId,
    String l1,
  ) async {
    if (lastUpdated == null) {
      await _courseStorage.write(
        "last_updated",
        DateTime.now().toIso8601String(),
      );
    }

    final cacheKey = "${courseId}_$l1";
    await _courseStorage.write(
      cacheKey,
      course.toJson(),
    );
  }

  static Future<void> _setCachedBatch(
    GetLocalizedCoursesResponse response,
    String l1,
  ) async {
    if (lastUpdated == null) {
      await _courseStorage.write(
        "last_updated",
        DateTime.now().toIso8601String(),
      );
    }

    final List<Future> futures = response.coursePlans.entries.map((entry) {
      final cacheKey = "${entry.key}_$l1";
      return _courseStorage.write(
        cacheKey,
        entry.value.toJson(),
      );
    }).toList();

    await Future.wait(futures);
  }

  static Future<void> clearCache() async {
    final List<Future> futures = [
      CourseActivityRepo.clearCache(),
      CourseLocationMediaRepo.clearCache(),
      CourseLocationRepo.clearCache(),
      CourseMediaRepo.clearCache(),
      CourseTopicRepo.clearCache(),
      _courseStorage.erase(),
    ];

    await Future.wait(futures);
  }
}
