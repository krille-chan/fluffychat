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
  int? levelVocabConstructs;
  int? levelGrammarConstructs;
  final String language;
  final String textSummary;
  final int writingConstructScore;
  final int readingConstructScore;
  final int hearingConstructScore;
  final int speakingConstructScore;

  ConstructSummary({
    required this.upperLevel,
    required this.lowerLevel,
    this.levelVocabConstructs,
    this.levelGrammarConstructs,
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
      'level_grammar_constructs': levelGrammarConstructs,
      'level_vocab_constructs': levelVocabConstructs,
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
      levelGrammarConstructs: json['level_grammar_constructs'],
      levelVocabConstructs: json['level_vocab_constructs'],
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
  final List<Map<String, dynamic>> messages;
  final String userL1;
  final String userL2;
  final int upperLevel;
  final int lowerLevel;

  ConstructSummaryRequest({
    required this.constructs,
    required this.messages,
    required this.userL1,
    required this.userL2,
    required this.upperLevel,
    required this.lowerLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'constructs': constructs.map((construct) => construct.toJson()).toList(),
      'msgs': messages,
      'user_l1': userL1,
      'user_l2': userL2,
      'language': userL1,
      'upper_level': upperLevel,
      'lower_level': lowerLevel,
    };
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
