import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/models/span_data.dart';
import 'package:fluffychat/pangea/choreographer/repo/span_data_repo.dart';
import 'package:fluffychat/pangea/choreographer/utils/normalize_text.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class _SpanDetailsCacheItem {
  Future<SpanDetailsRepoReqAndRes> data;

  _SpanDetailsCacheItem({required this.data});
}

class SpanDataController {
  late Choreographer choreographer;
  final Map<int, _SpanDetailsCacheItem> _cache = {};
  Timer? _cacheClearTimer;

  SpanDataController(this.choreographer) {
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 2);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => clearCache());
  }

  void clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  SpanData? _getSpan(int matchIndex) {
    if (choreographer.igc.igcTextData == null ||
        choreographer.igc.igcTextData!.matches.isEmpty ||
        matchIndex < 0 ||
        matchIndex >= choreographer.igc.igcTextData!.matches.length) {
      debugger(when: kDebugMode);
      return null;
    }

    /// Retrieves the span data from the `igcTextData` matches at the specified `matchIndex`.
    /// Creates a `SpanDetailsRepoReqAndRes` object with the retrieved span data and other parameters.
    /// Generates a cache key based on the created `SpanDetailsRepoReqAndRes` object.
    return choreographer.igc.igcTextData!.matches[matchIndex].match;
  }

  bool isNormalizationError(int matchIndex) {
    final span = _getSpan(matchIndex);
    if (span == null) return false;

    final correctChoice = span.choices
        ?.firstWhereOrNull(
          (c) => c.isBestCorrection,
        )
        ?.value;

    final errorSpan = span.fullText.substring(
      span.offset,
      span.offset + span.length,
    );

    return correctChoice != null &&
        normalizeString(correctChoice) == normalizeString(errorSpan);
  }

  Future<void> getSpanDetails(
    int matchIndex, {
    bool force = false,
  }) async {
    final SpanData? span = _getSpan(matchIndex);
    if (span == null || (isNormalizationError(matchIndex) && !force)) return;

    final req = SpanDetailsRepoReqAndRes(
      userL1: choreographer.l1LangCode!,
      userL2: choreographer.l2LangCode!,
      enableIGC: choreographer.igcEnabled,
      enableIT: choreographer.itEnabled,
      span: span,
    );
    final int cacheKey = req.hashCode;

    /// Retrieves the [SpanDetailsRepoReqAndRes] response from the cache if it exists,
    /// otherwise makes an API call to get the response and stores it in the cache.
    Future<SpanDetailsRepoReqAndRes> response;
    if (_cache.containsKey(cacheKey)) {
      response = _cache[cacheKey]!.data;
    } else {
      response = SpanDataRepo.getSpanDetails(
        choreographer.accessToken,
        request: SpanDetailsRepoReqAndRes(
          userL1: choreographer.l1LangCode!,
          userL2: choreographer.l2LangCode!,
          enableIGC: choreographer.igcEnabled,
          enableIT: choreographer.itEnabled,
          span: span,
        ),
      );
      _cache[cacheKey] = _SpanDetailsCacheItem(data: response);
    }

    try {
      choreographer.igc.igcTextData!.matches[matchIndex].match =
          (await response).span;
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s, data: req.toJson());
    }

    choreographer.setState();
  }
}
