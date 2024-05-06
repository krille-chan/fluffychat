import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    if (confidence == null || confidence! > 80) {
      return Theme.of(context).brightness == Brightness.dark
          ? AppConfig.primaryColorLight
          : AppConfig.primaryColor;
    }
    if (confidence! > 50) {
      return const Color.fromARGB(255, 184, 142, 43);
    }
    return Colors.red;
  }

  factory STTToken.fromJson(Map<String, dynamic> json) => STTToken(
        token: PangeaToken.fromJson(json['token']),
        startTime: json['start_time'] != null
            ? Duration(milliseconds: json['start_time'])
            : null,
        endTime: json['end_time'] != null
            ? Duration(milliseconds: json['end_time'])
            : null,
        confidence: json['confidence'],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "start_time": startTime?.inMilliseconds,
        "end_time": endTime?.inMilliseconds,
        "confidence": confidence,
      };
}

class Transcript {
  final String text;
  final int confidence;
  final List<STTToken> sttTokens;
  final String langCode;

  Transcript({
    required this.text,
    required this.confidence,
    required this.sttTokens,
    required this.langCode,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) => Transcript(
        text: json['transcript'],
        confidence: json['confidence'].toDouble(),
        sttTokens: (json['stt_tokens'] as List)
            .map((e) => STTToken.fromJson(e))
            .toList(),
        langCode: json['lang_code'],
      );

  Map<String, dynamic> toJson() => {
        "transcript": text,
        "confidence": confidence,
        "stt_tokens": sttTokens.map((e) => e.toJson()).toList(),
        "lang_code": langCode,
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
