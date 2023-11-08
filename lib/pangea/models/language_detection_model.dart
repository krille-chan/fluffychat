class LanguageDetection {
  String langCode;

  LanguageDetection({
    required this.langCode,
  });

  factory LanguageDetection.fromJson(Map<String, dynamic> json) {
    return LanguageDetection(
      langCode: json[_langCodeKey],
    );
  }

  static const _langCodeKey = "lang_code";

  Map<String, dynamic> toJson() => {
        _langCodeKey: langCode,
      };
}
