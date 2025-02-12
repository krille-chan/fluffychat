import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';

class LanguageKeys {
  static const unknownLanguage = "unk";
  static const mixedLanguage = "mixed";
  static const defaultLanguage = "en";
  static const multiLanguage = "multi";
}

class PrefKey {
  static const lastFetched = 'p_lang_lastfetched';
  static const languagesKey = 'p_lang_flag';
}

final LanguageDetection unknownLanguageDetection = LanguageDetection(
  langCode: LanguageKeys.unknownLanguage,
  confidence: 0.5,
);
