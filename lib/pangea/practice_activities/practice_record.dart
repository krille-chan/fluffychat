// record the options that the user selected
// note that this is not the same as the correct answer
// the user might have selected multiple options before
// finding the answer

import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';

class PracticeRecord {
  late DateTime createdAt;
  late List<ActivityRecordResponse> responses;

  PracticeRecord({
    List<ActivityRecordResponse>? responses,
    DateTime? timestamp,
  }) {
    createdAt = timestamp ?? DateTime.now();
    if (responses == null) {
      this.responses = List<ActivityRecordResponse>.empty(growable: true);
    } else {
      this.responses = responses;
    }
  }

  factory PracticeRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return PracticeRecord(
      responses: (json['responses'] as List)
          .map(
            (e) => ActivityRecordResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      timestamp: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responses': responses.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get completeResponses =>
      responses.where((element) => element.isCorrect).length;

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

  /// [target] needed for saving the record, little funky
  /// [cId] identifies the construct in the case of match activities which have multiple
  /// [text] is the user's response
  /// [audioBytes] is the user's audio response
  /// [imageBytes] is the user's image response
  /// [score] > 0 means correct, otherwise is incorrect
  void addResponse({
    required ConstructIdentifier cId,
    required PracticeTarget target,
    String? text,
    Uint8List? audioBytes,
    Uint8List? imageBytes,
    required double score,
  }) {
    try {
      if (text == null && audioBytes == null && imageBytes == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "No response data provided",
          data: {
            'cId': cId.toJson(),
            'text': text,
            'audioBytes': audioBytes,
            'imageBytes': imageBytes,
            'score': score,
          },
        );
        return;
      }
      responses.add(
        ActivityRecordResponse(
          cId: cId,
          text: text,
          audioBytes: audioBytes,
          imageBytes: imageBytes,
          timestamp: DateTime.now(),
          score: score,
        ),
      );

      PracticeRecordRepo.save(target, this);
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

    return other is PracticeRecord &&
        other.responses.length == responses.length &&
        List.generate(
          responses.length,
          (index) => responses[index] == other.responses[index],
        ).every((element) => element);
  }

  @override
  int get hashCode => responses.hashCode;
}

class ActivityRecordResponse {
  ConstructIdentifier cId;
  // the user's response
  // has nullable string, nullable audio bytes, nullable image bytes, and timestamp
  final String? text;
  final Uint8List? audioBytes;
  final Uint8List? imageBytes;
  final DateTime timestamp;
  final double score;

  ActivityRecordResponse({
    required this.cId,
    this.text,
    this.audioBytes,
    this.imageBytes,
    required this.score,
    required this.timestamp,
  });

  bool get isCorrect => score > 0;

  //TODO - differentiate into different activity types
  ConstructUseTypeEnum useType(ActivityTypeEnum aType) =>
      isCorrect ? aType.correctUse : aType.incorrectUse;

  // for each target construct create a OneConstructUse object
  List<OneConstructUse> toUses(
    PracticeActivityModel practiceActivity,
    ConstructUseMetaData metadata,
  ) {
    // if the emoji is already set, don't give points
    // IMPORTANT: This assumes that scoring is happening before saving of the user's emoji choice.
    if (practiceActivity.activityType == ActivityTypeEnum.emoji &&
        practiceActivity.targetTokens.first.getEmoji().isNotEmpty) {
      return [];
    }

    if (practiceActivity.targetTokens.isEmpty) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "null targetTokens in practice activity",
        data: practiceActivity.toJson(),
      );
      return [];
    }

    switch (practiceActivity.activityType) {
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.lemmaId:
        final token = practiceActivity.targetTokens.first;
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
        return practiceActivity.targetTokens
            .expand(
              (t) => t.allUses(
                useType(practiceActivity.activityType),
                metadata,
              ),
            )
            .toList();
      case ActivityTypeEnum.hiddenWordListening:
        return practiceActivity.targetTokens
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
        if (practiceActivity.morphFeature == null) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            m: "null morphFeature in morph activity",
            data: practiceActivity.toJson(),
          );
          return [];
        }
        return practiceActivity.targetTokens
            .map(
              (t) {
                final tag = t.getMorphTag(practiceActivity.morphFeature!);
                if (tag == null) {
                  debugger(when: kDebugMode);
                  ErrorHandler.logError(
                    m: "null tag in morph activity",
                    data: practiceActivity.toJson(),
                  );
                  return null;
                }
                return OneConstructUse(
                  lemma: tag,
                  form: practiceActivity.targetTokens.first.text.content,
                  constructType: ConstructTypeEnum.morph,
                  useType: useType(practiceActivity.activityType),
                  metadata: metadata,
                  category: practiceActivity.morphFeature!,
                );
              },
            )
            .where((c) => c != null)
            .cast<OneConstructUse>()
            .toList();
    }
  }

  factory ActivityRecordResponse.fromJson(Map<String, dynamic> json) {
    return ActivityRecordResponse(
      cId: ConstructIdentifier.fromJson(json['cId'] as Map<String, dynamic>),
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
      'cId': cId.toJson(),
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
        other.timestamp == timestamp &&
        other.score == score &&
        other.cId == cId;
  }

  @override
  int get hashCode =>
      text.hashCode ^
      audioBytes.hashCode ^
      imageBytes.hashCode ^
      timestamp.hashCode ^
      score.hashCode ^
      cId.hashCode;
}
