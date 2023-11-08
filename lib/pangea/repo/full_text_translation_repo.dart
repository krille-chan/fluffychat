//Question for Jordan - is this for an individual token or could it be a span?

import 'dart:convert';

import 'package:http/http.dart';

import '../config/environment.dart';
import '../constants/model_keys.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class FullTextTranslationRepo {
  static Future<FullTextTranslationResponseModel> translate({
    required String accessToken,
    required FullTextTranslationRequestModel request,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.simpleTranslation,
      body: request.toJson(),
    );

    return FullTextTranslationResponseModel.fromJson(
      jsonDecode(utf8.decode(res.bodyBytes)),
    );
  }
}

class FullTextTranslationRequestModel {
  String text;
  String? srcLang;
  String tgtLang;
  String userL1;
  String userL2;
  bool? deepL;

  FullTextTranslationRequestModel({
    required this.text,
    this.srcLang,
    required this.tgtLang,
    required this.userL2,
    required this.userL1,
    this.deepL = false,
  });

  //PTODO throw error for null

  Map<String, dynamic> toJson() => {
        "text": text,
        ModelKey.srcLang: srcLang,
        ModelKey.tgtLang: tgtLang,
        ModelKey.userL2: userL2,
        ModelKey.userL1: userL1,
        ModelKey.deepL: deepL
      };
}

class FullTextTranslationResponseModel {
  List<String> translations;

  /// detected source
  /// PTODO -
  String source;
  String? deepL;

  FullTextTranslationResponseModel({
    required this.translations,
    required this.source,
    required this.deepL,
  });

  factory FullTextTranslationResponseModel.fromJson(Map<String, dynamic> json) {
    return FullTextTranslationResponseModel(
        translations: (json["translations"] as Iterable)
            .map<String>(
              (e) => e,
            )
            .toList()
            .cast<String>(),
      source: json[ModelKey.srcLang],
      deepL: json['deepl_res'],
    );
  }

  String get bestTranslation => deepL ?? translations.first;
}
