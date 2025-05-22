import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/practice_activities/practice_record.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';

/// Controller for handling activity completions.
class PracticeRecordRepo {
  static final GetStorage _storage = GetStorage('practice_record_cache');
  static final Map<String, PracticeRecord> _memoryCache = {};
  static const int _maxMemoryCacheSize = 50;

  void dispose() {
    _storage.erase();
    _memoryCache.clear();
  }

  static void save(
    PracticeTarget selection,
    PracticeRecord entry,
  ) {
    _storage.write(selection.storageKey, entry.toJson());
    _memoryCache[selection.storageKey] = entry;
  }

  static void clean() {
    final keys = _storage.getKeys();
    if (keys.length > 300) {
      final entries = keys
          .map((key) {
            final entry = PracticeRecord.fromJson(_storage.read(key));
            return MapEntry(key, entry);
          })
          .cast<MapEntry<String, PracticeRecord>>()
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

  static PracticeRecord get(
    PracticeTarget target,
  ) {
    final String key = target.storageKey;
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key]!;
    }

    final entryJson = _storage.read(key);
    if (entryJson != null) {
      final entry = PracticeRecord.fromJson(entryJson);
      if (DateTime.now().difference(entry.createdAt).inDays > 1) {
        debugPrint('removing old entry ${entry.createdAt}');
        _storage.remove(key);
      } else {
        _memoryCache[key] = entry;
        return entry;
      }
    }

    debugPrint('creating new practice record for $key');
    final newEntry = PracticeRecord();

    _storage.write(key, newEntry.toJson());
    _memoryCache[key] = newEntry;

    clean();

    return newEntry;
  }
}
