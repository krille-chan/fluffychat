import 'package:fluffychat/pangea/events/models/content_feedback.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_response.dart';

class TokenInfoFeedbackResponse implements JsonSerializable {
  final String userFriendlyMessage;
  final PangeaToken? updatedToken;
  final LemmaInfoResponse? updatedLemmaInfo;
  final PhoneticTranscriptionResponse? updatedPhonetics;
  final String? updatedLanguage;

  TokenInfoFeedbackResponse({
    required this.userFriendlyMessage,
    this.updatedToken,
    this.updatedLemmaInfo,
    this.updatedPhonetics,
    this.updatedLanguage,
  });

  factory TokenInfoFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return TokenInfoFeedbackResponse(
      userFriendlyMessage: json['user_friendly_message'] as String,
      updatedToken: json['updated_token'] != null
          ? PangeaToken.fromJson(json['updated_token'] as Map<String, dynamic>)
          : null,
      updatedLemmaInfo: json['updated_lemma_info'] != null
          ? LemmaInfoResponse.fromJson(
              json['updated_lemma_info'] as Map<String, dynamic>,
            )
          : null,
      updatedPhonetics: json['updated_phonetics'] != null
          ? PhoneticTranscriptionResponse.fromJson(
              json['updated_phonetics'] as Map<String, dynamic>,
            )
          : null,
      updatedLanguage: json['updated_language'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_friendly_message': userFriendlyMessage,
      'updated_token': updatedToken?.toJson(),
      'updated_lemma_info': updatedLemmaInfo?.toJson(),
      'updated_phonetics': updatedPhonetics?.toJson(),
      'updated_language': updatedLanguage,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenInfoFeedbackResponse &&
          runtimeType == other.runtimeType &&
          userFriendlyMessage == other.userFriendlyMessage &&
          updatedToken == other.updatedToken &&
          updatedLemmaInfo == other.updatedLemmaInfo &&
          updatedPhonetics == other.updatedPhonetics &&
          updatedLanguage == other.updatedLanguage;

  @override
  int get hashCode =>
      userFriendlyMessage.hashCode ^
      updatedToken.hashCode ^
      updatedLemmaInfo.hashCode ^
      updatedPhonetics.hashCode ^
      updatedLanguage.hashCode;
}
