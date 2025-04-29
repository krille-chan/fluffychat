import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructSummary {
  final int upperLevel;
  final int lowerLevel;
  final String language;
  final String textSummary;
  final int writingConstructScore;
  final int readingConstructScore;
  final int hearingConstructScore;
  final int speakingConstructScore;

  ConstructSummary({
    required this.upperLevel,
    required this.lowerLevel,
    required this.language,
    required this.textSummary,
    required this.writingConstructScore,
    required this.readingConstructScore,
    required this.hearingConstructScore,
    required this.speakingConstructScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'upper_level': upperLevel,
      'lower_level': lowerLevel,
      'language': language,
      'text_summary': textSummary,
      'writing_construct_score': writingConstructScore,
      'reading_construct_score': readingConstructScore,
      'hearing_construct_score': hearingConstructScore,
      'speaking_construct_score': speakingConstructScore,
    };
  }

  factory ConstructSummary.fromJson(Map<String, dynamic> json) {
    return ConstructSummary(
      upperLevel: json['upper_level'],
      lowerLevel: json['lower_level'],
      language: json['language'],
      textSummary: json['text_summary'],
      writingConstructScore: json['writing_construct_score'],
      readingConstructScore: json['reading_construct_score'],
      hearingConstructScore: json['hearing_construct_score'],
      speakingConstructScore: json['speaking_construct_score'],
    );
  }
}

class ConstructSummaryRequest {
  final List<OneConstructUse> constructs;
  final List<String?>? constructUseMessageContentBodies;
  final String language;
  final int upperLevel;
  final int lowerLevel;

  ConstructSummaryRequest({
    required this.constructs,
    this.constructUseMessageContentBodies,
    required this.language,
    required this.upperLevel,
    required this.lowerLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'constructs': constructs.map((construct) => construct.toJson()).toList(),
      'construct_use_message_content_bodies': constructUseMessageContentBodies,
      'language': language,
      'upper_level': upperLevel,
      'lower_level': lowerLevel,
    };
  }

  factory ConstructSummaryRequest.fromJson(Map<String, dynamic> json) {
    return ConstructSummaryRequest(
      constructs: (json['constructs'] as List)
          .map((construct) => OneConstructUse.fromJson(construct))
          .toList(),
      constructUseMessageContentBodies:
          List<String>.from(json['construct_use_message_content_bodies']),
      language: json['language'],
      upperLevel: json['upper_level'],
      lowerLevel: json['lower_level'],
    );
  }
}

class ConstructSummaryResponse {
  final ConstructSummary summary;

  ConstructSummaryResponse({
    required this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
    };
  }

  factory ConstructSummaryResponse.fromJson(Map<String, dynamic> json) {
    return ConstructSummaryResponse(
      summary: ConstructSummary.fromJson(json['summary']),
    );
  }
}

class ConstructRepo {
  static Future<ConstructSummaryResponse> generateConstructSummary(
    ConstructSummaryRequest request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );
    final Response res =
        await req.post(url: PApiUrls.constructSummary, body: request.toJson());
    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ConstructSummaryResponse.fromJson(decodedBody);
    return response;
  }
}
