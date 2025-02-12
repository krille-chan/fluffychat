import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/audio_encoding_enum.dart';

const int thresholdForGreen = 80;

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

class STTToken {
  final PangeaToken token;
  final Duration? startTime;
  final Duration? endTime;
  final int? confidence;

  STTToken({
    required this.token,
    this.startTime,
    this.endTime,
    this.confidence,
  });

  int get offset => token.text.offset;

  int get length => token.text.length;

  Color color(BuildContext context) {
    // turning off the color coding for now
    // whisper doesn't include word-level confidence
    // if (confidence == null) {
    return Theme.of(context).colorScheme.onSurface;
    // }
    // if (confidence! > thresholdForGreen) {
    //   return AppConfig.success;
    // }
    // return AppConfig.warning;
  }

  factory STTToken.fromJson(Map<String, dynamic> json) {
    // debugPrint('STTToken.fromJson: $json');
    return STTToken(
      token: PangeaToken.fromJson(json['token']),
      startTime: json['start_time'] != null
          ? Duration(milliseconds: (json['start_time'] * 1000).round())
          : null,
      endTime: json['end_time'] != null
          ? Duration(milliseconds: (json['end_time'] * 1000).round())
          : null,
      confidence: json['confidence'],
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token.toJson(),
        "start_time": startTime?.inMilliseconds,
        "end_time": endTime?.inMilliseconds,
        "confidence": confidence,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! STTToken) return false;

    return token == other.token &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        confidence == other.confidence;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      token.hashCode,
      startTime.hashCode,
      endTime.hashCode,
      confidence.hashCode,
    ]);
  }
}

class Transcript {
  final String text;
  final int confidence;
  final List<STTToken> sttTokens;
  final String langCode;
  final int? wordsPerHr;

  Transcript({
    required this.text,
    required this.confidence,
    required this.sttTokens,
    required this.langCode,
    required this.wordsPerHr,
  });

  /// Returns the number of words per minute rounded to one decimal place.
  double? get wordsPerMinute => wordsPerHr != null ? wordsPerHr! / 60 : null;

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        text: json['transcript'],
        confidence: json['confidence'] <= 100
            ? json['confidence']
            : json['confidence'] / 100,
        sttTokens: (json['stt_tokens'] as List)
            .map((e) => STTToken.fromJson(e))
            .toList(),
        langCode: json['lang_code'],
        wordsPerHr: json['words_per_hr'],
      );

  Map<String, dynamic> toJson() => {
        "transcript": text,
        "confidence": confidence,
        "stt_tokens": sttTokens.map((e) => e.toJson()).toList(),
        "lang_code": langCode,
        "words_per_hr": wordsPerHr,
      };

  Color color(BuildContext context) {
    if (confidence > thresholdForGreen) {
      return AppConfig.success;
    }
    return AppConfig.warning;
  }
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

class SpeechToTextModel {
  final List<SpeechToTextResult> results;

  SpeechToTextModel({
    required this.results,
  });

  Transcript get transcript => results.first.transcripts.first;

  String get langCode => results.first.transcripts.first.langCode;

  factory SpeechToTextModel.fromJson(Map<String, dynamic> json) =>
      SpeechToTextModel(
        results: (json['results'] as List)
            .map((e) => SpeechToTextResult.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "results": results.map((e) => e.toJson()).toList(),
      };
}
