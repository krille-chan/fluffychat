import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/events/repo/token_api_models.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import '../../choreographer/repo/full_text_translation_repo.dart';
import '../../common/utils/error_handler.dart';
import '../constants/pangea_event_types.dart';

// TODO - make this static and take it out of the _pangeaController
// will need to pass accessToken to the requests
class MessageDataController extends BaseController {
  late PangeaController _pangeaController;

  final Map<int, Future<List<PangeaToken>>> _tokensCache = {};
  final Map<int, Future<PangeaRepresentation>> _representationCache = {};
  late Timer _cacheTimer;

  MessageDataController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
    _startCacheTimer();
  }

  /// Starts a timer that clears the cache every 10 minutes
  void _startCacheTimer() {
    _cacheTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _clearCache();
    });
  }

  /// Clears the token and representation caches
  void _clearCache() {
    _tokensCache.clear();
    _representationCache.clear();
    debugPrint("message data cache cleared.");
  }

  @override
  void dispose() {
    _cacheTimer.cancel(); // Cancel the timer when the controller is disposed
    super.dispose();
  }

  /// get tokens from the server
  static Future<TokensResponseModel> _fetchTokens(
    String accessToken,
    TokensRequestModel request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.tokenize,
      body: request.toJson(),
    );

    final TokensResponseModel response = TokensResponseModel.fromJson(
      jsonDecode(
        utf8.decode(res.bodyBytes).toString(),
      ),
    );

    if (response.tokens.isEmpty) {
      ErrorHandler.logError(
        e: Exception(
          "empty tokens in tokenize response return",
        ),
        data: {
          "accessToken": accessToken,
          "request": request.toJson(),
        },
      );
    }

    return response;
  }

  /// get tokens from the server
  /// if repEventId is not null, send the tokens to the room
  Future<List<PangeaToken>> _getTokens({
    required String? repEventId,
    required TokensRequestModel req,
    required Room? room,
  }) async {
    final TokensResponseModel res = await _fetchTokens(
      _pangeaController.userController.accessToken,
      req,
    );
    if (repEventId != null && room != null) {
      room
          .sendPangeaEvent(
            content: PangeaMessageTokens(tokens: res.tokens).toJson(),
            parentEventId: repEventId,
            type: PangeaEventTypes.tokens,
          )
          .catchError(
            (e) => ErrorHandler.logError(
              m: "error in _getTokens.sendPangeaEvent",
              e: e,
              s: StackTrace.current,
              data: req.toJson(),
            ),
          );
    }

    return res.tokens;
  }

  /// get tokens from the server
  /// first check if the tokens are in the cache
  /// if repEventId is not null, send the tokens to the room
  Future<List<PangeaToken>> getTokens({
    required String? repEventId,
    required TokensRequestModel req,
    required Room? room,
  }) =>
      _tokensCache[req.hashCode] ??= _getTokens(
        repEventId: repEventId,
        req: req,
        room: room,
      );

  /////// translation ////////

  /// get translation from the server
  /// if in cache, return from cache
  /// if not in cache, get from server
  /// send the translation to the room as a representation event
  Future<PangeaRepresentation> getPangeaRepresentation({
    required FullTextTranslationRequestModel req,
    required Event messageEvent,
  }) async {
    return _representationCache[req.hashCode] ??=
        _getPangeaRepresentation(req: req, messageEvent: messageEvent);
  }

  Future<PangeaRepresentation> _getPangeaRepresentation({
    required FullTextTranslationRequestModel req,
    required Event messageEvent,
  }) async {
    final FullTextTranslationResponseModel res =
        await FullTextTranslationRepo.translate(
      accessToken: _pangeaController.userController.accessToken,
      request: req,
    );

    final rep = PangeaRepresentation(
      langCode: req.tgtLang,
      text: res.bestTranslation,
      originalSent: false,
      originalWritten: false,
    );

    messageEvent.room
        .sendPangeaEvent(
          content: rep.toJson(),
          parentEventId: messageEvent.eventId,
          type: PangeaEventTypes.representation,
        )
        .catchError(
          (e) => ErrorHandler.logError(
            m: "error in _getPangeaRepresentation.sendPangeaEvent",
            e: e,
            s: StackTrace.current,
            data: req.toJson(),
          ),
        );

    return rep;
  }

  Future<String?> getPangeaRepresentationEvent({
    required FullTextTranslationRequestModel req,
    required PangeaMessageEvent messageEvent,
    bool originalSent = false,
  }) async {
    final FullTextTranslationResponseModel res =
        await FullTextTranslationRepo.translate(
      accessToken: _pangeaController.userController.accessToken,
      request: req,
    );

    if (originalSent && messageEvent.originalSent != null) {
      originalSent = false;
    }

    final rep = PangeaRepresentation(
      langCode: req.tgtLang,
      text: res.bestTranslation,
      originalSent: originalSent,
      originalWritten: false,
    );

    try {
      final repEvent = await messageEvent.room.sendPangeaEvent(
        content: rep.toJson(),
        parentEventId: messageEvent.eventId,
        type: PangeaEventTypes.representation,
      );
      return repEvent?.eventId;
    } catch (e, s) {
      ErrorHandler.logError(
        m: "error in _getPangeaRepresentation.sendPangeaEvent",
        e: e,
        s: s,
        data: req.toJson(),
      );
      return null;
    }
  }

  Future<void> sendTokensEvent({
    required String repEventId,
    required TokensRequestModel req,
    required Room room,
  }) async {
    final TokensResponseModel res = await _fetchTokens(
      _pangeaController.userController.accessToken,
      req,
    );

    try {
      await room.sendPangeaEvent(
        content: PangeaMessageTokens(tokens: res.tokens).toJson(),
        parentEventId: repEventId,
        type: PangeaEventTypes.tokens,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        m: "error in _getTokens.sendPangeaEvent",
        e: e,
        s: s,
        data: req.toJson(),
      );
    }
  }
}
