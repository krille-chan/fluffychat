import 'dart:async';
import 'dart:convert';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../config/environment.dart';
import '../network/requests.dart';
import '../network/urls.dart';

// Assuming SpeechToTextRequestModel, SpeechToTextResponseModel and related models are already defined as in your provided code.

class _SpeechToTextCacheItem {
  Future<SpeechToTextResponseModel> data;

  _SpeechToTextCacheItem({required this.data});
}

class SpeechToTextController {
  static final Map<int, _SpeechToTextCacheItem> _cache = {};
  late final PangeaController _pangeaController;
  Timer? _cacheClearTimer;

  SpeechToTextController(this._pangeaController) {
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 15);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  Future<SpeechToTextResponseModel> get(
      SpeechToTextRequestModel requestModel) async {
    final int cacheKey = requestModel.hashCode;

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.data;
    } else {
      final Future<SpeechToTextResponseModel> response = _fetchResponse(
        accessToken: await _pangeaController.userController.accessToken,
        requestModel: requestModel,
      );
      _cache[cacheKey] = _SpeechToTextCacheItem(data: response);
      return response;
    }
  }

  static Future<SpeechToTextResponseModel> _fetchResponse({
    required String accessToken,
    required SpeechToTextRequestModel requestModel,
  }) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await request.post(
      url: PApiUrls.speechToText,
      body: requestModel.toJson(),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));
      return SpeechToTextResponseModel.fromJson(json);
    } else {
      debugPrint('Error converting speech to text: ${res.body}');
      throw Exception('Failed to convert speech to text');
    }
  }
}
