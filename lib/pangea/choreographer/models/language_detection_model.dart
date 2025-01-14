import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class LanguageDetection {
  String langCode;
  double confidence;

  LanguageDetection({
    required this.langCode,
    required this.confidence,
  });

  factory LanguageDetection.fromJson(Map<String, dynamic> json) {
    return LanguageDetection(
      langCode: json[ModelKey.langCode],
      confidence: json[ModelKey.confidence],
    );
  }

  Map<String, dynamic> toJson() => {
        ModelKey.langCode: langCode,
        ModelKey.confidence: confidence,
      };
}
