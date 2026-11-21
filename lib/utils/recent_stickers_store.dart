// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentStickersStore {
  static const _maxItems = 30;
  static const _keyPrefix = 'chat.fluffy.recent_stickers.';

  static List<String> read(SharedPreferences store, String? userId) {
    final key = _keyForUser(userId);
    if (key == null) return const [];

    try {
      return _normalize(store.getStringList(key) ?? const []);
    } catch (error, stackTrace) {
      Logs().w(
        'Unable to read recent stickers from local storage',
        error,
        stackTrace,
      );
      return const [];
    }
  }

  static Future<void> add(
    SharedPreferences store,
    String? userId,
    Uri stickerUrl,
  ) async {
    final key = _keyForUser(userId);
    final stickerUrlString = stickerUrl.toString();
    if (key == null || !_isMxc(stickerUrlString)) return;

    try {
      final updated = read(
        store,
        userId,
      ).where((item) => item != stickerUrlString).toList();
      updated.insert(0, stickerUrlString);
      await store.setStringList(
        key,
        updated.take(_maxItems).toList(growable: false),
      );
    } catch (error, stackTrace) {
      Logs().w('Unable to persist recent sticker', error, stackTrace);
    }
  }

  static String? _keyForUser(String? userId) {
    if (userId == null || userId.isEmpty) return null;
    return '$_keyPrefix$userId';
  }

  static List<String> _normalize(Iterable<String> stored) {
    final normalized = <String>[];
    final seen = <String>{};

    for (final item in stored) {
      if (!_isMxc(item) || !seen.add(item)) continue;
      normalized.add(item);
      if (normalized.length == _maxItems) break;
    }

    return normalized;
  }

  static bool _isMxc(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.scheme == 'mxc' &&
        uri.host.isNotEmpty &&
        uri.pathSegments.isNotEmpty;
  }
}
