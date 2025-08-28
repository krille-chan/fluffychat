import 'dart:convert';

import 'package:http/http.dart' as http;

/// Response model for paginated results from PayloadCMS
class PayloadPaginatedResponse<T> {
  final List<T> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  PayloadPaginatedResponse({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  factory PayloadPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PayloadPaginatedResponse<T>(
      docs: (json['docs'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      totalDocs: json['totalDocs'] as int,
      limit: json['limit'] as int,
      page: json['page'] as int,
      totalPages: json['totalPages'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
      nextPage: json['nextPage'] as int?,
      prevPage: json['prevPage'] as int?,
    );
  }
}

/// Generic PayloadCMS client for CRUD operations
class PayloadClient {
  final String baseUrl;
  final String accessToken;
  final String basePath = "/cms/api";

  PayloadClient({
    required this.baseUrl,
    required this.accessToken,
  });

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    headers['Authorization'] = 'Bearer $accessToken';
    return headers;
  }

  /// Generic GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);
    return response;
  }

  /// Generic POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    return response;
  }

  /// Generic PATCH request
  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    return response;
  }

  /// Generic DELETE request
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);
    return response;
  }

  /// Find documents with pagination
  Future<PayloadPaginatedResponse<T>> find<T>(
    String collection,
    T Function(Map<String, dynamic>) fromJson, {
    int? page,
    int? limit,
    Map<String, dynamic>? where,
    String? sort,
  }) async {
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (where != null) queryParams['where'] = jsonEncode(where);
    if (sort != null) queryParams['sort'] = sort;

    final endpoint =
        '$basePath/$collection${queryParams.isNotEmpty ? '?${Uri(queryParameters: queryParams).query}' : ''}';

    final response = await get(endpoint);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return PayloadPaginatedResponse.fromJson(json, fromJson);
  }

  /// Find a single document by ID
  Future<T> findById<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final endpoint = '$basePath/$collection/$id';
    final response = await get(endpoint);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJson(json);
  }

  /// Create a new document
  Future<T> createDocument<T>(
    String collection,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final endpoint = '$basePath/$collection';
    final response = await post(endpoint, data);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJson(json);
  }

  /// Update an existing document
  Future<T> updateDocument<T>(
    String collection,
    String id,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final endpoint = '$basePath/$collection/$id';
    final response = await patch(endpoint, data);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJson(json);
  }

  /// Delete a document
  Future<T> deleteDocument<T>(
    String collection,
    String id,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final endpoint = '$basePath/$collection/$id';
    final response = await delete(endpoint);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJson(json);
  }
}
