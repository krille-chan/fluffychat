import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

mixin CourseSearchProvider<T extends StatefulWidget> on State<T> {
  bool loading = true;
  Object? error;

  List<CoursePlanModel> courses = [];

  LanguageLevelTypeEnum? languageLevelFilter;
  LanguageModel? instructionLanguageFilter;
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
      languageOfInstructions: instructionLanguageFilter,
      cefrLevel: languageLevelFilter,
    );
  }

  void setLanguageLevelFilter(LanguageLevelTypeEnum? level) {
    languageLevelFilter = level;
    _loadCourses();
  }

  void setInstructionLanguageFilter(LanguageModel? language) {
    instructionLanguageFilter = language;
    _loadCourses();
  }

  void setTargetLanguageFilter(LanguageModel? language) {
    targetLanguageFilter = language;
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });
      courses = await CoursePlansRepo.search(filter: _filter);
    } catch (e, s) {
      debugPrint("Failed to load courses: $e\n$s");
      error = e;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}
