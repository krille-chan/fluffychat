import 'dart:convert';

import 'package:fluffychat/pangea/enum/audio_encoding_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

class SpeechToTextAudioConfigModel {
  final AudioEncodingEnum encoding;
  final int sampleRateHertz;
  final bool enableWordConfidence;
  final bool enableAutomaticPunctuation;
  final String userL1;
  final String userL2;

  SpeechToTextAudioConfigModel({
    required this.encoding,
    required this.userL1,
    required this.userL2,
    this.sampleRateHertz = 16000,
    this.enableWordConfidence = true,
    this.enableAutomaticPunctuation = true,
  });

  Map<String, dynamic> toJson() => {
        "encoding": encoding.value,
        "sample_rate_hertz": sampleRateHertz,
        "user_l1": userL1,
        "user_l2": userL2,
        "enable_word_confidence": enableWordConfidence,
        "enable_automatic_punctuation": enableAutomaticPunctuation,
      };
}

class SpeechToTextRequestModel {
  final Uint8List audioContent;
  final SpeechToTextAudioConfigModel config;
  final Event? audioEvent;

  SpeechToTextRequestModel({
    required this.audioContent,
    required this.config,
    this.audioEvent,
  });

  Map<String, dynamic> toJson() => {
        "audio_content": base64Encode(audioContent),
        "config": config.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SpeechToTextRequestModel) return false;

    return listEquals(audioContent, other.audioContent) &&
        config == other.config;
  }

  @override
  int get hashCode {
    final bytesSample =
        audioContent.length > 10 ? audioContent.sublist(0, 10) : audioContent;
    return Object.hashAll([
      Object.hashAll(bytesSample),
      config.hashCode,
    ]);
  }
}

class WordInfo {
  final String word;
  final Duration? startTime;
  final Duration? endTime;
  final int? confidence;

  WordInfo({
    required this.word,
    this.startTime,
    this.endTime,
    this.confidence,
  });

  factory WordInfo.fromJson(Map<String, dynamic> json) => WordInfo(
        word: json['word'],
        startTime: json['start_time'] != null
            ? Duration(milliseconds: json['start_time'])
            : null,
        endTime: json['end_time'] != null
            ? Duration(milliseconds: json['end_time'])
            : null,
        confidence: json['confidence'],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "start_time": startTime?.inMilliseconds,
        "end_time": endTime?.inMilliseconds,
        "confidence": confidence,
      };
}

class Transcript {
  final String transcript;
  final int confidence;
  final List<WordInfo> words;

  Transcript({
    required this.transcript,
    required this.confidence,
    required this.words,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        transcript: json['transcript'],
        confidence: json['confidence'].toDouble(),
        words:
            (json['words'] as List).map((e) => WordInfo.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "transcript": transcript,
        "confidence": confidence,
        "words": words.map((e) => e.toJson()).toList(),
      };
}

class SpeechToTextResult {
  final List<Transcript> transcripts;

  SpeechToTextResult({required this.transcripts});

  factory SpeechToTextResult.fromJson(Map<String, dynamic> json) =>
      SpeechToTextResult(
        transcripts: (json['transcripts'] as List)
            .map((e) => Transcript.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "transcripts": transcripts.map((e) => e.toJson()).toList(),
      };
}

class SpeechToTextResponseModel {
  final List<SpeechToTextResult> results;

  SpeechToTextResponseModel({
    required this.results,
  });

  factory SpeechToTextResponseModel.fromJson(Map<String, dynamic> json) =>
      SpeechToTextResponseModel(
        results: (json['results'] as List)
            .map((e) => SpeechToTextResult.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "results": results.map((e) => e.toJson()).toList(),
      };
}
