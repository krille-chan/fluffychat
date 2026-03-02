//Question for Jordan - is this for an individual token or could it be a span?

import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_request_model.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_response_model.dart';
import '../common/config/environment.dart';
import '../common/network/requests.dart';
import '../common/network/urls.dart';

class _TranslateCacheItem {
  final Future<FullTextTranslationResponseModel> response;
  final DateTime timestamp;

  const _TranslateCacheItem({required this.response, required this.timestamp});
}

class FullTextTranslationRepo {
  static final Map<String, _TranslateCacheItem> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 10);

  static Future<Result<FullTextTranslationResponseModel>> get(
    String accessToken,
    FullTextTranslationRequestModel request,
  ) {
    final cached = _getCached(request);
    if (cached != null) {
      return _getResult(request, cached);
    }

    final future = _fetch(accessToken, request);
    _setCached(request, future);
    return _getResult(request, future);
  }

  static Future<FullTextTranslationResponseModel> _fetch(
    String accessToken,
    FullTextTranslationRequestModel request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.simpleTranslation,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to translate text: ${res.statusCode} ${res.reasonPhrase}',
      );
    }

    return FullTextTranslationResponseModel.fromJson(
      jsonDecode(utf8.decode(res.bodyBytes)),
    );
  }

  static Future<Result<FullTextTranslationResponseModel>> _getResult(
    FullTextTranslationRequestModel request,
    Future<FullTextTranslationResponseModel> future,
  ) async {
    try {
      final res = await future;
      return Result.value(res);
    } catch (e, s) {
      _cache.remove(request.hashCode.toString());
      ErrorHandler.logError(e: e, s: s, data: request.toJson());
      return Result.error(e);
    }
  }

  static Future<FullTextTranslationResponseModel>? _getCached(
    FullTextTranslationRequestModel request,
  ) {
    final cacheKeys = [..._cache.keys];
    for (final key in cacheKeys) {
      if (DateTime.now().difference(_cache[key]!.timestamp) >= _cacheDuration) {
        _cache.remove(key);
      }
    }

    return _cache[request.hashCode.toString()]?.response;
  }

  static void _setCached(
    FullTextTranslationRequestModel request,
    Future<FullTextTranslationResponseModel> response,
  ) => _cache[request.hashCode.toString()] = _TranslateCacheItem(
    response: response,
    timestamp: DateTime.now(),
  );
}
