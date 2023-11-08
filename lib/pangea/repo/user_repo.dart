import 'dart:convert';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:http/http.dart';

import '../../widgets/matrix.dart';
import '../models/user_model.dart';
import '../models/user_profile_search_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class PUserRepo {
  static Future<PUserModel> repoCreatePangeaUser({
    required String userID,
    required String dateOfBirth,
    required fullName,
    required String matrixAccessToken,
  }) async {
    final Requests req = Requests(
      baseUrl: PApiUrls.baseAPI,
      matrixAccessToken: matrixAccessToken,
    );

    final Map<String, dynamic> body = {
      ModelKey.userFullName: fullName,
      ModelKey.userPangeaUserId: userID,
      ModelKey.userDateOfBirth: dateOfBirth
    };
    final Response res = await req.post(
      url: PApiUrls.createUser,
      body: body,
    );
    return PUserModel.fromJson(jsonDecode(res.body));
  }

  static Future<PUserModel?> fetchPangeaUserInfo({
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

      return PUserModel.fromJson(jsonDecode(res.body));
    } catch (err) {
      //status code should be 400 - PTODO - check ffor this.
      log("Most likely a first signup and needs to make an account");
      return null;
    }
  }

  //notes for jordan - only replace non-null fields, return whole profile
  //Jordan - should return pangeaUserId as well
  static Future<Profile> updateUserProfile(
    Profile userProfile,
    String accessToken,
  ) async {
    final Requests req = Requests(
      baseUrl: PApiUrls.baseAPI,
      accessToken: accessToken,
    );
    final Response res = await req.put(
      url: PApiUrls.updateUserProfile,
      body: userProfile.toJson(),
    );

    //temp fix
    final content = jsonDecode(res.body);
    //PTODO - try taking this out and see where bug occurs
    if (content[ModelKey.userPangeaUserId] == null) {
      content[ModelKey.userPangeaUserId] =
          MatrixState.pangeaController.matrixState.client.userID;
    }

    return Profile.fromJson(content);
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
    // if (speaks != null) body[ModelKey.userSpeaks] = speaks;
    if (pageNumber != null) {
      body["page_number"] = pageNumber;
    }
    body["limit"] = limit;

    final Response res = await req.post(
      url: PApiUrls.searchUserProfiles,
      body: body,
    );

    //PTODO - implement paginiation - make another call with next url

    return UserProfileSearchResponse.fromJson(jsonDecode(res.body));
  }
}
