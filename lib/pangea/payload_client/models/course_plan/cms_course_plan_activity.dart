import 'package:fluffychat/pangea/activity_generator/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan activity role
class CmsCoursePlanActivityRole {
  final String id;
  final String name;
  final String goal;
  final String? avatarUrl;

  CmsCoursePlanActivityRole({
    required this.id,
    required this.name,
    required this.goal,
    this.avatarUrl,
  });

  factory CmsCoursePlanActivityRole.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanActivityRole(
      id: json['id'] as String,
      name: json['name'] as String,
      goal: json['goal'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'avatarUrl': avatarUrl,
    };
  }

  ActivityRole toActivityRole() {
    return ActivityRole(
      id: id,
      name: name,
      goal: goal,
      avatarUrl: avatarUrl,
    );
  }
}

/// Represents vocabulary in a course plan activity
class CmsCoursePlanVocab {
  final String lemma;
  final String pos;
  final String? id;

  CmsCoursePlanVocab({
    required this.lemma,
    required this.pos,
    this.id,
  });

  factory CmsCoursePlanVocab.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanVocab(
      lemma: json['lemma'] as String,
      pos: json['pos'] as String,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'pos': pos,
      'id': id,
    };
  }
}

/// Represents a course plan activity from the CMS API
class CmsCoursePlanActivity {
  static const String slug = "course-plan-activities";

  final String id;
  final String title;
  final String description;
  final String learningObjective;
  final String instructions;
  final String l1; // Language of instruction
  final String l2; // Target language
  final String mode;
  final LanguageLevelTypeEnum cefrLevel;
  final List<CmsCoursePlanActivityRole> roles;
  final List<CmsCoursePlanVocab> vocabs;
  final JoinField? coursePlanActivityMedia;
  final List<String> coursePlanTopics;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.learningObjective,
    required this.instructions,
    required this.l1,
    required this.l2,
    required this.mode,
    required this.cefrLevel,
    required this.roles,
    required this.vocabs,
    required this.coursePlanActivityMedia,
    required this.coursePlanTopics,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanActivity.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      learningObjective: json['learningObjective'] as String,
      instructions: json['instructions'] as String,
      l1: json['l1'] as String,
      l2: json['l2'] as String,
      mode: json['mode'] as String,
      cefrLevel: LanguageLevelTypeEnumExtension.fromString(
        json['cefrLevel'] as String,
      ),
      roles: (json['roles'] as List<dynamic>)
          .map(
            (role) => CmsCoursePlanActivityRole.fromJson(
              role as Map<String, dynamic>,
            ),
          )
          .toList(),
      vocabs: (json['vocabs'] as List<dynamic>)
          .map(
            (vocab) =>
                CmsCoursePlanVocab.fromJson(vocab as Map<String, dynamic>),
          )
          .toList(),
      coursePlanActivityMedia:
          JoinField.fromJson(json['coursePlanActivityMedia']),
      coursePlanTopics: List<String>.from(json['coursePlanTopics']),
      createdBy: json['createdBy'] != null
          ? PolymorphicRelationship.fromJson(json['createdBy'])
          : null,
      updatedBy: json['updatedBy'] != null
          ? PolymorphicRelationship.fromJson(json['updatedBy'])
          : null,
      updatedAt: json['updatedAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'learningObjective': learningObjective,
      'instructions': instructions,
      'l1': l1,
      'l2': l2,
      'mode': mode,
      'cefrLevel': cefrLevel.string,
      'roles': roles.map((role) => role.toJson()).toList(),
      'vocabs': vocabs.map((vocab) => vocab.toJson()).toList(),
      'coursePlanActivityMedia': coursePlanActivityMedia?.toJson(),
      'coursePlanTopics': coursePlanTopics,
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  ActivityPlanModel toActivityPlanModel(String? imageUrl) {
    return ActivityPlanModel(
      req: ActivityPlanRequest(
        topic: "",
        mode: mode,
        objective: "",
        media: MediaEnum.nan,
        cefrLevel: cefrLevel,
        languageOfInstructions: l1,
        targetLanguage: l2,
        numberOfParticipants: roles.length,
      ),
      activityId: id,
      title: title,
      description: description,
      learningObjective: learningObjective,
      instructions: instructions,
      vocab: vocabs.map((v) => Vocab(lemma: v.lemma, pos: v.pos)).toList(),
      roles: Map.fromEntries(
        roles.map((role) => MapEntry(role.id, role.toActivityRole())),
      ),
      imageURL: imageUrl,
    );
  }
}
