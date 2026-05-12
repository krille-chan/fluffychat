import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

class TenorGif {
  final String id;
  final String title;
  final String url;
  final String embedUrl;
  final String previewUrl;
  final int width;
  final int height;

  TenorGif({
    required this.id,
    required this.title,
    required this.url,
    required this.embedUrl,
    required this.previewUrl,
    required this.width,
    required this.height,
  });

  factory TenorGif.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;

    final original = images?['original'] as Map<String, dynamic>?;
    final directGifUrl = original?['url']?.toString() ?? '';

    return TenorGif(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: directGifUrl,
      embedUrl: json['embed_url'],
      previewUrl: images?['fixed_height_small']?['url']?.toString() ?? '',
      width: int.tryParse(original?['width']?.toString() ?? '0') ?? 0,
      height: int.tryParse(original?['height']?.toString() ?? '0') ?? 0,
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

class TenorApiResponse {
  final List<TenorGif> results;
  final int next;

  TenorApiResponse({required this.results, required this.next});

  factory TenorApiResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['data'] as List)
        .map((item) => TenorGif.fromJson(item))
        .toList();

    return TenorApiResponse(results: results, next: results.length ?? 0);
  }
}

class TenorApi {
  static const String _baseUrl = 'https://api.giphy.com/v1/gifs';
  static const int _limit = 20;

  static Future<TenorApiResponse> searchGifs(
    String query, {
    int? pos,
    Client? client,
  }) async {
    if (query.trim().isEmpty) {
      return getFeaturedGifs(pos: pos);
    }

    try {
      final queryParams = {
        'api_key': _getApiKey(client),
        'q': query,
        'limit': _limit.toString(),
        'rating': 'r',
        'bundle': 'messaging_non_clips',
      };

      if (pos != null && pos != 0) {
        queryParams['offset'] = pos.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/search',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TenorApiResponse.fromJson(data);
      } else {
        throw Exception(
          'Failed to search GIFs: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error searching GIFs: $e');
    }
  }

  static Future<TenorApiResponse> getFeaturedGifs({
    int? pos,
    Client? client,
  }) async {
    try {
      final queryParams = {
        'api_key': _getApiKey(client),
        'limit': _limit.toString(),
        'rating': 'r',
        'bundle': 'messaging_non_clips',
      };

      if (pos != null && pos != 0) {
        queryParams['offset'] = pos.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/trending',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TenorApiResponse.fromJson(data);
      } else {
        throw Exception(
          'Failed to get featured GIFs: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error getting featured GIFs: $e');
    }
  }

  static String _getApiKey(Client? client) {
    if (client != null) {
      final content = client.accountData['im.ponies.gif_api_key']?.content;
      final customKey = content?.tryGet<String>('api_key');
      if (customKey != null && customKey.trim().isNotEmpty) {
        return customKey.trim();
      }
    }
    return '';
  }
}
