import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan from the CMS API
class CmsCoursePlan {
  final String id;
  final String title;
  final String description;
  final String cefrLevel;
  final String l1; // Language of instruction
  final String l2; // Target language
  final JoinField? coursePlanMedia;
  final JoinField? coursePlanModules;
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
    this.coursePlanModules,
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
      coursePlanModules: JoinField.fromJson(json['coursePlanModules']),
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
      'coursePlanModules': coursePlanModules?.toJson(),
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
