import 'dart:convert';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:http/http.dart';

import '../models/user_model.dart';
import '../models/user_profile_search_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class PUserRepo {
  // static Future<PangeaProfileResponse?> repoCreatePangeaUser({
  //   required String userID,
  //   required String dob,
  //   required fullName,
  //   required String matrixAccessToken,
  // }) async {
  //   try {
  //     final Requests req = Requests(
  //       baseUrl: PApiUrls.baseAPI,
  //       matrixAccessToken: matrixAccessToken,
  //     );

  //     final Map<String, dynamic> body = {
  //       ModelKey.userFullName: fullName,
  //       ModelKey.userPangeaUserId: userID,
  //       ModelKey.userDateOfBirth: dob,
  //     };
  //     final resp = await req.post(
  //       url: PApiUrls.createUser,
  //       body: body,
  //     );
  //     return PangeaProfileResponse.fromJson(jsonDecode(resp.body));
  //   } catch (err, s) {
  //     ErrorHandler.logError(e: err, s: s);
  //     return null;
  //   }
  // }

  static Future<PangeaProfileResponse?> fetchPangeaUserInfo({
    required String userID,
    required String matrixAccessToken,
  }) async {
    Response res;
    try {
      final Requests req = Requests(
        baseUrl: PApiUrls.baseAPI,
        matrixAccessToken: matrixAccessToken,
      );
      res = await req.get(
        url: PApiUrls.userDetails,
        objectId: userID,
      );

      return PangeaProfileResponse.fromJson(jsonDecode(res.body));
    } catch (err) {
      //status code should be 400 - PTODO - check ffor this.
      log("Most likely a first signup and needs to make an account");
      return null;
    }
  }

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
      baseUrl: PApiUrls.baseAPI,
      accessToken: accessToken,
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
