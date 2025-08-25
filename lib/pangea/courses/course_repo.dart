import 'package:collection/collection.dart';
import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/courses/test_courses_json.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

class CourseFilter {
  final LanguageModel? targetLanguage;
  final LanguageModel? languageOfInstructions;
  final LanguageLevelTypeEnum? cefrLevel;

  CourseFilter({
    this.targetLanguage,
    this.languageOfInstructions,
    this.cefrLevel,
  });
}

class CourseRepo {
  static final GetStorage _courseStorage = GetStorage("course_storage");

  static CoursePlanModel? _getCached(String id) {
    final json = _courseStorage.read(id);
    if (json != null) {
      try {
        return CoursePlanModel.fromJson(json);
      } catch (e) {
        _courseStorage.remove(id);
      }
    }
    return null;
  }

  static List<CoursePlanModel> _getAllCached() {
    final keys = _courseStorage.getKeys();
    return keys
        .map((key) => _getCached(key))
        .whereType<CoursePlanModel>()
        .toList();
  }

  static Future<void> set(CoursePlanModel coursePlan) async {
    await _courseStorage.write(coursePlan.uuid, coursePlan.toJson());
  }

  static Future<CoursePlanModel?> get(String id) async {
    final cached = _getCached(id);
    if (cached != null) {
      return cached;
    }

    final resp = await search();
    return resp.firstWhereOrNull((course) => course.uuid == id);
  }

  static Future<List<CoursePlanModel>> search({CourseFilter? filter}) async {
    final cached = _getAllCached();
    if (cached.isNotEmpty) {
      return cached.filtered(filter);
    }

    final resp = (courseJson["courses"] as List<dynamic>)
        .map((json) => CoursePlanModel.fromJson(json))
        .whereType<CoursePlanModel>()
        .toList();

    for (final plan in resp) {
      set(plan);
    }

    return resp.filtered(filter);
  }
}

extension on List<CoursePlanModel> {
  List<CoursePlanModel> filtered(CourseFilter? filter) {
    return where((course) {
      final matchesTargetLanguage = filter?.targetLanguage == null ||
          course.targetLanguage.split("-").first ==
              filter?.targetLanguage?.langCodeShort;

      final matchesLanguageOfInstructions =
          filter?.languageOfInstructions == null ||
              course.languageOfInstructions.split("-").first ==
                  filter?.languageOfInstructions?.langCodeShort;

      final matchesCefrLevel =
          filter?.cefrLevel == null || course.cefrLevel == filter?.cefrLevel;

      return matchesTargetLanguage &&
          matchesLanguageOfInstructions &&
          matchesCefrLevel;
    }).toList();
  }
}
