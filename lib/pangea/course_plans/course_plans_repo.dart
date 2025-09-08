import 'dart:async';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan.dart';
import 'package:fluffychat/pangea/payload_client/payload_repo.dart';

class CourseFilter {
  final LanguageModel? targetLanguage;
  final LanguageModel? languageOfInstructions;
  final LanguageLevelTypeEnum? cefrLevel;

  CourseFilter({
    this.targetLanguage,
    this.languageOfInstructions,
    this.cefrLevel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseFilter &&
        other.targetLanguage == targetLanguage &&
        other.languageOfInstructions == languageOfInstructions &&
        other.cefrLevel == cefrLevel;
  }

  @override
  int get hashCode =>
      targetLanguage.hashCode ^
      languageOfInstructions.hashCode ^
      cefrLevel.hashCode;
}

class CoursePlansRepo {
  static final Map<String, Completer<CoursePlanModel>> cache = {};
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

  static Future<void> _setCached(CoursePlanModel coursePlan) async {
    await _courseStorage.write(coursePlan.uuid, coursePlan.toJson());
  }

  static String _searchKey(CourseFilter filter) {
    return "search_${filter.hashCode.toString()}";
  }

  static List<CoursePlanModel>? _getCachedSearchResults(
    CourseFilter filter,
  ) {
    final jsonList = _courseStorage.read(_searchKey(filter));
    if (jsonList != null) {
      try {
        final ids = List<String>.from(jsonList);
        final coursePlans = ids
            .map((id) => _getCached(id))
            .whereType<CoursePlanModel>()
            .toList();

        return coursePlans;
      } catch (e) {
        _courseStorage.remove(_searchKey(filter));
      }
    }
    return null;
  }

  static Future<void> _setCachedSearchResults(
    CourseFilter filter,
    List<CoursePlanModel> coursePlans,
  ) async {
    final jsonList = coursePlans.map((e) => e.uuid).toList();
    for (final plan in coursePlans) {
      _setCached(plan);
    }
    await _courseStorage.write(_searchKey(filter), jsonList);
  }

  static Future<CoursePlanModel?> get(String id) async {
    final cached = _getCached(id);
    if (cached != null) {
      return cached;
    }

    if (cache.containsKey(id)) {
      return cache[id]!.future;
    }

    final completer = Completer<CoursePlanModel>();
    cache[id] = completer;

    try {
      final cmsCoursePlan = await PayloadRepo.payload.findById(
        "course-plans",
        id,
        CmsCoursePlan.fromJson,
      );

      final coursePlan = cmsCoursePlan.toCoursePlanModel();
      await _setCached(coursePlan);
      completer.complete(coursePlan);
      return coursePlan;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      cache.remove(id);
    }
  }

  static Future<List<CoursePlanModel>> search({CourseFilter? filter}) async {
    final cached = _getCachedSearchResults(filter ?? CourseFilter());
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final Map<String, dynamic> where = {};
    if (filter != null) {
      int numberOfFilter = 0;
      if (filter.cefrLevel != null) {
        numberOfFilter += 1;
      }
      if (filter.languageOfInstructions != null) {
        numberOfFilter += 1;
      }
      if (filter.targetLanguage != null) {
        numberOfFilter += 1;
      }
      if (numberOfFilter > 1) {
        where["and"] = [];
        if (filter.cefrLevel != null) {
          where["and"].add({
            "cefrLevel": {"equals": filter.cefrLevel!.string},
          });
        }
        if (filter.languageOfInstructions != null) {
          where["and"].add({
            "languageOfInstructions": {
              "equals": filter.languageOfInstructions!.langCode,
            },
          });
        }
        if (filter.targetLanguage != null) {
          where["and"].add({
            "targetLanguage": {"equals": filter.targetLanguage!.langCode},
          });
        }
      } else if (numberOfFilter == 1) {
        if (filter.cefrLevel != null) {
          where["cefrLevel"] = {"equals": filter.cefrLevel!.string};
        }
        if (filter.languageOfInstructions != null) {
          where["languageOfInstructions"] = {
            "equals": filter.languageOfInstructions!.langCode,
          };
        }
        if (filter.targetLanguage != null) {
          where["targetLanguage"] = {"equals": filter.targetLanguage!.langCode};
        }
      }
    }

    final result = await PayloadRepo.payload.find(
      CmsCoursePlan.slug,
      CmsCoursePlan.fromJson,
      page: 1,
      limit: 10,
      where: where,
    );

    final coursePlans = result.docs
        .map(
          (cmsCoursePlan) => cmsCoursePlan.toCoursePlanModel(),
        )
        .toList();

    await _setCachedSearchResults(
      filter ?? CourseFilter(),
      coursePlans,
    );

    return coursePlans;
  }
}
