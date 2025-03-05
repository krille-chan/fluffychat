import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';

class LanguageDetectionRepo {
  static Future<LanguageDetectionResponse> get(
    String? accessToken, {
    required LanguageDetectionRequest request,
  }) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.post(
      url: PApiUrls.languageDetection,
      body: request.toJson(),
    );

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(res.bodyBytes).toString());

    final LanguageDetectionResponse response =
        LanguageDetectionResponse.fromJson(json);

    return response;
  }
}

class LanguageDetectionRequest {
  final String text;
  final String? senderl1;
  final String? senderl2;

  LanguageDetectionRequest({
    required this.text,
    this.senderl1,
    this.senderl2,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_text': text,
      'sender_l1': senderl1,
      'sender_l2': senderl2,
    };
  }
}

class LanguageDetectionResponse {
  List<LanguageDetection> detections;
  String fullText;

  LanguageDetectionResponse({
    required this.detections,
    required this.fullText,
  });

  factory LanguageDetectionResponse.fromJson(Map<String, dynamic> json) {
    return LanguageDetectionResponse(
      detections: List<LanguageDetection>.from(
        (json['detections'] as Iterable).map(
          (e) => LanguageDetection.fromJson(e),
        ),
      ),
      fullText: json['full_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detections': detections.map((e) => e.toJson()).toList(),
      'full_text': fullText,
    };
  }
}
