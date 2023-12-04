import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/models/language_detection_model.dart';
import 'package:fluffychat/pangea/models/lemma.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/repo/span_data_repo.dart';
import '../constants/model_keys.dart';
import '../models/igc_text_data_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class IgcRepo {
  static Future<IGCTextData> getIGC(String? accessToken,
      {required IGCRequestBody igcRequest}) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.post(
      url: PApiUrls.igcLite,
      body: igcRequest.toJson(),
    );

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes).toString());

    final IGCTextData response = IGCTextData.fromJson(json);

    return response;
  }

  static Future<IGCTextData> getMockData() async {
    await Future.delayed(const Duration(seconds: 2));

    final IGCTextData igcTextData = IGCTextData(
      detections: [LanguageDetection(langCode: "en")],
      tokens: [
        PangeaToken(
          text: PangeaTokenText(content: "This", offset: 0, length: 4),
          hasInfo: true,
          lemmas: [Lemma(form: "This", text: "this", saveVocab: true)],
        ),
        PangeaToken(
          text: PangeaTokenText(content: "be", offset: 5, length: 2),
          hasInfo: true,
          lemmas: [Lemma(form: "be", text: "be", saveVocab: true)],
        ),
        PangeaToken(
            text: PangeaTokenText(content: "a", offset: 8, length: 1),
            hasInfo: false,
            lemmas: []),
        PangeaToken(
            text: PangeaTokenText(content: "sample", offset: 10, length: 6),
            hasInfo: false,
            lemmas: []),
        PangeaToken(
            text: PangeaTokenText(content: "text", offset: 17, length: 4),
            hasInfo: false,
            lemmas: []),
      ],
      matches: [
        PangeaMatch(
            match: spanDataRepomockSpan, status: PangeaMatchStatus.open),
      ],
      originalInput: "This be a sample text",
      fullTextCorrection: "This is a sample text",
      userL1: "es",
      userL2: "en",
      enableIT: true,
      enableIGC: true,
    );

    return igcTextData;
  }
}

class IGCRequestBody {
  String fullText;
  String userL1;
  String userL2;
  bool tokensOnly;
  bool enableIT;
  bool enableIGC;

  IGCRequestBody({
    required this.fullText,
    required this.userL1,
    required this.userL2,
    required this.enableIGC,
    required this.enableIT,
    this.tokensOnly = false,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
        "tokens_only": tokensOnly,
      };
}
