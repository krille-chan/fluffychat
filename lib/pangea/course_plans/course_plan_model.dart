import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_repo.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';

/// Represents a course plan in the course planner response.
class CoursePlanModel {
  final String uuid;

  final String targetLanguage;
  final String languageOfInstructions;
  final LanguageLevelTypeEnum cefrLevel;

  final String title;
  final String description;

  final List<String> topicIds;
  final List<String> mediaIds;

  CoursePlanModel({
    required this.targetLanguage,
    required this.languageOfInstructions,
    required this.cefrLevel,
    required this.title,
    required this.description,
    required this.uuid,
    required this.topicIds,
    required this.mediaIds,
  });

  LanguageModel? get targetLanguageModel =>
      PLanguageStore.byLangCode(targetLanguage);

  LanguageModel? get baseLanguageModel =>
      PLanguageStore.byLangCode(languageOfInstructions);

  String get targetLanguageDisplay =>
      targetLanguageModel?.langCode.toUpperCase() ??
      targetLanguage.toUpperCase();

  String get baseLanguageDisplay =>
      baseLanguageModel?.langCode.toUpperCase() ??
      languageOfInstructions.toUpperCase();

  String? topicID(String activityID) {
    for (final topic in loadedTopics) {
      if (topic.activityIds.any((id) => id == activityID)) {
        return topic.uuid;
      }
    }
    return null;
  }

  int get totalActivities =>
      loadedTopics.fold(0, (sum, topic) => sum + topic.activityIds.length);

  ActivityPlanModel? activityById(String activityID) {
    for (final topic in loadedTopics) {
      final activity = topic.activityById(activityID);
      if (activity != null) {
        return activity;
      }
    }
    return null;
  }

  /// Deserialize from JSON
  factory CoursePlanModel.fromJson(Map<String, dynamic> json) {
    return CoursePlanModel(
      targetLanguage: json['target_language'] as String,
      languageOfInstructions: json['language_of_instructions'] as String,
      cefrLevel: LanguageLevelTypeEnumExtension.fromString(json['cefr_level']),
      title: json['title'] as String,
      description: json['description'] as String,
      uuid: json['uuid'] as String,
      topicIds: (json['topic_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      mediaIds: (json['media_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'target_language': targetLanguage,
      'language_of_instructions': languageOfInstructions,
      'cefr_level': cefrLevel.string,
      'title': title,
      'description': description,
      'uuid': uuid,
      'topic_ids': topicIds,
      'media_ids': mediaIds,
    };
  }

  bool get topicListComplete => topicIds.length == loadedTopics.length;
  List<CourseTopicModel> get loadedTopics => CourseTopicRepo.getSync(topicIds);
  Future<List<CourseTopicModel>> fetchTopics() =>
      CourseTopicRepo.get(uuid, topicIds);

  bool get mediaListComplete => mediaIds.length == loadedMediaUrls.length;
  List<String> get loadedMediaUrls => CourseMediaRepo.getSync(mediaIds);
  Future<List<String>> fetchMediaUrls() => CourseMediaRepo.get(uuid, mediaIds);
  String? get imageUrl => loadedMediaUrls.isEmpty
      ? loadedTopics
          .lastWhereOrNull((topic) => topic.imageUrl != null)
          ?.imageUrl
      : "${Environment.cmsApi}${loadedMediaUrls.first}";

  Future<void> init() async {
    final courseFutures = <Future>[
      fetchMediaUrls(),
      fetchTopics(),
    ];
    await Future.wait(courseFutures);

    final topicFutures = <Future>[];
    topicFutures.addAll(
      loadedTopics.map(
        (topic) => topic.fetchActivities(),
      ),
    );
    topicFutures.addAll(
      loadedTopics.map(
        (topic) => topic.fetchLocationMedia(),
      ),
    );
    await Future.wait(topicFutures);
  }
}
