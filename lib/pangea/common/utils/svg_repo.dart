import 'package:async/async.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix_api_lite/utils/logs.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class _SvgCacheEntry {
  final int timestamp;
  final String? svg;

  _SvgCacheEntry(this.svg, this.timestamp);

  Map<String, dynamic> toJson() => {'svg': svg, 'timestamp': timestamp};

  factory _SvgCacheEntry.fromJson(Map<String, dynamic> json) {
    return _SvgCacheEntry(json['svg'] as String, json['timestamp'] as int);
  }

  static const Duration cacheDuration = Duration(days: 1);

  bool get isExpired => DateTime.fromMillisecondsSinceEpoch(
    timestamp,
  ).isBefore(DateTime.now().subtract(cacheDuration));
}

class SvgRepo {
  static final GetStorage _storage = GetStorage('svg_cache');
  static final Map<String, Future<Result<String>>> _cache = {};

  static Future<Result<String>> get(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }

    final future = _fetch(url);
    _cache[url] = future;
    return future;
  }

  static Future<Result<String>> _fetch(String url) async {
    try {
      final cached = await _getCached(url);
      if (cached != null) {
        return cached.svg != null
            ? Result.value(cached.svg!)
            : Result.error(Exception('Failed to load SVG at $url'));
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        ErrorHandler.logError(
          e: Exception('Failed to load SVG: ${response.statusCode}'),
          data: {"url": url},
        );
        await _setCached(url, null);
        return Result.error(Exception('Failed to load SVG at $url'));
      }

      final String svgContent = response.body;

      await _setCached(url, svgContent);
      return Result.value(svgContent);
    } catch (e, stack) {
      ErrorHandler.logError(
        e: Exception('Error fetching SVG: $e'),
        data: {"url": url},
        s: stack,
      );
      await _setCached(url, null);
      return Result.error(Exception('Failed to load SVG at $url'));
    }
  }

  static Future<_SvgCacheEntry?> _getCached(String url) async {
    await GetStorage.init('svg_cache');
    final entry = _storage.read(url);
    if (entry == null) return null;

    try {
      final svg = _SvgCacheEntry.fromJson(entry);
      if (svg.isExpired) {
        await _storage.remove(url);
        return null;
      }
      return svg;
    } catch (_) {
      await _storage.remove(url);
      return null;
    }
  }

  static Future<void> _setCached(String url, String? svg) async {
    if (svg != null && svg.length > 5200000) {
      Logs().w('SVG content is very large, skipping cache for $url');
      return;
    }
    final entry = _SvgCacheEntry(svg, DateTime.now().millisecondsSinceEpoch);
    await _storage.write(url, entry.toJson());
  }
}
