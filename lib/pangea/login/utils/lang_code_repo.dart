import 'package:get_storage/get_storage.dart';

class LanguageSettings {
  final String targetLangCode;
  final String? baseLangCode;

  LanguageSettings({
    required this.targetLangCode,
    this.baseLangCode,
  });

  Map<String, dynamic> toJson() => {
        'targetLangCode': targetLangCode,
        'baseLangCode': baseLangCode,
      };

  factory LanguageSettings.fromJson(Map<String, dynamic> json) =>
      LanguageSettings(
        targetLangCode: json['targetLangCode'],
        baseLangCode: json['baseLangCode'],
      );
}

class LangCodeRepo {
  static const String _storageKey = 'lang_settings';
  static final GetStorage _storage = GetStorage('lang_code_storage');

  static Future<void> _init() async {
    await GetStorage.init('lang_code_storage');
  }

  static Future<LanguageSettings?> get() async {
    await _init();
    final entry = _storage.read(_storageKey);
    if (entry == null) return null;

    try {
      return LanguageSettings.fromJson(entry);
    } catch (e) {
      await remove();
      return null;
    }
  }

  static Future<void> set(LanguageSettings langcode) async {
    await _init();
    await _storage.write(_storageKey, langcode.toJson());
  }

  static Future<void> remove() async {
    await _init();
    await _storage.remove(_storageKey);
  }
}
