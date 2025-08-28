import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan module location from the CMS API
class CmsCoursePlanModuleLocation {
  final String id;
  final String name;
  // [longitude, latitude] - minItems: 2, maxItems: 2
  final List<double>? coordinates;
  final List<String> coursePlanModules;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanModuleLocation({
    required this.id,
    required this.name,
    this.coordinates,
    required this.coursePlanModules,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanModuleLocation.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanModuleLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
      coursePlanModules: List<String>.from(json['coursePlanModules']),
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
      'coursePlanModules': coursePlanModules,
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
