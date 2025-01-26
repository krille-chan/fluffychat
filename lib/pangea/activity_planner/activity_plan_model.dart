import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';

class ActivityPlanModel {
  final ActivityPlanRequest req;
  final String title;
  final String learningObjective;
  final String instructions;
  final List<Vocab> vocab;
  String? bookmarkId;

  ActivityPlanModel({
    required this.req,
    required this.title,
    required this.learningObjective,
    required this.instructions,
    required this.vocab,
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
}
