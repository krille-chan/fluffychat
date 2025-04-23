import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/repo/span_data_repo.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import '../../common/constants/model_keys.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';
import '../models/igc_text_data_model.dart';

class IgcRepo {
  static Future<IGCTextData> getIGC(
    String? accessToken, {
    required IGCRequestBody igcRequest,
  }) async {
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
      matches: [
        PangeaMatch(
          match: spanDataRepomockSpan,
          status: PangeaMatchStatus.open,
        ),
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

/// Previous text/audio message sent in chat
/// Contain message content, sender, and timestamp
class PreviousMessage {
  String content;
  String sender;
  DateTime timestamp;

  PreviousMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
  });

  factory PreviousMessage.fromJson(Map<String, dynamic> json) =>
      PreviousMessage(
        content: json[ModelKey.prevContent] ?? "",
        sender: json[ModelKey.prevSender] ?? "",
        timestamp: json[ModelKey.prevTimestamp] == null
            ? DateTime.now()
            : DateTime.parse(json[ModelKey.prevTimestamp]),
      );

  Map<String, dynamic> toJson() => {
        ModelKey.prevContent: content,
        ModelKey.prevSender: sender,
        ModelKey.prevTimestamp: timestamp.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! PreviousMessage) return false;

    return content == other.content &&
        sender == other.sender &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      content,
      sender,
      timestamp,
    );
  }
}

class IGCRequestBody {
  String fullText;
  String userL1;
  String userL2;
  bool enableIT;
  bool enableIGC;
  String userId;
  List<PreviousMessage> prevMessages;

  IGCRequestBody({
    required this.fullText,
    required this.userL1,
    required this.userL2,
    required this.enableIGC,
    required this.enableIT,
    required this.userId,
    required this.prevMessages,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
        ModelKey.userId: userId,
        ModelKey.prevMessages:
            jsonEncode(prevMessages.map((x) => x.toJson()).toList()),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! IGCRequestBody) return false;

    return fullText.trim() == other.fullText.trim() &&
        fullText == other.fullText &&
        userL1 == other.userL1 &&
        userL2 == other.userL2 &&
        enableIT == other.enableIT &&
        userId == other.userId;
  }

  @override
  int get hashCode => Object.hash(
        fullText.trim(),
        userL1,
        userL2,
        enableIT,
        enableIGC,
        userId,
        Object.hashAll(prevMessages),
      );
}
