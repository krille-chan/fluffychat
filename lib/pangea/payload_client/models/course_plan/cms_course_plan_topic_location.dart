import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan topic location from the CMS API
class CmsCoursePlanTopicLocation {
  static const String slug = "course-plan-topic-locations";
  final String id;
  final String name;
  // [longitude, latitude] - minItems: 2, maxItems: 2
  final List<double>? coordinates;
  final JoinField? coursePlanTopicLocationMedia;
  final List<String> coursePlanTopics;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanTopicLocation({
    required this.id,
    required this.name,
    this.coordinates,
    this.coursePlanTopicLocationMedia,
    required this.coursePlanTopics,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanTopicLocation.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanTopicLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
      coursePlanTopicLocationMedia: json['coursePlanTopicLocationMedia'] != null
          ? JoinField.fromJson(json['coursePlanTopicLocationMedia'])
          : null,
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
      'name': name,
      'coordinates': coordinates,
      'coursePlanTopics': coursePlanTopics,
      'coursePlanTopicLocationMedia': coursePlanTopicLocationMedia?.toJson(),
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
