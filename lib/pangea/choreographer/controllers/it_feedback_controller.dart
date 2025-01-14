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

class ITFeedbackController {
  late PangeaController _pangeaController;

  final List<_ITFeedbackCacheItem> _feedback = [];

  ITFeedbackController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  _ITFeedbackCacheItem? _getLocal(
    ITFeedbackRequestModel req,
  ) =>
      _feedback.firstWhereOrNull(
        (e) =>
            e.chosenContinuance == req.chosenContinuance &&
            e.sourceText == req.sourceText,
      );

  Future<ITFeedbackResponseModel?> get(
    ITFeedbackRequestModel req,
  ) {
    final _ITFeedbackCacheItem? localItem = _getLocal(req);

    if (localItem != null) return localItem.data;

    _feedback.add(
      _ITFeedbackCacheItem(
        chosenContinuance: req.chosenContinuance,
        sourceText: req.sourceText,
        data: _get(req),
      ),
    );

    return _feedback.last.data;
  }

  Future<ITFeedbackResponseModel?> _get(
    ITFeedbackRequestModel request,
  ) async {
    try {
      final ITFeedbackResponseModel res = await _ITFeedbackRepo.get(
        _pangeaController.userController.accessToken,
        request,
      );
      return res;
    } catch (err, stack) {
      debugPrint(
        "error getting contextual definition for ${request.chosenContinuance} in '${request.sourceText}'",
      );
      ErrorHandler.logError(e: err, s: stack, data: request.toJson());
      return null;
    }
  }
}

class _ITFeedbackCacheItem {
  String chosenContinuance;
  String sourceText;
  Future<ITFeedbackResponseModel?> data;

  _ITFeedbackCacheItem({
    required this.chosenContinuance,
    required this.sourceText,
    required this.data,
  });
}

class _ITFeedbackRepo {
  static Future<ITFeedbackResponseModel> get(
    String accessToken,
    ITFeedbackRequestModel request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.itFeedback,
      body: request.toJson(),
    );

    final ITFeedbackResponseModel response = ITFeedbackResponseModel.fromJson(
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

class ITFeedbackRequestModel {
  final String sourceText;
  final String currentText;
  final String bestContinuance;
  final String chosenContinuance;
  final String feedbackLang;
  final String sourceTextLang;
  final String targetLang;

  ITFeedbackRequestModel({
    required this.sourceText,
    required this.currentText,
    required this.bestContinuance,
    required this.chosenContinuance,
    required this.feedbackLang,
    required this.sourceTextLang,
    required this.targetLang,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.sourceText: sourceText,
        ModelKey.currentText: currentText,
        ModelKey.bestContinuance: bestContinuance,
        ModelKey.chosenContinuance: chosenContinuance,
        ModelKey.feedbackLang: feedbackLang,
        ModelKey.srcLang: sourceTextLang,
        ModelKey.tgtLang: targetLang,
      };
}

class ITFeedbackResponseModel {
  String text;

  ITFeedbackResponseModel({required this.text});

  factory ITFeedbackResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      ITFeedbackResponseModel(text: json[ModelKey.text]);
}
