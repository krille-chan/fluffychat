import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

enum PhoneticTranscriptionDelimEnum { sp, noSp }

extension PhoneticTranscriptionDelimEnumExt on PhoneticTranscriptionDelimEnum {
  String get value {
    switch (this) {
      case PhoneticTranscriptionDelimEnum.sp:
        return " ";
      case PhoneticTranscriptionDelimEnum.noSp:
        return "";
    }
  }

  static PhoneticTranscriptionDelimEnum fromString(String s) {
    switch (s) {
      case " ":
        return PhoneticTranscriptionDelimEnum.sp;
      case "":
        return PhoneticTranscriptionDelimEnum.noSp;
      default:
        return PhoneticTranscriptionDelimEnum.sp;
    }
  }
}

class PhoneticTranscriptionToken {
  final LanguageArc arc;
  final PangeaTokenText tokenL2;
  final PangeaTokenText phoneticL1Transcription;

  PhoneticTranscriptionToken({
    required this.arc,
    required this.tokenL2,
    required this.phoneticL1Transcription,
  });

  factory PhoneticTranscriptionToken.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscriptionToken(
      arc: LanguageArc.fromJson(json['arc'] as Map<String, dynamic>),
      tokenL2:
          PangeaTokenText.fromJson(json['token_l2'] as Map<String, dynamic>),
      phoneticL1Transcription: PangeaTokenText.fromJson(
        json['phonetic_l1_transcription'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'arc': arc.toJson(),
        'token_l2': tokenL2.toJson(),
        'phonetic_l1_transcription': phoneticL1Transcription.toJson(),
      };
}

class PhoneticTranscription {
  final LanguageArc arc;
  final PangeaTokenText transcriptionL2;
  final List<PhoneticTranscriptionToken> phoneticTranscription;
  final PhoneticTranscriptionDelimEnum delim;

  PhoneticTranscription({
    required this.arc,
    required this.transcriptionL2,
    required this.phoneticTranscription,
    this.delim = PhoneticTranscriptionDelimEnum.sp,
  });

  factory PhoneticTranscription.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscription(
      arc: LanguageArc.fromJson(json['arc'] as Map<String, dynamic>),
      transcriptionL2: PangeaTokenText.fromJson(
        json['transcription_l2'] as Map<String, dynamic>,
      ),
      phoneticTranscription: (json['phonetic_transcription'] as List)
          .map(
            (e) =>
                PhoneticTranscriptionToken.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      delim: json['delim'] != null
          ? PhoneticTranscriptionDelimEnumExt.fromString(
              json['delim'] as String,
            )
          : PhoneticTranscriptionDelimEnum.sp,
    );
  }

  Map<String, dynamic> toJson() => {
        'arc': arc.toJson(),
        'transcription_l2': transcriptionL2.toJson(),
        'phonetic_transcription':
            phoneticTranscription.map((e) => e.toJson()).toList(),
        'delim': delim.value,
      };
}

class PhoneticTranscriptionResponse {
  final LanguageArc arc;
  final PangeaTokenText content;
  final Map<String, dynamic>
      tokenization; // You can define a typesafe model if needed
  final PhoneticTranscription phoneticTranscriptionResult;
  DateTime? expireAt;

  PhoneticTranscriptionResponse({
    required this.arc,
    required this.content,
    required this.tokenization,
    required this.phoneticTranscriptionResult,
    this.expireAt,
  });

  factory PhoneticTranscriptionResponse.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscriptionResponse(
      arc: LanguageArc.fromJson(json['arc'] as Map<String, dynamic>),
      content:
          PangeaTokenText.fromJson(json['content'] as Map<String, dynamic>),
      tokenization: Map<String, dynamic>.from(json['tokenization'] as Map),
      phoneticTranscriptionResult: PhoneticTranscription.fromJson(
        json['phonetic_transcription_result'] as Map<String, dynamic>,
      ),
      expireAt: json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arc': arc.toJson(),
      'content': content.toJson(),
      'tokenization': tokenization,
      'phonetic_transcription_result': phoneticTranscriptionResult.toJson(),
      'expireAt': expireAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneticTranscriptionResponse &&
          runtimeType == other.runtimeType &&
          arc == other.arc &&
          content == other.content &&
          tokenization == other.tokenization &&
          phoneticTranscriptionResult == other.phoneticTranscriptionResult;

  @override
  int get hashCode =>
      arc.hashCode ^
      content.hashCode ^
      tokenization.hashCode ^
      phoneticTranscriptionResult.hashCode;
}
