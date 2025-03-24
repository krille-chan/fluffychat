import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import '../../common/network/requests.dart';

class LanguageRepo {
  static Future<List<LanguageModel>> fetchLanguages() async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
    );

    List<dynamic> languageResp = [];
    try {
      final Response res = await req.get(url: PApiUrls.getLanguages);
      languageResp = jsonDecode(utf8.decode(res.bodyBytes).toString()) as List;
    } catch (e) {
      languageResp = FallbackLanguage.languageList;
    }

    final List<LanguageModel> langFlag = languageResp.map((e) {
      try {
        return LanguageModel.fromJson(e);
      } catch (err, stack) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(e: err, s: stack, data: e);
        return LanguageModel.unknown;
      }
    }).toList();
    return langFlag;
  }
}
