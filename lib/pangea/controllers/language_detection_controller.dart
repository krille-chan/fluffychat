import 'dart:async';
import 'dart:convert';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:http/http.dart' as http;

import '../network/requests.dart';

class LanguageDetectionRequest {
  String fullText;
  String userL1;
  String userL2;

  LanguageDetectionRequest({
    required this.fullText,
    this.userL1 = "",
    required this.userL2,
  });

  Map<String, dynamic> toJson() => {
        'full_text': fullText,
        'user_l1': userL1,
        'user_l2': userL2,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageDetectionRequest &&
        other.fullText == fullText &&
        other.userL1 == userL1 &&
        other.userL2 == userL2;
  }

  @override
  int get hashCode => fullText.hashCode ^ userL1.hashCode ^ userL2.hashCode;
}

class LanguageDetectionResponse {
  List<Map<String, dynamic>> detections;
  String fullText;

  LanguageDetectionResponse({
    required this.detections,
    required this.fullText,
  });

  factory LanguageDetectionResponse.fromJson(Map<String, dynamic> json) {
    return LanguageDetectionResponse(
      detections: List<Map<String, dynamic>>.from(json['detections']),
      fullText: json['full_text'],
    );
  }
}

class _LanguageDetectionCacheItem {
  Future<LanguageDetectionResponse> data;

  _LanguageDetectionCacheItem({
    required this.data,
  });
}

class LanguageDetectionController {
  static final Map<LanguageDetectionRequest, _LanguageDetectionCacheItem>
      _cache = {};
  late final PangeaController _pangeaController;
  Timer? _cacheClearTimer;

  LanguageDetectionController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 15); // Adjust the duration as needed
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  Future<LanguageDetectionResponse> get(
    LanguageDetectionRequest params,
  ) async {
    if (_cache.containsKey(params)) {
      return _cache[params]!.data;
    } else {
      final Future<LanguageDetectionResponse> response = _fetchResponse(
        await _pangeaController.userController.accessToken,
        params,
      );
      _cache[params] = _LanguageDetectionCacheItem(data: response);
      return response;
    }
  }

  static Future<LanguageDetectionResponse> _fetchResponse(
    String accessToken,
    LanguageDetectionRequest params,
  ) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApi,
      accessToken: accessToken,
    );

    final http.Response res = await request.post(
      url: PApiUrls.languageDetection,
      body: params.toJson(),
    );

    final Map<String, dynamic> json = jsonDecode(res.body);
    return LanguageDetectionResponse.fromJson(json);
  }
}
