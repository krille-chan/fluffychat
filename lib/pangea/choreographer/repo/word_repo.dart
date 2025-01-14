import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import '../../common/constants/model_keys.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';
import '../models/word_data_model.dart';

class WordRepo {
  static Future<WordData> getWordNetData({
    required String accessToken,
    required String fullText,
    required String word,
    required String userL1,
    required String userL2,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );
    final Response res = await req.post(
      url: PApiUrls.wordNet,
      body: {
        ModelKey.word: word,
        ModelKey.fullText: fullText,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
      },
    );

    final json = jsonDecode(utf8.decode(res.bodyBytes));

    final WordData wordData = WordData.fromJson(
      json,
      fullText: fullText,
      word: word,
      userL1: userL1,
      userL2: userL2,
    );

    return wordData;
  }
}
