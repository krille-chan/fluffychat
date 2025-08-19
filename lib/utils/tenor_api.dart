import 'dart:convert';
import 'package:http/http.dart' as http;

class TenorGif {
  final String id;
  final String title;
  final String url;
  final String previewUrl;
  final int width;
  final int height;

  TenorGif({
    required this.id,
    required this.title,
    required this.url,
    required this.previewUrl,
    required this.width,
    required this.height,
  });

  factory TenorGif.fromJson(Map<String, dynamic> json) {
    final mediaFormats = json['media_formats'] as Map<String, dynamic>;

    // Find gif and tinygif formats - v2 API uses media_formats structure
    final gifFormat = mediaFormats['gif'] as Map<String, dynamic>?;
    final previewFormat =
        mediaFormats['tinygif'] as Map<String, dynamic>? ?? gifFormat;

    if (gifFormat == null) {
      throw Exception('No GIF format found in media_formats');
    }

    return TenorGif(
      id: json['id'],
      title: json['title'] ?? json['content_description'] ?? '',
      url: gifFormat['url'],
      previewUrl: previewFormat!['url'],
      width: gifFormat['dims'][0],
      height: gifFormat['dims'][1],
    );
  }
}

class TenorApiResponse {
  final List<TenorGif> results;
  final String next;

  TenorApiResponse({
    required this.results,
    required this.next,
  });

  factory TenorApiResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List)
        .map((item) => TenorGif.fromJson(item))
        .toList();

    return TenorApiResponse(
      results: results,
      next: json['next']?.toString() ?? '',
    );
  }
}

class TenorApi {
  static const String _baseUrl = 'https://tenor.googleapis.com/v2';
  static const String _apiKey =
      '<tenor-api-key>'; // Test API key from documentation
  static const String _clientKey =
      'fluffychat_app'; // Client key for integration tracking
  static const int _limit = 20;

  static Future<TenorApiResponse> searchGifs(
    String query, {
    String? pos,
  }) async {
    if (query.trim().isEmpty) {
      return getFeaturedGifs(pos: pos);
    }

    try {
      final queryParams = {
        'key': _apiKey,
        'client_key': _clientKey,
        'q': query,
        'limit': _limit.toString(),
        'locale': 'en_US',
        'country': 'US',
        'contentfilter': 'medium',
        'media_filter': 'gif,tinygif',
        'ar_range': 'all',
      };

      if (pos != null && pos.isNotEmpty && pos != '0') {
        queryParams['pos'] = pos;
      }

      final uri =
          Uri.parse('$_baseUrl/search').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TenorApiResponse.fromJson(data);
      } else {
        throw Exception('Failed to search GIFs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching GIFs: $e');
    }
  }

  static Future<TenorApiResponse> getFeaturedGifs({String? pos}) async {
    try {
      final queryParams = {
        'key': _apiKey,
        'client_key': _clientKey,
        'limit': _limit.toString(),
        'locale': 'en_US',
        'country': 'US',
        'contentfilter': 'medium',
        'media_filter': 'gif,tinygif',
        'ar_range': 'all',
      };

      if (pos != null && pos.isNotEmpty && pos != '0') {
        queryParams['pos'] = pos;
      }

      final uri =
          Uri.parse('$_baseUrl/featured').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TenorApiResponse.fromJson(data);
      } else {
        throw Exception('Failed to get featured GIFs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting featured GIFs: $e');
    }
  }
}
