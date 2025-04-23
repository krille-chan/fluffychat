import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/repo/token_api_models.dart';

class TokensRepo {
  static Future<TokensResponseModel> get(
    String? accessToken, {
    required TokensRequestModel request,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.tokenize,
      body: request.toJson(),
    );

    final TokensResponseModel response = TokensResponseModel.fromJson(
      jsonDecode(
        utf8.decode(res.bodyBytes).toString(),
      ),
    );

    if (response.tokens.isEmpty) {
      ErrorHandler.logError(
        e: Exception(
          "empty tokens in tokenize response return",
        ),
        data: {
          "accessToken": accessToken,
          "request": request.toJson(),
        },
      );
    }

    return response;
  }
}
