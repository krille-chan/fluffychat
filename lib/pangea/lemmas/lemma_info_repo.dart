import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/events/models/content_feedback.dart';
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

  static Future<LemmaInfoResponse> get(
    LemmaInfoRequest request, [
    String? feedback,
    bool useExpireAt = false,
  ]) async {
    final cachedJson = _lemmaStorage.read(request.storageKey);

    final cached =
        cachedJson == null ? null : LemmaInfoResponse.fromJson(cachedJson);

    if (cached != null) {
      if (feedback == null) {
        // at this point we have a cache without feedback
        if (!useExpireAt) {
          // return cache as is if we're not using expireAt
          return cached;
        } else if (cached.expireAt != null) {
          if (DateTime.now().isBefore(cached.expireAt!)) {
            // return cache as is if we're using expireAt and it's set but not expired
            return cached;
          }
        }
        // we intentionally do not handle the case of expired at not set because
        // old caches won't have them set, and we want to trigger a new
        // choreo call
      } else {
        // we're adding this within the service to avoid needing to have the widgets
        // save state including the bad response
        request.feedback = ContentFeedback(
          cached,
          feedback,
        );
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

    return response;
  }
}
