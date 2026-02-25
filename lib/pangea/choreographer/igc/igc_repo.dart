import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/choreographer/igc/igc_request_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/igc_response_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';

class _IgcCacheItem {
  final Future<IGCResponseModel> data;
  final DateTime timestamp;

  const _IgcCacheItem({required this.data, required this.timestamp});
}

class IgcRepo {
  static final Map<String, _IgcCacheItem> _igcCache = {};
  static const Duration _cacheDuration = Duration(minutes: 10);

  static Future<Result<IGCResponseModel>> get(
    String? accessToken,
    IGCRequestModel igcRequest,
  ) {
    debugPrint(
      '[IgcRepo.get] called, request.hashCode: ${igcRequest.hashCode}',
    );
    final cached = _getCached(igcRequest);
    if (cached != null) {
      debugPrint('[IgcRepo.get] cache HIT');
      return _getResult(igcRequest, cached);
    }
    debugPrint('[IgcRepo.get] cache MISS, fetching from server...');

    final future = _fetch(accessToken, igcRequest: igcRequest);
    _setCached(igcRequest, future);
    return _getResult(igcRequest, future);
  }

  static Future<IGCResponseModel> _fetch(
    String? accessToken, {
    required IGCRequestModel igcRequest,
  }) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.post(
      url: PApiUrls.igcLite,
      body: igcRequest.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to fetch IGC data: ${res.statusCode} ${res.reasonPhrase}',
      );
    }

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(res.bodyBytes).toString(),
    );

    return IGCResponseModel.fromJson(json);
  }

  static Future<Result<IGCResponseModel>> _getResult(
    IGCRequestModel request,
    Future<IGCResponseModel> future,
  ) async {
    try {
      final res = await future;
      return Result.value(res);
    } catch (e, s) {
      _igcCache.remove(request.hashCode.toString());
      ErrorHandler.logError(e: e, s: s, data: request.toJson());
      return Result.error(e);
    }
  }

  static Future<IGCResponseModel>? _getCached(IGCRequestModel request) {
    final cacheKeys = [..._igcCache.keys];
    for (final key in cacheKeys) {
      if (_igcCache[key]!.timestamp.isBefore(
        DateTime.now().subtract(_cacheDuration),
      )) {
        _igcCache.remove(key);
      }
    }

    return _igcCache[request.hashCode.toString()]?.data;
  }

  static void _setCached(
    IGCRequestModel request,
    Future<IGCResponseModel> response,
  ) => _igcCache[request.hashCode.toString()] = _IgcCacheItem(
    data: response,
    timestamp: DateTime.now(),
  );
}
