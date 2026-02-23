import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';

class LanguageRepo {
  static Future<Result<List<LanguageModel>>> get() async {
    try {
      final languages = await _fetch();
      return Result.value(languages);
    } catch (e) {
      return Result.error(e);
    }
  }

  /// Fetches languages directly from CMS REST API (public, no auth required).
  static Future<List<LanguageModel>> _fetch() async {
    final response = await http.get(
      Uri.parse('${PApiUrls.cmsLanguages}?limit=500&sort=language_name'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch languages from CMS: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final docs = json['docs'] as List;

    return docs
        .map((e) {
          try {
            return LanguageModel.fromJson(e as Map<String, dynamic>);
          } catch (err, stack) {
            debugger(when: kDebugMode);
            ErrorHandler.logError(e: err, s: stack, data: e);
            return null;
          }
        })
        .whereType<LanguageModel>()
        .toList();
  }
}
