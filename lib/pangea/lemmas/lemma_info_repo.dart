import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
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

  static LemmaInfoResponse? getCached(LemmaInfoRequest request) {
    final cachedJson = _lemmaStorage.read(request.storageKey);

    final cached =
        cachedJson == null ? null : LemmaInfoResponse.fromJson(cachedJson);

    if (cached != null) {
      if (DateTime.now().isBefore(cached.expireAt!)) {
        return cached;
      } else {
        _lemmaStorage.remove(request.storageKey);
      }
    }
    return null;
  }

  /// Get lemma info, prefering user set data over fetched data
  static Future<LemmaInfoResponse> get(LemmaInfoRequest request) async {
    final cached = getCached(request);
    if (cached != null) return cached;

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
