import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan from the CMS API
class CmsCoursePlan {
  static const String slug = "course-plans";
  final String id;
  final String title;
  final String description;
  final String cefrLevel;
  final String l1; // Language of instruction
  final String l2; // Target language
  final JoinField? coursePlanMedia;
  final JoinField? coursePlanTopics;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlan({
    required this.id,
    required this.title,
    required this.description,
    required this.cefrLevel,
    required this.l1,
    required this.l2,
    this.coursePlanMedia,
    this.coursePlanTopics,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlan.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      cefrLevel: json['cefrLevel'],
      l1: json['l1'],
      l2: json['l2'],
      coursePlanMedia: JoinField.fromJson(json['coursePlanMedia']),
      coursePlanTopics: JoinField.fromJson(json['coursePlanTopics']),
      createdBy: PolymorphicRelationship.fromJson(json['createdBy']),
      updatedBy: PolymorphicRelationship.fromJson(json['updatedBy']),
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cefrLevel': cefrLevel,
      'l1': l1,
      'l2': l2,
      'coursePlanMedia': coursePlanMedia?.toJson(),
      'coursePlanTopics': coursePlanTopics?.toJson(),
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  CoursePlanModel toCoursePlanModel() {
    return CoursePlanModel(
      uuid: id,
      targetLanguage: l2,
      languageOfInstructions: l1,
      cefrLevel: LanguageLevelTypeEnumExtension.fromString(cefrLevel),
      title: title,
      description: description,
      mediaIds: coursePlanMedia?.docs ?? [],
      topicIds: coursePlanTopics?.docs ?? [],
    );
  }
}
