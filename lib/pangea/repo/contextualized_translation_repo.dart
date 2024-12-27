import 'dart:convert';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/environment.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class ContextualizationTranslationRepo {
  static Future<ContextTranslationResponseModel> translate({
    required String accessToken,
    required ContextualTranslationRequestModel request,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.contextualizedTranslation,
      body: request.toJson(),
    );

    final ContextTranslationResponseModel response =
        ContextTranslationResponseModel.fromJson(
      jsonDecode(
        utf8.decode(res.bodyBytes).toString(),
      ),
    );

    if (response.translations.isEmpty) {
      ErrorHandler.logError(
        e: Exception(
          "empty translations in contextual translation response return",
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

class ContextualTranslationRequestModel {
  String fullText;
  String srcLangCode;
  String tgtLangCode;
  String userL1;
  String userL2;
  PangeaTokenText span;

  ContextualTranslationRequestModel({
    required this.fullText,
    required this.srcLangCode,
    required this.tgtLangCode,
    required this.span,
    required this.userL1,
    required this.userL2,
  });

  static const String _spanKey = "span";

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.srcLang: srcLangCode,
        ModelKey.tgtLang: tgtLangCode,
        _spanKey: span.toJson(),
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
      };
}

class ContextTranslationResponseModel {
  List<String> translations;

  ContextTranslationResponseModel({required this.translations});

  static const _translationsKey = "translation";

  factory ContextTranslationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<String> trans = json[_translationsKey] is List
        ? (json[_translationsKey] as List).map((e) => e.toString()).toList()
        : json[_translationsKey] != null
            ? [
                json[_translationsKey],
              ]
            : [];

    if (trans.isEmpty) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "ContextTranslationResponseModel with empty translations",
          data: {"response": json},
        ),
      );
    }

    return ContextTranslationResponseModel(
      translations: trans,
    );
  }
}
