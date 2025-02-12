import 'dart:convert';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/events/models/content_feedback.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class LemmaInfoRepo {
  static final GetStorage _lemmaStorage = GetStorage('lemma_storage');
  static final GetStorage _lemmaStorageExpireAt =
      GetStorage('lemma_storage_expire_at');

  static void set(
    LemmaInfoRequest request,
    LemmaInfoResponse response, [
    int ttlSeconds = 60, // 1 minute
  ]) {
    _lemmaStorage.write(request.storageKey, response.toJson());
    _lemmaStorageExpireAt.write(
      request.storageKey,
      DateTime.now().millisecondsSinceEpoch + ttlSeconds * 1000,
    );
  }

  static Future<LemmaInfoResponse> get(
    LemmaInfoRequest request, [
    String? feedback,
    bool useExpireAt = false,
  ]) async {
    dynamic cachedJson;
    if (useExpireAt) {
      final expireAt = _lemmaStorageExpireAt.read(request.storageKey);
      if (expireAt == null) {
        cachedJson = null;
      } else if (DateTime.now().millisecondsSinceEpoch > expireAt) {
        cachedJson = null;
      } else {
        cachedJson = _lemmaStorage.read(request.storageKey);
      }
    } else {
      cachedJson = _lemmaStorage.read(request.storageKey);
    }

    final cached =
        cachedJson == null ? null : LemmaInfoResponse.fromJson(cachedJson);

    if (cached != null) {
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
