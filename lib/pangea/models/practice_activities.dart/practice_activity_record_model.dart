// record the options that the user selected
// note that this is not the same as the correct answer
// the user might have selected multiple options before
// finding the answer
import 'dart:developer';

import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

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

  ConstructUseTypeEnum get useType => latestResponse?.score != null
      ? (latestResponse!.score > 0
          ? ConstructUseTypeEnum.corPA
          : ConstructUseTypeEnum.incPA)
      : ConstructUseTypeEnum.unk;

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
      debugger();
    }
  }

  /// Returns a list of [OneConstructUse] objects representing the uses of the practice activity.
  ///
  /// The [practiceActivity] parameter is the parent event, representing the activity itself.
  /// The [event] parameter is the record event, if available.
  /// The [metadata] parameter is the metadata for the construct use, used if the record event isn't available.
  ///
  /// If [event] and [metadata] are both null, an empty list is returned.
  ///
  /// The method iterates over the [tgtConstructs] of the [practiceActivity] and creates a [OneConstructUse] object for each construct.
  List<OneConstructUse> uses(
    PracticeActivityEvent practiceActivity, {
    Event? event,
    ConstructUseMetaData? metadata,
  }) {
    try {
      if (event == null && metadata == null) {
        debugger(when: kDebugMode);
        return [];
      }

      final List<OneConstructUse> uses = [];
      final List<ConstructIdentifier> constructIds =
          practiceActivity.practiceActivity.tgtConstructs;

      for (final construct in constructIds) {
        uses.add(
          OneConstructUse(
            lemma: construct.lemma,
            constructType: construct.type,
            useType: useType,
            //TODO - find form of construct within the message
            //this is related to the feature of highlighting the target construct in the message
            form: construct.lemma,
            metadata: ConstructUseMetaData(
              roomId: event?.roomId ?? metadata!.roomId,
              eventId: practiceActivity.parentMessageId,
              timeStamp: event?.originServerTs ?? metadata!.timeStamp,
            ),
          ),
        );
      }

      return uses;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: event?.toJson());
      rethrow;
    }
  }

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
      'score': score,
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
