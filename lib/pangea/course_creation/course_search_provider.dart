import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_filter.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plans_repo.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

mixin CourseSearchProvider<T extends StatefulWidget> on State<T> {
  bool loading = true;
  Object? error;

  Map<String, CoursePlanModel> courses = {};
  LanguageModel? targetLanguageFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _loadCourses(),
    );
  }

  CourseFilter get _filter {
    return CourseFilter(
      targetLanguage: targetLanguageFilter,
    );
  }

  void setTargetLanguageFilter(LanguageModel? language, {bool reload = true}) {
    if (targetLanguageFilter?.langCodeShort == language?.langCodeShort) return;
    setState(() => targetLanguageFilter = language);
    if (reload) _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });
      final resp = await CoursePlansRepo.searchByFilter(filter: _filter);
      courses = resp.coursePlans;
      if (courses.isEmpty) {
        ErrorHandler.logError(
          e: "No courses found",
          data: {
            'filter': _filter.toJson(),
          },
        );
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'filter': _filter.toJson(),
        },
      );
      error = e;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}
