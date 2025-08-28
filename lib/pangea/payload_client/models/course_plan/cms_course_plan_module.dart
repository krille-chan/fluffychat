import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan module from the CMS API
class CmsCoursePlanModule {
  final String id;
  final String title;
  final String description;
  final JoinField? coursePlanActivities;
  final JoinField? coursePlanModuleLocations;
  final List<String> coursePlans;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanModule({
    required this.id,
    required this.title,
    required this.description,
    required this.coursePlanActivities,
    required this.coursePlanModuleLocations,
    required this.coursePlans,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanModule.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanModule(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coursePlanActivities: JoinField.fromJson(
        json['coursePlanActivities'],
      ),
      coursePlanModuleLocations: JoinField.fromJson(
        json['coursePlanModuleLocations'],
      ),
      coursePlans: List<String>.from(json['coursePlans']),
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
      'coursePlanActivities': coursePlanActivities?.toJson(),
      'coursePlanModuleLocations': coursePlanModuleLocations?.toJson(),
      'coursePlans': coursePlans,
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
