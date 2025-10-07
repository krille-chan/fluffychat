import 'package:get_storage/get_storage.dart';

class LangCodeRepo {
  static final GetStorage _storage = GetStorage('lang_code_storage');

  static String? get() {
    return _storage.read('lang_code');
  }

  static Future<void> set(String langcode) async {
    await _storage.write('lang_code', langcode);
  }

  static Future<void> remove() async {
    await _storage.remove('lang_code');
  }
}
