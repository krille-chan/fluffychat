import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_request.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'course_plans_repo.dart';

mixin CoursePlanProvider<T extends StatefulWidget> on State<T> {
  bool loadingCourse = true;
  Object? courseError;

  bool loadingTopics = false;
  Object? topicError;

  Map<String, Object?> activityErrors = {};

  CoursePlanModel? course;

  Future<void> _initStorage() async {
    final futures = [
      GetStorage.init("course_storage"),
      GetStorage.init("course_activity_storage"),
      GetStorage.init("course_location_media_storage"),
      GetStorage.init("course_location_storage"),
      GetStorage.init("course_media_storage"),
      GetStorage.init("course_topic_storage"),
    ];

    await Future.wait(futures);
  }

  Future<void> loadCourse(String courseId) async {
    await _initStorage();
    setState(() {
      loadingCourse = true;
      courseError = null;
      course = null;
    });

    try {
      course = await CoursePlansRepo.get(
        GetLocalizedCoursesRequest(
          coursePlanIds: [courseId],
          l1: MatrixState.pangeaController.languageController.activeL1Code()!,
        ),
      );
    } catch (e) {
      courseError = e;
    } finally {
      if (mounted) setState(() => loadingCourse = false);
    }
  }

  Future<void> loadTopics() async {
    setState(() {
      loadingTopics = true;
      topicError = null;
    });

    try {
      if (course == null) {
        throw Exception("Course is null");
      }

      final courseFutures = <Future>[
        course!.fetchMediaUrls(),
        course!.fetchTopics(),
      ];
      await Future.wait(courseFutures);
      await _loadTopicsMedia();
    } catch (e) {
      topicError = e;
    } finally {
      if (mounted) setState(() => loadingTopics = false);
    }
  }

  Future<void> _loadTopicsMedia() async {
    final List<Future> futures = [];
    if (course == null) return;
    for (final topicId in course!.topicIds) {
      final topic = course!.loadedTopics[topicId];
      if (topic != null) {
        futures.add(topic.fetchLocationMedia());
      }
    }
    await Future.wait(futures);
  }

  Future<void> loadActivity(String topicId) async {
    setState(() {
      activityErrors[topicId] = null;
    });

    try {
      final topic = course?.loadedTopics[topicId];
      if (topic == null) {
        throw Exception("Topic is null");
      }
      await topic.fetchActivities();
    } catch (e) {
      activityErrors[topicId] = e;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> loadAllActivities() async {
    if (course == null) return;

    final futures = <Future>[];
    for (final topicId in course!.topicIds) {
      futures.add(loadActivity(topicId));
    }
    await Future.wait(futures);
  }
}
