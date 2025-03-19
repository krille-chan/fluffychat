//Question for Jordan - is this for an individual token or could it be a span?

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../../common/config/environment.dart';
import '../../common/constants/model_keys.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';

class FullTextTranslationRepo {
  static final Map<String, FullTextTranslationResponseModel> _cache = {};
  static Timer? _cacheTimer;

  // start a timer to clear the cache
  static void startCacheTimer() {
    _cacheTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      clearCache();
    });
  }

  // stop the cache time (optional)
  static void stopCacheTimer() {
    _cacheTimer?.cancel();
  }

  // method to clear the cache
  static void clearCache() {
    _cache.clear();
  }

  static String _generateCacheKey({
    required String text,
    required String srcLang,
    required String tgtLang,
    required int offset,
    required int length,
    bool? deepL,
  }) {
    return '${text.hashCode}-$srcLang-$tgtLang-$deepL-$offset-$length';
  }

  static Future<FullTextTranslationResponseModel> translate({
    required String accessToken,
    required FullTextTranslationRequestModel request,
  }) async {
    // start cache timer when the first API call is made
    startCacheTimer();

    final cacheKey = _generateCacheKey(
      text: request.text,
      srcLang: request.srcLang ?? '',
      tgtLang: request.tgtLang,
      offset: request.offset ?? 0,
      length: request.length ?? 0,
      deepL: request.deepL,
    );

    // check cache first
    if (_cache.containsKey(cacheKey)) {
      if (_cache[cacheKey] == null) {
        _cache.remove(cacheKey);
      } else {
        return _cache[cacheKey]!;
      }
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.simpleTranslation,
      body: request.toJson(),
    );

    final responseModel = FullTextTranslationResponseModel.fromJson(
      jsonDecode(utf8.decode(res.bodyBytes)),
    );

    // store response in cache
    _cache[cacheKey] = responseModel;

    return responseModel;
  }
}

class FullTextTranslationRequestModel {
  String text;
  String? srcLang;
  String tgtLang;
  String userL1;
  String userL2;
  bool? deepL;
  int? offset;
  int? length;

  FullTextTranslationRequestModel({
    required this.text,
    this.srcLang,
    required this.tgtLang,
    required this.userL2,
    required this.userL1,
    this.deepL = false,
    this.offset,
    this.length,
  });

  //PTODO throw error for null

  Map<String, dynamic> toJson() => {
        "text": text,
        ModelKey.srcLang: srcLang,
        ModelKey.tgtLang: tgtLang,
        ModelKey.userL2: userL2,
        ModelKey.userL1: userL1,
        ModelKey.deepL: deepL,
        ModelKey.offset: offset,
        ModelKey.length: length,
      };

  // override equals and hashcode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FullTextTranslationRequestModel &&
        other.text == text &&
        other.srcLang == srcLang &&
        other.tgtLang == tgtLang &&
        other.userL2 == userL2 &&
        other.userL1 == userL1 &&
        other.deepL == deepL &&
        other.offset == offset &&
        other.length == length;
  }

  @override
  int get hashCode =>
      text.hashCode ^
      srcLang.hashCode ^
      tgtLang.hashCode ^
      userL2.hashCode ^
      userL1.hashCode ^
      deepL.hashCode ^
      offset.hashCode ^
      length.hashCode;
}

class FullTextTranslationResponseModel {
  List<String> translations;

  /// detected source
  /// PTODO -
  String source;
  String? deepL;

  FullTextTranslationResponseModel({
    required this.translations,
    required this.source,
    required this.deepL,
  });

  factory FullTextTranslationResponseModel.fromJson(Map<String, dynamic> json) {
    return FullTextTranslationResponseModel(
      translations: (json["translations"] as Iterable)
          .map<String>(
            (e) => e,
          )
          .toList()
          .cast<String>(),
      source: json[ModelKey.srcLang],
      deepL: json['deepl_res'],
    );
  }

  String get bestTranslation => deepL ?? translations.first;
}
