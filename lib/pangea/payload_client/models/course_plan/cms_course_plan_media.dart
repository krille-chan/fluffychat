import 'package:fluffychat/pangea/payload_client/polymorphic_relationship.dart';

/// Represents course plan media from the CMS API
class CmsCoursePlanMedia {
  static const String slug = "course-plan-media";
  final String id;
  final String? alt;
  final List<String> coursePlans;
  final PolymorphicRelationship? createdBy;
  final PolymorphicRelationship? updatedBy;
  final String? prefix;
  final String updatedAt;
  final String createdAt;
  final String? url;
  final String? thumbnailURL;
  final String? filename;
  final String? mimeType;
  final int? filesize;
  final int? width;
  final int? height;
  final double? focalX;
  final double? focalY;

  CmsCoursePlanMedia({
    required this.id,
    this.alt,
    required this.coursePlans,
    this.createdBy,
    this.updatedBy,
    this.prefix,
    required this.updatedAt,
    required this.createdAt,
    this.url,
    this.thumbnailURL,
    this.filename,
    this.mimeType,
    this.filesize,
    this.width,
    this.height,
    this.focalX,
    this.focalY,
  });

  factory CmsCoursePlanMedia.fromJson(Map<String, dynamic> json) {
    return CmsCoursePlanMedia(
      id: json['id'],
      alt: json['alt'],
      coursePlans: List<String>.from(json['coursePlans'] as List),
      createdBy: json['createdBy'] != null
          ? PolymorphicRelationship.fromJson(json['createdBy'])
          : null,
      updatedBy: json['updatedBy'] != null
          ? PolymorphicRelationship.fromJson(json['updatedBy'])
          : null,
      prefix: json['prefix'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      url: json['url'],
      thumbnailURL: json['thumbnailURL'],
      filename: json['filename'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      width: json['width'],
      height: json['height'],
      focalX: json['focalX']?.toDouble(),
      focalY: json['focalY']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alt': alt,
      'coursePlans': coursePlans,
      'createdBy': createdBy?.toJson(),
      'updatedBy': updatedBy?.toJson(),
      'prefix': prefix,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'url': url,
      'thumbnailURL': thumbnailURL,
      'filename': filename,
      'mimeType': mimeType,
      'filesize': filesize,
      'width': width,
      'height': height,
      'focalX': focalX,
      'focalY': focalY,
    };
  }
}
