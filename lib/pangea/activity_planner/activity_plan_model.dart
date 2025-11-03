import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class ActivityPlanModel {
  final String activityId;

  final ActivityPlanRequest req;
  final String title;
  final String description;
  final String learningObjective;
  final String instructions;
  final List<Vocab> vocab;
  final String? _imageURL;
  final DateTime? endAt;
  final Duration? duration;
  final Map<String, ActivityRole>? _roles;
  final bool isDeprecatedModel;

  ActivityPlanModel({
    required this.req,
    required this.title,
    // TODO: when we bring back user's being able to make their own activity,
    // then this should be required
    String? description,
    required this.learningObjective,
    required this.instructions,
    required this.vocab,
    required this.activityId,
    Map<String, ActivityRole>? roles,
    String? imageURL,
    this.endAt,
    this.duration,
    this.isDeprecatedModel = false,
  })  : description = (description == null || description.isEmpty)
            ? learningObjective
            : description,
        _roles = roles,
        _imageURL = imageURL;

  String? get imageURL =>
      _imageURL != null ? "${Environment.cmsApi}$_imageURL" : null;

  Map<String, ActivityRole> get roles {
    if (_roles != null) return _roles!;
    final defaultRoles = <String, ActivityRole>{};
    for (int i = 0; i < req.numberOfParticipants; i++) {
      defaultRoles['role_$i'] = ActivityRole(
        id: 'role_$i',
        name: 'Participant',
        goal: learningObjective,
        avatarUrl: null,
      );
    }
    return defaultRoles;
  }

  factory ActivityPlanModel.fromJson(Map<String, dynamic> json) {
    final req =
        ActivityPlanRequest.fromJson(json[ModelKey.activityPlanRequest]);

    Map<String, ActivityRole>? roles;
    final roleContent = json['roles'];
    if (roleContent is Map<String, dynamic>) {
      roles = Map<String, ActivityRole>.from(
        json['roles'].map(
          (key, value) => MapEntry(
            key,
            ActivityRole.fromJson(value),
          ),
        ),
      );
    }

    final activityId = json[ModelKey.activityId] ?? json["bookmark_id"];
    return ActivityPlanModel(
      imageURL: json[ModelKey.activityPlanImageURL],
      instructions: json[ModelKey.activityPlanInstructions],
      req: req,
      title: json[ModelKey.activityPlanTitle],
      description: json[ModelKey.activityPlanDescription] ??
          json[ModelKey.activityPlanLearningObjective],
      learningObjective: json[ModelKey.activityPlanLearningObjective],
      vocab: List<Vocab>.from(
        json[ModelKey.activityPlanVocab].map((vocab) => Vocab.fromJson(vocab)),
      ),
      endAt: json[ModelKey.activityPlanEndAt] != null
          ? DateTime.parse(json[ModelKey.activityPlanEndAt])
          : null,
      duration: json[ModelKey.activityPlanDuration] != null
          ? Duration(
              days: json[ModelKey.activityPlanDuration]['days'] ?? 0,
              hours: json[ModelKey.activityPlanDuration]['hours'] ?? 0,
              minutes: json[ModelKey.activityPlanDuration]['minutes'] ?? 0,
            )
          : null,
      roles: roles,
      activityId: activityId,
      isDeprecatedModel: json["bookmark_id"] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelKey.activityId: activityId,
      ModelKey.activityPlanImageURL: _imageURL,
      ModelKey.activityPlanInstructions: instructions,
      ModelKey.activityPlanRequest: req.toJson(),
      ModelKey.activityPlanTitle: title,
      ModelKey.activityPlanDescription: description,
      ModelKey.activityPlanLearningObjective: learningObjective,
      ModelKey.activityPlanVocab: vocab.map((vocab) => vocab.toJson()).toList(),
      ModelKey.activityPlanEndAt: endAt?.toIso8601String(),
      ModelKey.activityPlanDuration: {
        'days': duration?.inDays ?? 0,
        'hours': duration?.inHours.remainder(24) ?? 0,
        'minutes': duration?.inMinutes.remainder(60) ?? 0,
      },
      'roles': _roles?.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  String get vocabString {
    final List<String> vocabList = [];
    String vocabString = "";
    // cycle through vocab with index
    for (var i = 0; i < vocab.length; i++) {
      // if the lemma appears more than once in the vocab list, show the pos
      // vocab is a wrapped list of string, separated by commas
      final v = vocab[i];
      final bool showPos =
          vocab.where((vocab) => vocab.lemma == v.lemma).length > 1;
      vocabString +=
          '${v.lemma}${showPos ? ' (${v.pos})' : ''}${i + 1 < vocab.length ? ', ' : ''}';
      vocabList.add("${v.lemma}${showPos ? ' (${v.pos})' : ''}");
    }
    return vocabString;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityPlanModel &&
        other.req == req &&
        other.title == title &&
        other.learningObjective == learningObjective &&
        other.instructions == instructions &&
        other.description == description &&
        listEquals(other.vocab, vocab) &&
        other._imageURL == _imageURL;
  }

  @override
  int get hashCode =>
      req.hashCode ^
      title.hashCode ^
      learningObjective.hashCode ^
      description.hashCode ^
      instructions.hashCode ^
      Object.hashAll(vocab) ^
      _imageURL.hashCode;
}

class Vocab {
  final String lemma;
  final String pos;

  Vocab({
    required this.lemma,
    required this.pos,
  });

  factory Vocab.fromJson(Map<String, dynamic> json) {
    return Vocab(
      lemma: json['lemma'],
      pos: json['pos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'pos': pos,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vocab && other.lemma == lemma && other.pos == pos;
  }

  @override
  int get hashCode => lemma.hashCode ^ pos.hashCode;
}

class ActivityRole {
  final String id;
  final String name;
  final String? goal;
  final String? avatarUrl;

  ActivityRole({
    required this.id,
    required this.name,
    required this.goal,
    this.avatarUrl,
  });

  factory ActivityRole.fromJson(Map<String, dynamic> json) {
    final urlContent = json['avatar_url'] as String?;
    String? avatarUrl;
    if (urlContent != null && urlContent.isNotEmpty) {
      avatarUrl = urlContent;
    }

    return ActivityRole(
      id: json['id'] as String,
      name: json['name'] as String,
      goal: json['goal'] as String?,
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'avatar_url': avatarUrl,
    };
  }
}
