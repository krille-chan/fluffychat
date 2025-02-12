import 'package:collection/collection.dart';

class MorphologicalTag {
  final String code;
  final String l2Title;
  final String l1Title;
  final String l1Description;

  MorphologicalTag({
    required this.code,
    required this.l2Title,
    required this.l1Title,
    required this.l1Description,
  });

  factory MorphologicalTag.fromJson(Map<String, dynamic> json) {
    return MorphologicalTag(
      code: json['code'],
      l2Title: json['l2_title'],
      l1Title: json['l1_title'],
      l1Description: json['l1_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'l2_title': l2Title,
      'l1_title': l1Title,
      'l1_description': l1Description,
    };
  }
}

class MorphologicalFeature {
  final String code;
  final String l2Title;
  final String l1Title;
  final List<MorphologicalTag> tags;

  MorphologicalFeature({
    required this.code,
    required this.l2Title,
    required this.l1Title,
    required this.tags,
  });

  factory MorphologicalFeature.fromJson(Map<String, dynamic> json) {
    final tagsFromJson = json['tags'] as List;
    final List<MorphologicalTag> tagsList =
        tagsFromJson.map((tag) => MorphologicalTag.fromJson(tag)).toList();

    return MorphologicalFeature(
      code: json['code'],
      l2Title: json['l2_title'],
      l1Title: json['l1_title'],
      tags: tagsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'l2_title': l2Title,
      'l1_title': l1Title,
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }

  MorphologicalTag? getTagByCode(String code) {
    return tags.firstWhereOrNull(
      (tag) => tag.code.toLowerCase() == code.toLowerCase(),
    );
  }
}

class MorphInfoResponse {
  final String userL1;
  final String userL2;
  final List<MorphologicalFeature> features;

  MorphInfoResponse({
    required this.userL1,
    required this.userL2,
    required this.features,
  });

  factory MorphInfoResponse.fromJson(Map<String, dynamic> json) {
    final featuresFromJson = json['features'] as List;
    final List<MorphologicalFeature> featuresList = featuresFromJson
        .map((feature) => MorphologicalFeature.fromJson(feature))
        .toList();

    return MorphInfoResponse(
      userL1: json['user_l1'],
      userL2: json['user_l2'],
      features: featuresList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_l1': userL1,
      'user_l2': userL2,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }

  MorphologicalFeature? getFeatureByCode(String code) {
    return features.firstWhereOrNull(
      (feature) => feature.code.toLowerCase() == code.toLowerCase(),
    );
  }
}
