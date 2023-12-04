import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/enum/span_choice_type.dart';
import 'package:fluffychat/pangea/enum/span_data_type.dart';
import 'package:fluffychat/pangea/models/span_data.dart';
import '../constants/model_keys.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class SpanDataRepo {
  static Future<SpanDetailsRepoReqAndRes> getSpanDetails(String? accessToken,
      {required SpanDetailsRepoReqAndRes request,}) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.post(
      url: PApiUrls.spanDetails,
      body: request.toJson(),
    );

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes).toString());

    return SpanDetailsRepoReqAndRes.fromJson(json);
  }
}

Future<SpanDetailsRepoReqAndRes> getMock(SpanDetailsRepoReqAndRes req) async {
  await Future.delayed(const Duration(seconds: 2));
  if (req.span.choices != null &&
      req.span.choices!.any((element) => element.selected)) {
    return req..span = mockReponseWithHintOne.span;
  } else {
    return req..span = mockReponseWithChoices.span;
  }
}

class SpanDetailsRepoReqAndRes {
  String userL1;
  String userL2;
  bool enableIT;
  bool enableIGC;
  SpanData span;

  SpanDetailsRepoReqAndRes({
    required this.userL1,
    required this.userL2,
    required this.enableIGC,
    required this.enableIT,
    required this.span,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
        'span': span.toJson(),
      };

  factory SpanDetailsRepoReqAndRes.fromJson(Map<String, dynamic> json) =>
      SpanDetailsRepoReqAndRes(
        userL1: json['user_l1'] as String,
        userL2: json['user_l2'] as String,
        enableIT: json['enable_it'] as bool,
        enableIGC: json['enable_igc'] as bool,
        span: SpanData.fromJson(json['span']),
      );
}

final spanDataRepomockSpan = SpanData(
  offset: 5,
  length: 2,
  fullText: "This be a sample text",
  type: SpanDataType(typeName: SpanDataTypeEnum.correction),
  context: null,
  choices: [SpanChoice(value: "is", type: SpanChoiceType.bestCorrection)],
  message: null,
  rule: null,
  shortMessage: null,
);

//json mock request
final mockRequest = SpanDetailsRepoReqAndRes(
  userL1: "es",
  userL2: "en",
  enableIGC: true,
  enableIT: true,
  span: spanDataRepomockSpan,
);

SpanDetailsRepoReqAndRes get mockReponseWithChoices {
  final SpanDetailsRepoReqAndRes res = mockRequest;
  res.span.choices = [
    SpanChoice(value: "is", type: SpanChoiceType.bestCorrection),
    SpanChoice(value: "are", type: SpanChoiceType.distractor),
    SpanChoice(value: "was", type: SpanChoiceType.distractor),
  ];
  return res;
}

SpanDetailsRepoReqAndRes get mockReponseWithHintOne {
  final SpanDetailsRepoReqAndRes res = mockReponseWithChoices;
  res.span.choices![1].selected = true;
  res.span.message = "Conjugation error";
  return res;
}
