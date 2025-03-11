import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';

class ActivityPlanModel {
  final ActivityPlanRequest req;
  String title;
  String learningObjective;
  String instructions;
  List<Vocab> vocab;
  String? imageURL;
  String? bookmarkId;

  ActivityPlanModel({
    required this.req,
    required this.title,
    required this.learningObjective,
    required this.instructions,
    required this.vocab,
    this.imageURL,
    this.bookmarkId,
  });

  factory ActivityPlanModel.fromJson(Map<String, dynamic> json) {
    return ActivityPlanModel(
      req: ActivityPlanRequest.fromJson(json['req']),
      title: json['title'],
      learningObjective: json['learning_objective'],
      instructions: json['instructions'],
      vocab: List<Vocab>.from(
        json['vocab'].map((vocab) => Vocab.fromJson(vocab)),
      ),
      bookmarkId: json['bookmark_id'],
      imageURL: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'req': req.toJson(),
      'title': title,
      'learning_objective': learningObjective,
      'instructions': instructions,
      'vocab': vocab.map((vocab) => vocab.toJson()).toList(),
      'bookmark_id': bookmarkId,
      'image_url': imageURL,
    };
  }

  /// activity content displayed nicely in markdown
  /// use target emoji for learning objective
  /// use step emoji for instructions
  String get markdown {
    String markdown =
        ''' **$title** \n🎯 $learningObjective \n🪜 $instructions \n📖 ''';
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

  bool get isBookmarked {
    return bookmarkId != null;
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
        other.bookmarkId == bookmarkId;
  }

  @override
  int get hashCode =>
      req.hashCode ^
      title.hashCode ^
      learningObjective.hashCode ^
      instructions.hashCode ^
      Object.hashAll(vocab) ^
      bookmarkId.hashCode;
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
