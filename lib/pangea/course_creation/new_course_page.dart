import 'package:fluffychat/pangea/course_creation/new_course_view.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:flutter/material.dart';

class NewCourse extends StatefulWidget {
  final String? spaceId;
  const NewCourse({
    super.key,
    this.spaceId,
  });

  @override
  State<NewCourse> createState() => NewCourseController();
}

class NewCourseController extends State<NewCourse> {
  bool loading = true;
  Object? error;

  List<CoursePlanModel> courses = [];

  LanguageLevelTypeEnum? languageLevelFilter;
  LanguageModel? instructionLanguageFilter;
  LanguageModel? targetLanguageFilter;

  @override
  void initState() {
    super.initState();
    _loadCourses();
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
      setState(() => loading = true);
      courses = await CoursePlansRepo.search(filter: _filter);
    } catch (e) {
      error = e;
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => NewCourseView(this);
}
