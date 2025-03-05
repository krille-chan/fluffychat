import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

class TokensRequestModel {
  /// the text to be tokenized
  String fullText;

  /// if known, [langCode] is the language of of the text
  /// it is used to determine which model to use in tokenizing
  String? langCode;

  /// [senderL1] and [senderL2] are the languages of the sender
  /// if langCode is not known, the [senderL1] and [senderL2] will be used to help determine the language of the text
  /// if langCode is known, [senderL1] and [senderL2] will be used to determine whether the tokens need
  /// pos/mporph tags and whether lemmas are eligible to marked as "save_vocab=true"
  String senderL1;

  /// [senderL1] and [senderL2] are the languages of the sender
  /// if langCode is not known, the [senderL1] and [senderL2] will be used to help determine the language of the text
  /// if langCode is known, [senderL1] and [senderL2] will be used to determine whether the tokens need
  /// pos/mporph tags and whether lemmas are eligible to marked as "save_vocab=true"
  String senderL2;

  TokensRequestModel({
    required this.fullText,
    required this.langCode,
    required this.senderL1,
    required this.senderL2,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.userL1: senderL1,
        ModelKey.userL2: senderL2,
        ModelKey.langCode: langCode,
      };

  // override equals and hashcode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokensRequestModel &&
        other.fullText == fullText &&
        other.senderL1 == senderL1 &&
        other.senderL2 == senderL2;
  }

  @override
  int get hashCode => fullText.hashCode ^ senderL1.hashCode ^ senderL2.hashCode;
}

class TokensResponseModel {
  List<PangeaToken> tokens;
  String lang;
  List<LanguageDetection> detections;

  TokensResponseModel({
    required this.tokens,
    required this.lang,
    required this.detections,
  });

  factory TokensResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      TokensResponseModel(
        tokens: (json[ModelKey.tokens] as Iterable)
            .map<PangeaToken>(
              (e) => PangeaToken.fromJson(e as Map<String, dynamic>),
            )
            .toList()
            .cast<PangeaToken>(),
        lang: json[ModelKey.lang],
        detections: (json[ModelKey.allDetections] as Iterable)
            .map<LanguageDetection>(
              (e) => LanguageDetection.fromJson(e as Map<String, dynamic>),
            )
            .toList()
            .cast<LanguageDetection>(),
      );
}
