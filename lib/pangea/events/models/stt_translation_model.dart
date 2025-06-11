class SttTranslationModel {
  final String translation;
  final String langCode;

  SttTranslationModel({
    required this.translation,
    required this.langCode,
  });

  factory SttTranslationModel.fromJson(Map<String, dynamic> json) {
    return SttTranslationModel(
      translation: json['translation'] as String,
      langCode: json['lang_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translation': translation,
      'lang_code': langCode,
    };
  }
}
