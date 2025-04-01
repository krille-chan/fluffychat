import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

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

  static void clean() {
    final Iterable<String> keys = _storage.getKeys();
    if (keys.length > 300) {
      final entries = keys
          .map((key) {
            final entry = PracticeSelection.fromJson(_storage.read(key));
            return MapEntry(key, entry);
          })
          .cast<MapEntry<String, PracticeSelection>>()
          .toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      for (var i = 0; i < 5; i++) {
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

    final entryJson = _storage.read(key);
    if (entryJson != null) {
      final entry = PracticeSelection.fromJson(entryJson);
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
