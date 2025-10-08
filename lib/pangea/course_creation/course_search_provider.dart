import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

mixin CourseSearchProvider<T extends StatefulWidget> on State<T> {
  bool loading = true;
  Object? error;

  List<CoursePlanModel> courses = [];
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

  void setTargetLanguageFilter(LanguageModel? language, {reload = true}) {
    targetLanguageFilter = language;
    if (reload) _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });
      courses = await CoursePlansRepo.searchByFilter(filter: _filter);
    } catch (e, s) {
      debugPrint("Failed to load courses: $e\n$s");
      error = e;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}
