import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/course_info_batch_request.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_media/course_media_response.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_repo.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_translation_request.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/widgets/matrix.dart';

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

  final DateTime updatedAt;
  final DateTime createdAt;

  CoursePlanModel({
    required this.targetLanguage,
    required this.languageOfInstructions,
    required this.cefrLevel,
    required this.title,
    required this.description,
    required this.uuid,
    required this.topicIds,
    required this.mediaIds,
    required this.updatedAt,
    required this.createdAt,
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
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get topicListComplete => topicIds.length == loadedTopics.length;

  Map<String, CourseTopicModel> get loadedTopics => CourseTopicRepo.getCached(
        TranslateTopicRequest(
          topicIds: topicIds,
          l1: MatrixState.pangeaController.languageController.activeL1Code()!,
        ),
      ).topics;

  Future<Map<String, CourseTopicModel>> fetchTopics() async {
    final resp = await CourseTopicRepo.get(
      TranslateTopicRequest(
        topicIds: topicIds,
        l1: MatrixState.pangeaController.languageController.activeL1Code()!,
      ),
      uuid,
    );
    return resp.topics;
  }

  bool get mediaListComplete =>
      mediaIds.length == loadedMediaUrls.mediaUrls.length;
  CourseMediaResponse get loadedMediaUrls => CourseMediaRepo.getCached(
        CourseInfoBatchRequest(
          batchId: uuid,
          uuids: mediaIds,
        ),
      );
  Future<CourseMediaResponse> fetchMediaUrls() => CourseMediaRepo.get(
        CourseInfoBatchRequest(
          batchId: uuid,
          uuids: mediaIds,
        ),
      );
  String? get imageUrl => loadedMediaUrls.mediaUrls.isEmpty
      ? loadedTopics.values
          .lastWhereOrNull((topic) => topic.imageUrl != null)
          ?.imageUrl
      : "${Environment.cmsApi}${loadedMediaUrls.mediaUrls.first}";
}
