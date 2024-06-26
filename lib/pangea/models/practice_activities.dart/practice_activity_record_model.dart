// record the options that the user selected
// note that this is not the same as the correct answer
// the user might have selected multiple options before
// finding the answer
import 'dart:developer';
import 'dart:typed_data';

class PracticeActivityRecordModel {
  final String? question;
  late List<ActivityResponse> responses;

  PracticeActivityRecordModel({
    required this.question,
    List<ActivityResponse>? responses,
  }) {
    if (responses == null) {
      this.responses = List<ActivityResponse>.empty(growable: true);
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
          .map((e) => ActivityResponse.fromJson(e as Map<String, dynamic>))
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
  String? get latestResponse {
    if (responses.isEmpty) {
      return null;
    }
    responses.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return responses[responses.length - 1].text;
  }

  void addResponse({
    String? text,
    Uint8List? audioBytes,
    Uint8List? imageBytes,
  }) {
    try {
      responses.add(
        ActivityResponse(
          text: text,
          audioBytes: audioBytes,
          imageBytes: imageBytes,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      debugger();
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

class ActivityResponse {
  // the user's response
  // has nullable string, nullable audio bytes, nullable image bytes, and timestamp
  final String? text;
  final Uint8List? audioBytes;
  final Uint8List? imageBytes;
  final DateTime timestamp;

  ActivityResponse({
    this.text,
    this.audioBytes,
    this.imageBytes,
    required this.timestamp,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      text: json['text'] as String?,
      audioBytes: json['audio'] as Uint8List?,
      imageBytes: json['image'] as Uint8List?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'audio': audioBytes,
      'image': imageBytes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityResponse &&
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
