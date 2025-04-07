import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection.dart';

class PracticeSelectionRepo {
  static final GetStorage _storage = GetStorage('practice_selection_cache');
  static final Map<String, PracticeSelection> _memoryCache = {};
  static const int _maxMemoryCacheSize = 50;

  void dispose() {
    _storage.erase();
    _memoryCache.clear();
  }

  static void save(PracticeSelection entry) {
    final key = _key(entry.tokens);
    _storage.write(key, entry.toJson());
    _memoryCache[key] = entry;
  }

  static MapEntry<String, PracticeSelection>? _parsePracticeSelection(
    String key,
  ) {
    if (!_storage.hasData(key)) {
      return null;
    }
    try {
      final entry = PracticeSelection.fromJson(_storage.read(key));
      return MapEntry(key, entry);
    } catch (e, s) {
      ErrorHandler.logError(
        m: 'Failed to parse PracticeSelection from JSON',
        e: e,
        s: s,
        data: {
          'key': key,
          'json': _storage.read(key),
        },
      );
      _storage.remove(key);
      return null;
    }
  }

  static void clean() {
    final Iterable<String> keys = _storage.getKeys();
    if (keys.length > 300) {
      final entries = keys
          .map((key) => _parsePracticeSelection(key))
          .where((entry) => entry != null)
          .cast<MapEntry<String, PracticeSelection>>()
          .toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      for (var i = 0; i < 5 && i < entries.length; i++) {
        _storage.remove(entries[i].key);
      }
    }
    if (_memoryCache.length > _maxMemoryCacheSize) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
  }

  static String _key(List<PangeaToken> tokens) =>
      tokens.map((t) => t.text.content).join(' ');

  static PracticeSelection? get(
    String messageLanguage,
    List<PangeaToken> tokens,
  ) {
    final String key = _key(tokens);
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }

    final stored = _parsePracticeSelection(key);
    if (stored != null) {
      final entry = stored.value;
      if (DateTime.now().difference(entry.createdAt).inDays > 1) {
        debugPrint('removing old entry ${entry.createdAt}');
        _storage.remove(key);
      } else {
        _memoryCache[key] = entry;
        return entry;
      }
    }

    final newEntry = PracticeSelection(
      langCode: messageLanguage,
      tokens: tokens,
    );

    _storage.write(key, newEntry.toJson());
    _memoryCache[key] = newEntry;

    clean();

    return newEntry;
  }
}
