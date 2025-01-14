import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';
import '../models/user_profile_search_model.dart';

class PUserRepo {
  static Future<UserProfileSearchResponse> searchUserProfiles({
    // List<String>? interests,
    String? targetLanguage,
    String? sourceLanguage,
    String? country,
    // String? speaks,
    String? pageNumber,
    required String accessToken,
    required int limit,
  }) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Map<String, dynamic> body = {};
    // if (interests != null) body[ModelKey.userInterests] = interests.toString();
    if (targetLanguage != null) {
      body[ModelKey.userTargetLanguage] = targetLanguage;
    }
    if (sourceLanguage != null) {
      body[ModelKey.userSourceLanguage] = sourceLanguage;
    }
    if (country != null) body[ModelKey.userCountry] = country;

    final String searchUrl =
        "${PApiUrls.searchUserProfiles}?limit=$limit${pageNumber != null ? '&page=$pageNumber' : ''}";

    final Response res = await req.post(
      url: searchUrl,
      body: body,
    );

    //PTODO - implement paginiation - make another call with next url

    return UserProfileSearchResponse.fromJson(jsonDecode(res.body));
  }
}
