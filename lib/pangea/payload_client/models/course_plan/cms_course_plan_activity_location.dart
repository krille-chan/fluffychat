import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan activity location from the CMS API
class CmsCoursePlanActivityLocation {
  static const String slug = "course-plan-activity-locations";
  final String id;
  final String name;
  // [longitude, latitude] - minItems: 2, maxItems: 2
  final List<double>? coordinates;
  final JoinField? coursePlanActivityLocationMedia;
  final List<String> coursePlanActivities;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanActivityLocation({
    required this.id,
    required this.name,
    this.coordinates,
    this.coursePlanActivityLocationMedia,
    required this.coursePlanActivities,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanActivityLocation.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanActivityLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
      coursePlanActivityLocationMedia:
          json['coursePlanActivityLocationMedia'] != null
              ? JoinField.fromJson(json['coursePlanActivityLocationMedia'])
              : null,
      coursePlanActivities: List<String>.from(json['coursePlanActivities']),
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
      'name': name,
      'coordinates': coordinates,
      'coursePlanActivities': coursePlanActivities,
      'coursePlanActivityLocationMedia':
          coursePlanActivityLocationMedia?.toJson(),
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
