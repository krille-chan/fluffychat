import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../config/environment.dart';
import '../models/pangea_token_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class TokensRepo {
  static Future<TokensResponseModel> tokenize(
    String accessToken,
    TokensRequestModel request,
  ) async {
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
      );
    }

    return response;
  }
}

class TokensRequestModel {
  String fullText;
  String userL1;
  String userL2;

  TokensRequestModel({
    required this.fullText,
    required this.userL1,
    required this.userL2,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
      };

  // override equals and hashcode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokensRequestModel &&
        other.fullText == fullText &&
        other.userL1 == userL1 &&
        other.userL2 == userL2;
  }

  @override
  int get hashCode => fullText.hashCode ^ userL1.hashCode ^ userL2.hashCode;
}

class TokensResponseModel {
  List<PangeaToken> tokens;
  String lang;

  TokensResponseModel({required this.tokens, required this.lang});

  factory TokensResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      TokensResponseModel(
        tokens: (json[ModelKey.tokens] as Iterable)
            .map<PangeaToken>(
              (e) => PangeaToken.fromJson(e as Map<String, dynamic>),
            )
            .toList()
            .cast<PangeaToken>(),
        lang: json[ModelKey.lang],
      );
}
