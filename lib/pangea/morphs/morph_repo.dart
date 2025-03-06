import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../common/network/requests.dart';

class _APICallCacheItem {
  final DateTime time;
  final Future<MorphFeaturesAndTags> future;

  _APICallCacheItem(this.time, this.future);
}

class MorphsRepo {
  // long-term storage of morphs
  static final GetStorage _morphsStorage = GetStorage('morphs_storage');

  // to avoid multiple fetches for the same language code
  // by different parts of the app within a short time
  static final shortTermCache = <String, _APICallCacheItem>{};
  static const int _cacheDurationMinutes = 1;

  static void set(String languageCode, MorphFeaturesAndTags response) {
    _morphsStorage.write(
      languageCode,
      response.toJson(),
    );
  }

  static MorphFeaturesAndTags fromJson(Map<String, dynamic> json) {
    return MorphFeaturesAndTags.fromJson(json);
  }

  static Future<MorphFeaturesAndTags> _fetch(String languageCode) async {
    try {
      final Requests req = Requests(
        choreoApiKey: Environment.choreoApiKey,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );

      final Response res = await req.get(
        url: '${PApiUrls.morphFeaturesAndTags}/$languageCode',
      );

      final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
      final response = MorphsRepo.fromJson(decodedBody);

      set(languageCode, response);

      return response;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "languageCode": languageCode,
        },
      );
      return defaultMorphMapping;
    }
  }

  /// this function fetches the morphs for a given language code
  /// while remaining synchronous by using a default value
  /// if the morphs are not yet fetched. we'll see if this works well
  /// if not, we can make it async and update uses of this function
  /// to be async as well
  static Future<MorphFeaturesAndTags> get([LanguageModel? language]) async {
    language ??= MatrixState.pangeaController.languageController.userL2;

    if (language == null) {
      return defaultMorphMapping;
    }

    // does not differ based on locale
    final langCodeShort = language.langCodeShort;

    // check if we have a cached morphs for this language code
    final cachedJson = _morphsStorage.read(langCodeShort);
    if (cachedJson != null) {
      return MorphsRepo.fromJson(cachedJson);
    }

    // check if we have a cached call for this language code
    final _APICallCacheItem? cachedCall = shortTermCache[langCodeShort];
    if (cachedCall != null) {
      if (DateTime.now().difference(cachedCall.time).inMinutes <
          _cacheDurationMinutes) {
        return cachedCall.future;
      } else {
        shortTermCache.remove(langCodeShort);
      }
    }

    // fetch the morphs but don't wait for it
    final future = _fetch(langCodeShort);
    shortTermCache[langCodeShort] = _APICallCacheItem(DateTime.now(), future);
    return future;
  }

  static MorphFeaturesAndTags get cached {
    if (MatrixState.pangeaController.languageController.userL2?.langCodeShort ==
        null) {
      return defaultMorphMapping;
    }
    final cachedJson = _morphsStorage.read(
      MatrixState.pangeaController.languageController.userL2!.langCodeShort,
    );
    if (cachedJson != null) {
      return MorphsRepo.fromJson(cachedJson);
    }
    return defaultMorphMapping;
  }
}
