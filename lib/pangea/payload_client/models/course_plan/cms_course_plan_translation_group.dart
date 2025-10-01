import 'package:fluffychat/pangea/payload_client/join_field.dart';
import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents a course plan translation group from the CMS API
class CmsCoursePlanTranslationGroup {
  static const String slug = "course-plans";
  final String id;
  final JoinField? coursePlans;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String updatedAt;
  final String createdAt;

  CmsCoursePlanTranslationGroup({
    required this.id,
    this.coursePlans,
    this.createdBy,
    this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CmsCoursePlanTranslationGroup.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanTranslationGroup(
      id: json['id'],
      coursePlans: JoinField.fromJson(json['coursePlans']),
      createdBy: PolymorphicRelationship.fromJson(json['createdBy']),
      updatedBy: PolymorphicRelationship.fromJson(json['updatedBy']),
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coursePlans': coursePlans?.toJson(),
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
