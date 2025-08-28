import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity_media.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_media.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_module.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_module_location.dart';
import 'package:fluffychat/pangea/payload_client/payload_client.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
  static final GetStorage _courseStorage = GetStorage("course_storage");

  static final PayloadClient payload = PayloadClient(
    baseUrl: Environment.cmsApi,
    accessToken: MatrixState.pangeaController.userController.accessToken,
  );

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

    final cmsCoursePlan = await payload.findById(
      "course-plans",
      id,
      CmsCoursePlan.fromJson,
    );

    final coursePlan = await _fromCmsCoursePlan(cmsCoursePlan);
    await _setCached(coursePlan);
    return coursePlan;
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

    final result = await payload.find(
      "course-plans",
      CmsCoursePlan.fromJson,
      page: 1,
      limit: 10,
      where: where,
    );

    final coursePlans = await Future.wait(
      result.docs.map(
        (cmsCoursePlan) => _fromCmsCoursePlan(
          cmsCoursePlan,
        ),
      ),
    );

    await _setCachedSearchResults(
      filter ?? CourseFilter(),
      coursePlans,
    );

    return coursePlans;
  }

  static Future<CoursePlanModel> _fromCmsCoursePlan(
    CmsCoursePlan cmsCoursePlan,
  ) async {
    final medias = await _getMedia(cmsCoursePlan);
    final modules = await _getModules(cmsCoursePlan);
    final locations = await _getModuleLocations(modules ?? []);
    final activities = await _getModuleActivities(modules ?? []);
    final activityMedias = await _getActivityMedia(activities ?? []);
    return CoursePlanModel.fromCmsDocs(
      cmsCoursePlan,
      medias,
      modules,
      locations,
      activities,
      activityMedias,
    );
  }

  static Future<List<CmsCoursePlanMedia>?> _getMedia(
    CmsCoursePlan cmsCoursePlan,
  ) async {
    final docs = cmsCoursePlan.coursePlanMedia?.docs;
    if (docs == null || docs.isEmpty) return null;

    final where = {
      "id": {"in": docs.join(",")},
    };
    final limit = docs.length;
    final cmsCoursePlanMediaResult = await payload.find(
      "course-plan-media",
      CmsCoursePlanMedia.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return cmsCoursePlanMediaResult.docs;
  }

  static Future<List<CmsCoursePlanModule>?> _getModules(
    CmsCoursePlan cmsCoursePlan,
  ) async {
    final docs = cmsCoursePlan.coursePlanModules?.docs;
    if (docs == null || docs.isEmpty) return null;

    final where = {
      "id": {"in": docs.join(",")},
    };
    final limit = docs.length;
    final cmsCourseModulesResult = await payload.find(
      "course-plan-modules",
      CmsCoursePlanModule.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return cmsCourseModulesResult.docs;
  }

  static Future<List<CmsCoursePlanModuleLocation>?> _getModuleLocations(
    List<CmsCoursePlanModule> modules,
  ) async {
    final List<String> locations = [];
    for (final module in modules) {
      if (module.coursePlanModuleLocations?.docs != null) {
        locations.addAll(module.coursePlanModuleLocations!.docs!);
      }
    }
    if (locations.isEmpty) return null;

    final where = {
      "id": {"in": locations.join(",")},
    };
    final limit = locations.length;
    final cmsCoursePlanModuleLocationsResult = await payload.find(
      "course-plan-module-locations",
      CmsCoursePlanModuleLocation.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return cmsCoursePlanModuleLocationsResult.docs;
  }

  static Future<List<CmsCoursePlanActivity>?> _getModuleActivities(
    List<CmsCoursePlanModule> module,
  ) async {
    final List<String> activities = [];
    for (final mod in module) {
      if (mod.coursePlanActivities?.docs != null) {
        activities.addAll(mod.coursePlanActivities!.docs!);
      }
    }
    if (activities.isEmpty) return null;

    final where = {
      "id": {"in": activities.join(",")},
    };
    final limit = activities.length;
    final cmsCoursePlanActivitiesResult = await payload.find(
      "course-plan-activities",
      CmsCoursePlanActivity.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return cmsCoursePlanActivitiesResult.docs;
  }

  static Future<List<CmsCoursePlanActivityMedia>?> _getActivityMedia(
    List<CmsCoursePlanActivity> activity,
  ) async {
    final List<String> mediaIds = [];
    for (final act in activity) {
      if (act.coursePlanActivityMedia?.docs != null) {
        mediaIds.addAll(act.coursePlanActivityMedia!.docs!);
      }
    }
    if (mediaIds.isEmpty) return null;

    final where = {
      "id": {"in": mediaIds.join(",")},
    };
    final limit = mediaIds.length;
    final cmsCoursePlanActivityMediasResult = await payload.find(
      "course-plan-activity-medias",
      CmsCoursePlanActivityMedia.fromJson,
      where: where,
      limit: limit,
      page: 1,
      sort: "createdAt",
    );
    return cmsCoursePlanActivityMediasResult.docs;
  }
}
