import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import '../../common/constants/model_keys.dart';
import '../../common/controllers/pangea_controller.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';

class ContextualDefinitionController {
  late PangeaController _pangeaController;

  final List<_ContextualDefinitionCacheItem> _definitions = [];

  ContextualDefinitionController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  _ContextualDefinitionCacheItem? _getLocal(
    ContextualDefinitionRequestModel req,
  ) =>
      _definitions.firstWhereOrNull(
        (e) => e.word == req.word && e.fullText == req.fullText,
      );

  Future<ContextualDefinitionResponseModel?> get(
    ContextualDefinitionRequestModel req,
  ) {
    final _ContextualDefinitionCacheItem? localItem = _getLocal(req);

    if (localItem != null) return localItem.data;

    _definitions.add(
      _ContextualDefinitionCacheItem(
        word: req.word,
        fullText: req.fullText,
        data: _define(req),
      ),
    );

    return _definitions.last.data;
  }

  Future<ContextualDefinitionResponseModel?> _define(
    ContextualDefinitionRequestModel request,
  ) async {
    try {
      final ContextualDefinitionResponseModel res =
          await _ContextualDefinitionRepo.define(
        _pangeaController.userController.accessToken,
        request,
      );
      return res;
    } catch (err, stack) {
      debugPrint(
        "error getting contextual definition for ${request.word} in '${request.fullText}'",
      );
      ErrorHandler.logError(e: err, s: stack, data: request.toJson());
      return null;
    }
  }
}

class _ContextualDefinitionCacheItem {
  String word;
  String fullText;
  Future<ContextualDefinitionResponseModel?> data;

  _ContextualDefinitionCacheItem({
    required this.word,
    required this.fullText,
    required this.data,
  });
}

class _ContextualDefinitionRepo {
  static Future<ContextualDefinitionResponseModel> define(
    String accessToken,
    ContextualDefinitionRequestModel request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.contextualDefinition,
      body: request.toJson(),
    );

    final ContextualDefinitionResponseModel response =
        ContextualDefinitionResponseModel.fromJson(
      jsonDecode(
        utf8.decode(res.bodyBytes).toString(),
      ),
    );

    if (response.text.isEmpty) {
      ErrorHandler.logError(
        e: Exception(
          "empty text in contextual definition response",
        ),
        data: {
          "request": request.toJson(),
          "accessToken": accessToken,
        },
      );
    }

    return response;
  }
}

class ContextualDefinitionRequestModel {
  final String fullText;
  final String word;
  final String feedbackLang;
  final String fullTextLang;
  final String wordLang;

  ContextualDefinitionRequestModel({
    required this.fullText,
    required this.word,
    required this.feedbackLang,
    required this.fullTextLang,
    required this.wordLang,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.fullText: fullText,
        ModelKey.word: word,
        ModelKey.lang: feedbackLang,
        ModelKey.fullTextLang: fullTextLang,
        ModelKey.wordLang: wordLang,
      };
}

class ContextualDefinitionResponseModel {
  String text;

  ContextualDefinitionResponseModel({required this.text});

  factory ContextualDefinitionResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      ContextualDefinitionResponseModel(text: json["response"]);
}
