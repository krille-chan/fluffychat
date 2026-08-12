// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

enum GifProvider { giphy, klipy }

class GifItem {
  final String id;
  final String title;
  final String url;
  final String embedUrl;
  final String previewUrl;
  final int width;
  final int height;

  GifItem({
    required this.id,
    required this.title,
    required this.url,
    required this.embedUrl,
    required this.previewUrl,
    required this.width,
    required this.height,
  });

  static String? _extractUrl(dynamic field) {
    if (field == null) return null;
    if (field is String && field.trim().isNotEmpty) return field.trim();
    if (field is Map) {
      final url =
          field['url']?.toString() ??
          field['gif']?.toString() ??
          field['webp']?.toString() ??
          field['mp4']?.toString() ??
          field['webm']?.toString() ??
          field['src']?.toString();
      if (url != null && url.trim().isNotEmpty) return url.trim();
    }
    return null;
  }

  factory GifItem.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;
    final file =
        json['file'] as Map<String, dynamic>? ??
        json['sizes'] as Map<String, dynamic>? ??
        json['media'] as Map<String, dynamic>?;

    final original =
        images?['original'] as Map<String, dynamic>? ??
        file?['hd'] as Map<String, dynamic>? ??
        file?['gif'] as Map<String, dynamic>?;
    final fixedSmall =
        images?['fixed_height_small'] as Map<String, dynamic>? ??
        images?['fixed_height'] as Map<String, dynamic>? ??
        file?['sm'] as Map<String, dynamic>? ??
        file?['tinygif'] as Map<String, dynamic>?;

    final directGifUrl =
        _extractUrl(original?['url']) ??
        _extractUrl(original?['gif']) ??
        _extractUrl(original?['webp']) ??
        _extractUrl(original?['mp4']) ??
        _extractUrl(file?['hd']) ??
        _extractUrl(file?['gif']) ??
        _extractUrl(images?['mp4']) ??
        _extractUrl(images?['webm']) ??
        _extractUrl(json['url']) ??
        _extractUrl(json['gif_url']) ??
        _extractUrl(json['file']) ??
        '';

    final previewGifUrl =
        _extractUrl(fixedSmall?['url']) ??
        _extractUrl(fixedSmall?['gif']) ??
        _extractUrl(fixedSmall?['webp']) ??
        _extractUrl(fixedSmall?['mp4']) ??
        _extractUrl(file?['sm']) ??
        _extractUrl(images?['preview_gif']) ??
        _extractUrl(json['preview_url']) ??
        _extractUrl(json['thumbnail']) ??
        directGifUrl;

    return GifItem(
      id: json['id']?.toString() ?? json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      url: directGifUrl,
      embedUrl: json['embed_url']?.toString() ?? directGifUrl,
      previewUrl: previewGifUrl,
      width:
          int.tryParse(
            original?['width']?.toString() ?? json['width']?.toString() ?? '0',
          ) ??
          0,
      height:
          int.tryParse(
            original?['height']?.toString() ??
                json['height']?.toString() ??
                '0',
          ) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'embed_url': embedUrl,
      'preview_url': previewUrl,
      'width': width,
      'height': height,
    };
  }
}

class GifApiResponse {
  final List<GifItem> results;
  final int next;

  GifApiResponse({required this.results, required this.next});

  factory GifApiResponse.fromJson(Map<String, dynamic> json) {
    dynamic rawData =
        json['data'] ?? json['results'] ?? json['result'] ?? json['gifs'];
    if (rawData is Map) {
      rawData =
          rawData['data'] ??
          rawData['results'] ??
          rawData['items'] ??
          rawData['gifs'];
    }
    final listData = rawData is List ? rawData : [];

    final results = listData
        .whereType<Map<String, dynamic>>()
        .map(GifItem.fromJson)
        .toList();

    return GifApiResponse(
      results: results,
      next: int.tryParse(json['next']?.toString() ?? '') ?? results.length,
    );
  }
}

class GifApi {
  static const String _giphyBaseUrl = 'https://api.giphy.com/v1/gifs';
  static const String _klipyBaseUrl = 'https://api.klipy.com/api/v1';
  static const int _limit = 20;

  static bool hasApiKey(Client? client) {
    final provider = getProvider(client);
    return _getApiKey(client, provider).isNotEmpty;
  }

  static GifProvider getProvider(Client? client) {
    if (client != null) {
      final content = client.accountData['im.ponies.gif_config']?.content;
      final provider = content?.tryGet<String>('provider')?.toLowerCase();
      if (provider == 'klipy') return GifProvider.klipy;
    }
    return GifProvider.giphy;
  }

  static String _getApiKey(Client? client, GifProvider provider) {
    if (client != null) {
      final fluffConfig = client.accountData['im.ponies.gif_config']?.content;
      final customKey = fluffConfig?.tryGet<String>('api_key');
      if (customKey != null && customKey.trim().isNotEmpty) {
        return customKey.trim();
      }
    }
    return '';
  }

  static Future<GifApiResponse> searchGifs(
    String query, {
    int? pos,
    Client? client,
  }) async {
    if (query.trim().isEmpty) {
      return getFeaturedGifs(pos: pos, client: client);
    }

    final provider = getProvider(client);
    try {
      if (provider == GifProvider.klipy) {
        return await _searchKlipy(query, pos: pos, client: client);
      } else {
        return await _searchGiphy(query, pos: pos, client: client);
      }
    } catch (_) {
      throw Exception('Error searching GIFs');
    }
  }

  static Future<GifApiResponse> getFeaturedGifs({
    int? pos,
    Client? client,
  }) async {
    final provider = getProvider(client);
    try {
      if (provider == GifProvider.klipy) {
        return await _getFeaturedKlipy(pos: pos, client: client);
      } else {
        return await _getFeaturedGiphy(pos: pos, client: client);
      }
    } catch (e) {
      try {
        if (provider == GifProvider.klipy) {
          return await _getFeaturedGiphy(pos: pos, client: client);
        } else {
          return await _getFeaturedKlipy(pos: pos, client: client);
        }
      } catch (_) {
        throw Exception('Error getting featured GIFs: $e');
      }
    }
  }

  static Future<GifApiResponse> _searchGiphy(
    String query, {
    int? pos,
    Client? client,
  }) async {
    final queryParams = {
      'api_key': _getApiKey(client, GifProvider.giphy),
      'q': query,
      'limit': _limit.toString(),
      'rating': 'r',
      'bundle': 'messaging_non_clips',
    };

    if (pos != null && pos != 0) {
      queryParams['offset'] = pos.toString();
    }

    final uri = Uri.parse(
      '$_giphyBaseUrl/search',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GifApiResponse.fromJson(data);
    } else {
      throw Exception(
        'Giphy search failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<GifApiResponse> _getFeaturedGiphy({
    int? pos,
    Client? client,
  }) async {
    final queryParams = {
      'api_key': _getApiKey(client, GifProvider.giphy),
      'limit': _limit.toString(),
      'rating': 'r',
      'bundle': 'messaging_non_clips',
    };

    if (pos != null && pos != 0) {
      queryParams['offset'] = pos.toString();
    }

    final uri = Uri.parse(
      '$_giphyBaseUrl/trending',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GifApiResponse.fromJson(data);
    } else {
      throw Exception(
        'Giphy trending failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<GifApiResponse> _searchKlipy(
    String query, {
    int? pos,
    Client? client,
  }) async {
    final apiKey = _getApiKey(client, GifProvider.klipy);
    if (apiKey.isEmpty) {
      return GifApiResponse(results: [], next: 0);
    }

    final page = (pos == null || pos == 0) ? 1 : ((pos / _limit).floor() + 1);
    final queryParams = {
      'page': page.toString(),
      'per_page': _limit.toString(),
      'q': query,
    };

    final uri = Uri.parse(
      '$_klipyBaseUrl/$apiKey/gifs/search',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GifApiResponse.fromJson(data);
    } else {
      throw Exception(
        'Klipy search failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<GifApiResponse> _getFeaturedKlipy({
    int? pos,
    Client? client,
  }) async {
    final apiKey = _getApiKey(client, GifProvider.klipy);
    if (apiKey.isEmpty) {
      return GifApiResponse(results: [], next: 0);
    }

    final page = (pos == null || pos == 0) ? 1 : ((pos / _limit).floor() + 1);
    final queryParams = {
      'page': page.toString(),
      'per_page': _limit.toString(),
    };

    final uri = Uri.parse(
      '$_klipyBaseUrl/$apiKey/gifs/trending',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GifApiResponse.fromJson(data);
    } else {
      throw Exception(
        'Klipy trending failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
