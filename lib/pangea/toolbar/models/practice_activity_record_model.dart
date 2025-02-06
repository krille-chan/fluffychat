// record the options that the user selected
// note that this is not the same as the correct answer
// the user might have selected multiple options before
// finding the answer

import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';

class PracticeActivityRecordModel {
  final String? question;
  late List<ActivityRecordResponse> responses;

  PracticeActivityRecordModel({
    required this.question,
    List<ActivityRecordResponse>? responses,
  }) {
    if (responses == null) {
      this.responses = List<ActivityRecordResponse>.empty(growable: true);
    } else {
      this.responses = responses;
    }
  }

  factory PracticeActivityRecordModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PracticeActivityRecordModel(
      question: json['question'] as String,
      responses: (json['responses'] as List)
          .map(
            (e) => ActivityRecordResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'responses': responses.map((e) => e.toJson()).toList(),
    };
  }

  /// get the latest response index according to the response timeStamp
  /// sort the responses by timestamp and get the index of the last response
  ActivityRecordResponse? get latestResponse {
    if (responses.isEmpty) {
      return null;
    }
    responses.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return responses[responses.length - 1];
  }

  bool hasTextResponse(String text) {
    return responses.any((element) => element.text == text);
  }

  void addResponse({
    String? text,
    Uint8List? audioBytes,
    Uint8List? imageBytes,
    required double score,
  }) {
    try {
      responses.add(
        ActivityRecordResponse(
          text: text,
          audioBytes: audioBytes,
          imageBytes: imageBytes,
          timestamp: DateTime.now(),
          score: score,
        ),
      );
    } catch (e) {
      debugger(when: kDebugMode);
    }
  }

  void clearResponses() {
    responses.clear();
  }

  /// Returns a list of [OneConstructUse] objects representing the uses of the practice activity.
  ///
  /// The [practiceActivity] parameter is the parent event, representing the activity itself.
  /// The [metadata] parameter is the metadata for the construct use, used if the record event isn't available.
  ///
  /// The method iterates over the [responses] to get [OneConstructUse] objects for each
  List<OneConstructUse> usesForAllResponses(
    PracticeActivityModel practiceActivity,
    ConstructUseMetaData metadata,
  ) =>
      responses
          .toSet()
          .expand(
            (response) => response.toUses(practiceActivity, metadata),
          )
          .toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeActivityRecordModel &&
        other.question == question &&
        other.responses.length == responses.length &&
        List.generate(
          responses.length,
          (index) => responses[index] == other.responses[index],
        ).every((element) => element);
  }

  @override
  int get hashCode => question.hashCode ^ responses.hashCode;
}

class ActivityRecordResponse {
  // the user's response
  // has nullable string, nullable audio bytes, nullable image bytes, and timestamp
  final String? text;
  final Uint8List? audioBytes;
  final Uint8List? imageBytes;
  final DateTime timestamp;
  final double score;

  ActivityRecordResponse({
    this.text,
    this.audioBytes,
    this.imageBytes,
    required this.score,
    required this.timestamp,
  });

  //TODO - differentiate into different activity types
  ConstructUseTypeEnum useType(ActivityTypeEnum aType) {
    switch (aType) {
      case ActivityTypeEnum.wordMeaning:
        return score > 0
            ? ConstructUseTypeEnum.corPA
            : ConstructUseTypeEnum.incPA;
      case ActivityTypeEnum.wordFocusListening:
        return score > 0
            ? ConstructUseTypeEnum.corWL
            : ConstructUseTypeEnum.incWL;
      case ActivityTypeEnum.emoji:
        return ConstructUseTypeEnum.em;
      case ActivityTypeEnum.lemmaId:
        return score > 0
            ? ConstructUseTypeEnum.corL
            : ConstructUseTypeEnum.incL;
      case ActivityTypeEnum.morphId:
        return score > 0
            ? ConstructUseTypeEnum.corM
            : ConstructUseTypeEnum.incM;
      case ActivityTypeEnum.hiddenWordListening:
        return score > 0
            ? ConstructUseTypeEnum.corHWL
            : ConstructUseTypeEnum.incHWL;
      case ActivityTypeEnum.messageMeaning:
        return score > 0
            ? ConstructUseTypeEnum.corMM
            : ConstructUseTypeEnum.incMM;
    }
  }

  // for each target construct create a OneConstructUse object
  List<OneConstructUse> toUses(
    PracticeActivityModel practiceActivity,
    ConstructUseMetaData metadata,
  ) {
    if (practiceActivity.tgtConstructs.isEmpty ||
        practiceActivity.targetTokens == null) {
      return [];
    }

    // if the emoji is already set, don't give points
    // IMPORTANT: This assumes that scoring is happening before saving of the user's emoji choice.
    if (practiceActivity.activityType == ActivityTypeEnum.emoji &&
        practiceActivity.targetTokens?.first.getEmoji() != null) {
      return [];
    }

    switch (practiceActivity.activityType) {
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.lemmaId:
        final token = practiceActivity.targetTokens!.first;
        return [
          OneConstructUse(
            lemma: token.lemma.text,
            form: token.text.content,
            constructType: ConstructTypeEnum.vocab,
            useType: useType(practiceActivity.activityType),
            metadata: metadata,
            category: token.pos,
          ),
        ];
      case ActivityTypeEnum.messageMeaning:
        return practiceActivity.targetTokens!
            .expand(
              (t) => t.allUses(
                useType(practiceActivity.activityType),
                metadata,
              ),
            )
            .toList();
      case ActivityTypeEnum.hiddenWordListening:
        return practiceActivity.targetTokens!
            .map(
              (token) => OneConstructUse(
                lemma: token.lemma.text,
                form: token.text.content,
                constructType: ConstructTypeEnum.vocab,
                useType: useType(practiceActivity.activityType),
                metadata: metadata,
                category: token.pos,
              ),
            )
            .toList();
      case ActivityTypeEnum.morphId:
        return practiceActivity.tgtConstructs
            .map(
              (c) => OneConstructUse(
                lemma: c.lemma,
                form: practiceActivity.targetTokens!.first.text.content,
                constructType: c.type,
                useType: useType(practiceActivity.activityType),
                metadata: metadata,
                category: c.category,
              ),
            )
            .toList();
    }
  }

  factory ActivityRecordResponse.fromJson(Map<String, dynamic> json) {
    return ActivityRecordResponse(
      text: json['text'] as String?,
      audioBytes: json['audio'] as Uint8List?,
      imageBytes: json['image'] as Uint8List?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      // this has a default of 1 to make this backwards compatible
      // score was added later and is not present in all records
      // currently saved to Matrix
      score: json['score'] ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'audio': audioBytes,
      'image': imageBytes,
      'timestamp': timestamp.toIso8601String(),
      'score': score.toInt(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityRecordResponse &&
        other.text == text &&
        other.audioBytes == audioBytes &&
        other.imageBytes == imageBytes &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      text.hashCode ^
      audioBytes.hashCode ^
      imageBytes.hashCode ^
      timestamp.hashCode;
}
