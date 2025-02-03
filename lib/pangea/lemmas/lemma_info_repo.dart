import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/content_feedback.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../common/config/environment.dart';
import '../common/network/requests.dart';

class LemmaInfoRepo {
  static final GetStorage _lemmaStorage = GetStorage('lemma_storage');

  static void set(LemmaInfoRequest request, LemmaInfoResponse response) {
    _lemmaStorage.write(request.storageKey, response.toJson());
  }

  static Future<LemmaInfoResponse> get(
    LemmaInfoRequest request, [
    String? feedback,
  ]) async {
    final cachedJson = _lemmaStorage.read(request.storageKey);

    if (cachedJson != null) {
      final cached = LemmaInfoResponse.fromJson(cachedJson);

      if (feedback == null) {
        // in this case, we just return the cached response
        return cached;
      } else {
        // we're adding this within the service to avoid needing to have the widgets
        // save state including the bad response
        request.feedback = ContentFeedback(
          cached,
          feedback,
        );
      }
    } else if (feedback != null) {
      // the cache should have the request in order for the user to provide feedback
      // this would be a strange situation and indicate some error in our logic
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: 'Feedback provided for a non-cached request',
        data: request.toJson(),
      );
    } else {
      debugPrint('No cached response for lemma ${request.lemma}, calling API');
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

    return response;
  }
}
