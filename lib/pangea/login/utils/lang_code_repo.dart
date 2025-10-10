import 'package:get_storage/get_storage.dart';

class LangCodeRepo {
  static final GetStorage _storage = GetStorage('lang_code_storage');

  static Future<void> _init() async {
    await GetStorage.init('lang_code_storage');
  }

  static Future<String?> get() async {
    await _init();
    return _storage.read('lang_code');
  }

  static Future<void> set(String langcode) async {
    await _init();
    await _storage.write('lang_code', langcode);
  }

  static Future<void> remove() async {
    await _init();
    await _storage.remove('lang_code');
  }
}
