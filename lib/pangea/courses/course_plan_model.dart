import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';

/// Represents a topic in the course planner response.
class Topic {
  final String title;
  final String description;
  final String location;
  final String uuid;
  final String? imageUrl;

  final List<ActivityPlanModel> activities;

  Topic({
    required this.title,
    required this.description,
    this.location = "Unknown",
    required this.uuid,
    List<ActivityPlanModel>? activities,
    this.imageUrl,
  }) : activities = activities ?? [];

  /// Deserialize from JSON
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String? ?? "Unknown",
      uuid: json['uuid'] as String,
      activities: (json['activities'] as List<dynamic>?)
              ?.map(
                (e) => ActivityPlanModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'uuid': uuid,
      'activities': activities.map((e) => e.toJson()).toList(),
      'image_url': imageUrl,
    };
  }

  List<String> get activityIds => activities.map((e) => e.bookmarkId).toList();
}

/// Represents a course plan in the course planner response.
class CoursePlanModel {
  final String targetLanguage;
  final String languageOfInstructions;
  final LanguageLevelTypeEnum cefrLevel;

  final String title;
  final String description;

  final String uuid;

  final List<Topic> topics;
  final String? imageUrl;

  CoursePlanModel({
    required this.targetLanguage,
    required this.languageOfInstructions,
    required this.cefrLevel,
    required this.title,
    required this.description,
    required this.uuid,
    List<Topic>? topics,
    this.imageUrl,
  }) : topics = topics ?? [];

  int get activities =>
      topics.map((t) => t.activities.length).reduce((a, b) => a + b);

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
    for (final topic in topics) {
      for (final activity in topic.activities) {
        if (activity.bookmarkId == activityID) {
          return topic.uuid;
        }
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
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
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
      'topics': topics.map((e) => e.toJson()).toList(),
      'image_url': imageUrl,
    };
  }
}
