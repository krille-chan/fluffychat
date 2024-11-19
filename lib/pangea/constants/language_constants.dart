import 'package:fluffychat/pangea/models/language_detection_model.dart';

class LanguageKeys {
  static const unknownLanguage = "unk";
  static const mixedLanguage = "mixed";
  static const defaultLanguage = "en";
  static const multiLanguage = "multi";
}

class LanguageLevelType {
  static List<int> get allInts => [0, 1, 2, 3, 4, 5, 6];
}

class PrefKey {
  static const lastFetched = 'p_lang_lastfetched';
  static const flags = 'p_lang_flag';
}

final LanguageDetection unknownLanguageDetection = LanguageDetection(
  langCode: LanguageKeys.unknownLanguage,
  confidence: 0.5,
);
