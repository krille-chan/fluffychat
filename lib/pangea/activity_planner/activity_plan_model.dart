import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class ActivityPlanModel {
  final String bookmarkId;
  final ActivityPlanRequest req;
  final String title;
  final String learningObjective;
  final String instructions;
  final List<Vocab> vocab;
  final String? imageURL;
  final DateTime? endAt;
  final Duration? duration;
  final Map<String, ActivityRole> roles;

  ActivityPlanModel({
    required this.req,
    required this.title,
    required this.learningObjective,
    required this.instructions,
    required this.vocab,
    required this.roles,
    this.imageURL,
    this.endAt,
    this.duration,
  }) : bookmarkId =
            "${title.hashCode ^ learningObjective.hashCode ^ instructions.hashCode ^ imageURL.hashCode ^ vocab.map((v) => v.hashCode).reduce((a, b) => a ^ b)}";

  ActivityPlanModel copyWith({
    String? title,
    String? learningObjective,
    String? instructions,
    List<Vocab>? vocab,
    String? imageURL,
    DateTime? endAt,
    Duration? duration,
    Map<String, ActivityRole>? roles,
  }) {
    return ActivityPlanModel(
      req: req,
      title: title ?? this.title,
      learningObjective: learningObjective ?? this.learningObjective,
      instructions: instructions ?? this.instructions,
      vocab: vocab ?? this.vocab,
      imageURL: imageURL ?? this.imageURL,
      endAt: endAt ?? this.endAt,
      duration: duration ?? this.duration,
      roles: roles ?? this.roles,
    );
  }

  factory ActivityPlanModel.fromJson(Map<String, dynamic> json) {
    final req =
        ActivityPlanRequest.fromJson(json[ModelKey.activityPlanRequest]);

    Map<String, ActivityRole> roles;
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
    } else {
      roles = {};
      for (int i = 0; i < req.numberOfParticipants; i++) {
        roles['role_$i'] = ActivityRole(
          id: 'role_$i',
          name: 'Participant',
          avatarUrl: null,
        );
      }
    }

    return ActivityPlanModel(
      imageURL: json[ModelKey.activityPlanImageURL],
      instructions: json[ModelKey.activityPlanInstructions],
      req: req,
      title: json[ModelKey.activityPlanTitle],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelKey.activityPlanBookmarkId: bookmarkId,
      ModelKey.activityPlanImageURL: imageURL,
      ModelKey.activityPlanInstructions: instructions,
      ModelKey.activityPlanRequest: req.toJson(),
      ModelKey.activityPlanTitle: title,
      ModelKey.activityPlanLearningObjective: learningObjective,
      ModelKey.activityPlanVocab: vocab.map((vocab) => vocab.toJson()).toList(),
      ModelKey.activityPlanEndAt: endAt?.toIso8601String(),
      ModelKey.activityPlanDuration: {
        'days': duration?.inDays ?? 0,
        'hours': duration?.inHours.remainder(24) ?? 0,
        'minutes': duration?.inMinutes.remainder(60) ?? 0,
      },
      'roles': roles.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  /// activity content displayed nicely in markdown
  /// use target emoji for learning objective
  /// use step emoji for instructions
  String get markdown {
    String markdown = '''🎯 $learningObjective \n🪜 $instructions \n\n📖''';
    // cycle through vocab with index
    for (var i = 0; i < vocab.length; i++) {
      // if the lemma appears more than once in the vocab list, show the pos
      // vocab is a wrapped list of string, separated by commas
      final v = vocab[i];
      final bool showPos =
          vocab.where((vocab) => vocab.lemma == v.lemma).length > 1;
      markdown +=
          '${v.lemma}${showPos ? ' (${v.pos})' : ''}${i + 1 < vocab.length ? ', ' : ''}';
    }
    return markdown;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityPlanModel &&
        other.req == req &&
        other.title == title &&
        other.learningObjective == learningObjective &&
        other.instructions == instructions &&
        listEquals(other.vocab, vocab) &&
        other.imageURL == imageURL;
  }

  @override
  int get hashCode =>
      req.hashCode ^
      title.hashCode ^
      learningObjective.hashCode ^
      instructions.hashCode ^
      Object.hashAll(vocab) ^
      imageURL.hashCode;
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
  final String? avatarUrl;

  ActivityRole({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ActivityRole.fromJson(Map<String, dynamic> json) {
    return ActivityRole(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }
}
