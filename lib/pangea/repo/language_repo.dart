import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../network/requests.dart';

class LanguageRepo {
  static Future<List<LanguageModel>> fetchLanguages() async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.get(url: PApiUrls.getLanguages);

    final decodedBody =
        jsonDecode(utf8.decode(res.bodyBytes).toString()) as List;
    final List<LanguageModel> langFlag = decodedBody.map((e) {
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
