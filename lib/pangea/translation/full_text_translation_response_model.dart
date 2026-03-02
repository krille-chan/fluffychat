import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class FullTextTranslationResponseModel {
  final List<String> translations;
  final String translation;
  final String source;

  const FullTextTranslationResponseModel({
    required this.translation,
    required this.translations,
    required this.source,
  });

  factory FullTextTranslationResponseModel.fromJson(Map<String, dynamic> json) {
    return FullTextTranslationResponseModel(
      translation: json['translation'] as String,
      translations: (json["translations"] as Iterable)
          .map<String>((e) => e)
          .toList()
          .cast<String>(),
      source: json[ModelKey.srcLang],
    );
  }

  Map<String, dynamic> toJson() => {
    'translation': translation,
    'translations': translations,
    ModelKey.srcLang: source,
  };

  String get bestTranslation => translation;
}
