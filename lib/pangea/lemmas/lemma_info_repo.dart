import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaInfoRepo {
  static final GetStorage _lemmaStorage = GetStorage('lemma_storage');

  static void set(LemmaInfoRequest request, LemmaInfoResponse response) {
    // set expireAt if not set
    response.expireAt ??= DateTime.now().add(const Duration(days: 100));
    _lemmaStorage.write(request.storageKey, response.toJson());
  }

  static Future<LemmaInfoResponse> _fetch(LemmaInfoRequest request) async {
    final cachedJson = _lemmaStorage.read(request.storageKey);

    final cached =
        cachedJson == null ? null : LemmaInfoResponse.fromJson(cachedJson);

    if (cached != null) {
      if (DateTime.now().isBefore(cached.expireAt!)) {
        // return cache as is if we're using expireAt and it's set but not expired
        // debugPrint(
        //   'using cached data for ${request.lemma} ${cached.toJson()}',
        // );
        return cached;
      } else {
        // if it's expired, remove it
        _lemmaStorage.remove(request.storageKey);
      }
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.lemmaDictionary,
      body: request.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = LemmaInfoResponse.fromJson(decodedBody);

    set(request, response);

    // debugPrint(
    //   'fetched data for ${request.lemma} ${response.toJson()}',
    // );

    return response;
  }

  /// Get lemma info, prefering user set data over fetched data
  static Future<LemmaInfoResponse> get(LemmaInfoRequest request) async {
    try {
      return await _fetch(request);
      // if the user has either emojis or meaning in the past, use those first
      // final UserSetLemmaInfo? userSetLemmaInfo = request.cId.userLemmaInfo;

      // final List<String> emojis = userSetLemmaInfo?.emojis ?? [];
      // String? meaning = userSetLemmaInfo?.meaning;

      // if the user has not set these, fetch from the server
      // if (emojis.length < maxEmojisPerLemma || meaning == null) {
      // final LemmaInfoResponse fetched = await _fetch(request);

      //   while (emojis.length < maxEmojisPerLemma && fetched.emoji.isNotEmpty) {
      //     final maybeToAdd = fetched.emoji.removeAt(0);
      //     if (!emojis.contains(maybeToAdd)) {
      //       emojis.add(maybeToAdd);
      //     }
      //   }
      //   meaning ??= fetched.meaning;
      // } else {
      //   // debugPrint(
      //   //   'using user set data for ${request.lemma} ${userSetLemmaInfo?.toJson()}',
      //   // );
      // }

      // return LemmaInfoResponse(
      //   emoji: emojis,
      //   meaning: meaning,
      // );
    } catch (e) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, data: request.toJson());
      rethrow;
    }
  }
}
