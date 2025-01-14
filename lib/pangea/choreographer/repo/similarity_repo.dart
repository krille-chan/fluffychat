import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';

class SimilarityRepo {
  static Future<SimilartyResponseModel> get({
    required String accessToken,
    required SimilarityRequestModel request,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.similarity,
      body: request.toJson(),
    );

    final SimilartyResponseModel response = SimilartyResponseModel.fromJson(
      jsonDecode(
        utf8.decode(res.bodyBytes).toString(),
      ),
    );

    return response;
  }
}

class SimilarityRequestModel {
  String benchmark;
  List<String> toCompare;

  SimilarityRequestModel({required this.benchmark, required this.toCompare});

  Map<String, dynamic> toJson() => {
        "original": benchmark,
        "to_compare": toCompare,
      };
}

class SimilartyResponseModel {
  String benchmark;
  List<SimilarityScore> scores;

  SimilartyResponseModel({required this.benchmark, required this.scores});

  factory SimilartyResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      SimilartyResponseModel(
        benchmark: json["original"],
        scores: List<SimilarityScore>.from(
          json["scores"].map(
            (x) => SimilarityScore.fromJson(x),
          ),
        ),
      );

  SimilarityScore get highestScore {
    SimilarityScore highest = scores.first;
    for (final SimilarityScore score in scores) {
      if (score.score > highest.score) {
        highest = score;
      }
    }
    return highest;
  }

  bool userTranslationIsDifferentButBetter(String userTranslation) {
    return highestScore.text == userTranslation;
  }

  bool userTranslationIsSameAsBotTranslation(String userTranslation) {
    return highestScore.text == userTranslation &&
        scores.where((e) => e.text == userTranslation).length == 2;
  }

  num userScore(String userTranslation) {
    return scores.firstWhere((e) => e.text == userTranslation).score;
  }
}

class SimilarityScore {
  String text;
  double score;
  int index;

  SimilarityScore({
    required this.text,
    required this.score,
    required this.index,
  });

  factory SimilarityScore.fromJson(Map<String, dynamic> json) {
    return SimilarityScore(
      text: json["text"],
      score: json["score"],
      index: json["index"],
    );
  }
}
