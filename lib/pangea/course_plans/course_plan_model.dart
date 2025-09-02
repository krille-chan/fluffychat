import 'package:fluffychat/pangea/activity_generator/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_activity_media.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_media.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic.dart';
import 'package:fluffychat/pangea/payload_client/models/course_plan/cms_course_plan_topic_location.dart';

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

  List<String> get activityIds => activities.map((e) => e.activityId).toList();
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
        if (activity.activityId == activityID) {
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

  factory CoursePlanModel.fromCmsDocs(
    CmsCoursePlan cmsCoursePlan,
    List<CmsCoursePlanMedia>? cmsCoursePlanMedias,
    List<CmsCoursePlanTopic>? cmsCoursePlanTopics,
    List<CmsCoursePlanTopicLocation>? cmsCoursePlanTopicLocations,
    List<CmsCoursePlanActivity>? cmsCoursePlanActivities,
    List<CmsCoursePlanActivityMedia>? cmsCoursePlanActivityMedias,
  ) {
    // fetch topics
    List<Topic>? topics;
    if (cmsCoursePlanTopics != null) {
      for (final topic in cmsCoursePlanTopics) {
        // select locations of current topic
        List<CmsCoursePlanTopicLocation>? topicLocations;
        if (cmsCoursePlanTopicLocations != null) {
          for (final location in cmsCoursePlanTopicLocations) {
            if (location.coursePlanTopics.contains(topic.id)) {
              topicLocations ??= [];
              topicLocations.add(location);
            }
          }
        }

        // select activities of current topic
        List<CmsCoursePlanActivity>? topicActivities;
        if (cmsCoursePlanActivities != null) {
          for (final activity in cmsCoursePlanActivities) {
            if (activity.coursePlanTopics.contains(topic.id)) {
              topicActivities ??= [];
              topicActivities.add(activity);
            }
          }
        }

        List<ActivityPlanModel>? activityPlans;
        if (topicActivities != null) {
          for (final activity in topicActivities) {
            // select media of current activity
            List<CmsCoursePlanActivityMedia>? activityMedias;
            if (cmsCoursePlanActivityMedias != null) {
              for (final media in cmsCoursePlanActivityMedias) {
                if (media.coursePlanActivities.contains(activity.id)) {
                  activityMedias ??= [];
                  activityMedias.add(media);
                }
              }
            }

            final Map<String, ActivityRole> roles = {};
            for (final role in activity.roles) {
              roles[role.id] = ActivityRole(
                id: role.id,
                name: role.name,
                avatarUrl: role.avatarUrl,
                goal: role.goal,
              );
            }

            activityPlans ??= [];
            activityPlans.add(
              ActivityPlanModel(
                req: ActivityPlanRequest(
                  topic: "",
                  mode: "",
                  objective: "",
                  media: MediaEnum.nan,
                  cefrLevel: activity.cefrLevel,
                  languageOfInstructions: activity.l1,
                  targetLanguage: activity.l2,
                  numberOfParticipants: activity.roles.length,
                ),
                activityId: activity.id,
                title: activity.title,
                description: activity.description,
                learningObjective: activity.learningObjective,
                instructions: activity.instructions,
                vocab: activity.vocabs
                    .map((v) => Vocab(lemma: v.lemma, pos: v.pos))
                    .toList(),
                roles: roles,
                imageURL: activityMedias != null && activityMedias.isNotEmpty
                    ? '${Environment.cmsApi}${activityMedias.first.url}'
                    : null,
              ),
            );
          }
        }

        topics ??= [];
        topics.add(
          Topic(
            uuid: topic.id,
            title: topic.title,
            description: topic.description,
            location: topicLocations != null && topicLocations.isNotEmpty
                ? topicLocations.first.name
                : "Any",
            activities: activityPlans,
          ),
        );
      }
    }

    return CoursePlanModel(
      uuid: cmsCoursePlan.id,
      title: cmsCoursePlan.title,
      description: cmsCoursePlan.description,
      cefrLevel:
          LanguageLevelTypeEnumExtension.fromString(cmsCoursePlan.cefrLevel),
      languageOfInstructions: cmsCoursePlan.l1,
      targetLanguage: cmsCoursePlan.l2,
      topics: topics,
      imageUrl: cmsCoursePlanMedias != null && cmsCoursePlanMedias.isNotEmpty
          ? '${Environment.cmsApi}${cmsCoursePlanMedias.first.url}'
          : null,
    );
  }
}
