import 'package:get_storage/get_storage.dart';

class LanguageMismatchRepo {
  static final GetStorage _storage = GetStorage('language_mismatch');
  static const String key = 'shown_timestamp';
  static const Duration displayInterval = Duration(minutes: 30);

  static Future<void> set() async {
    await _storage.write(key, DateTime.now().toIso8601String());
  }

  static DateTime? _get() {
    final entry = _storage.read(key);
    if (entry == null) return null;

    try {
      final value = DateTime.tryParse(entry);
      if (value != null) {
        final timeSince = DateTime.now().difference(value);
        if (timeSince > displayInterval) {
          _delete();
          return null;
        }
        return value;
      }
    } catch (_) {
      _delete();
    }

    return null;
  }

  static Future<void> _delete() async {
    await _storage.remove(key);
  }

  static bool get shouldShow {
    final lastShown = _get();
    if (lastShown == null) return true;
    return DateTime.now().difference(lastShown) >= displayInterval;
  }
}
