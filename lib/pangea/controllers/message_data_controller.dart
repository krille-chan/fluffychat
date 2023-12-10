import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/message_data_models.dart';
import 'package:fluffychat/pangea/repo/tokens_repo.dart';
import '../constants/pangea_event_types.dart';
import '../enum/use_type.dart';
import '../models/choreo_record.dart';
import '../repo/full_text_translation_repo.dart';
import '../utils/error_handler.dart';

class MessageDataController extends BaseController {
  late PangeaController _pangeaController;

  final List<CacheItem> _cache = [];

  final Map<String, MessageDataQueueItem> _messageDataToSave = {};

  MessageDataController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  CacheItem? getItem(String parentId, String type, String langCode) =>
      _cache.firstWhereOrNull(
        (e) =>
            e.parentId == parentId && e.type == type && e.langCode == langCode,
      );

  Future<PangeaMessageTokens?> _getTokens(
    TokensRequestModel req,
  ) async {
    final accessToken = await _pangeaController.userController.accessToken;

    final TokensResponseModel igcTextData =
        await TokensRepo.tokenize(accessToken, req);

    return PangeaMessageTokens(tokens: igcTextData.tokens);
  }

  Future<Event?> _getTokenEvent({
    required BuildContext context,
    required String repEventId,
    required TokensRequestModel req,
    required Room room,
  }) async {
    try {
      final PangeaMessageTokens? pangeaMessageTokens = await _getTokens(
        req,
      );
      if (pangeaMessageTokens == null) return null;

      final Event? tokensEvent = await room.sendPangeaEvent(
        content: pangeaMessageTokens.toJson(),
        parentEventId: repEventId,
        type: PangeaEventTypes.tokens,
      );

      return tokensEvent;
    } catch (err, stack) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "err in _getTokenEvent with repEventId $repEventId",
        ),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"req": req.toJson()}),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"room": room.toJson()}),
      );
      ErrorHandler.logError(e: err, s: stack);
      return null;
    }
  }

  Future<Event?> getTokenEvent({
    required BuildContext context,
    required String repEventId,
    required TokensRequestModel req,
    required Room room,
  }) async {
    final CacheItem? item =
        getItem(repEventId, PangeaEventTypes.tokens, req.userL2);
    if (item != null) return item.data;

    _cache.add(
      CacheItem(
        repEventId,
        PangeaEventTypes.tokens,
        req.userL2,
        _getTokenEvent(
          context: context,
          repEventId: repEventId,
          req: req,
          room: room,
        ),
      ),
    );

    return _cache.last.data;
  }

  /////// translation ////////

  /// make representation (originalSent and originalWritten always false)
  Future<Event?> _getRepresentationMatrixEvent({
    required BuildContext context,
    required String messageEventId,
    required FullTextTranslationRequestModel req,
    required Room room,
  }) async {
    try {
      final FullTextTranslationResponseModel res =
          await FullTextTranslationRepo.translate(
        accessToken: await _pangeaController.userController.accessToken,
        request: req,
      );

      final PangeaRepresentation representation = PangeaRepresentation(
        langCode: req.tgtLang,
        text: res.bestTranslation,
        originalSent: false,
        originalWritten: false,
      );

      final Event? repEvent = await room.sendPangeaEvent(
        content: representation.toJson(),
        parentEventId: messageEventId,
        type: PangeaEventTypes.representation,
      );

      debugger(when: kDebugMode && repEvent == null);

      return repEvent;
    } catch (err, stack) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "err in _getRepresentationMatrixEvent with messageEventId $messageEventId",
        ),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"req": req.toJson()}),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"room": room.toJson()}),
      );
      ErrorHandler.logError(e: err, s: stack);
      return null;
    }
  }

  /// make representation (originalSent and originalWritten always false)
  Future<Event?> getRepresentationMatrixEvent({
    required BuildContext context,
    required String messageEventId,
    required String text,
    required String? source,
    required String target,
    required Room room,
  }) {
    final CacheItem? item =
        getItem(messageEventId, PangeaEventTypes.representation, target);
    if (item != null) return item.data;

    _cache.add(
      CacheItem(
        messageEventId,
        PangeaEventTypes.representation,
        target,
        _getRepresentationMatrixEvent(
          context: context,
          messageEventId: messageEventId,
          req: FullTextTranslationRequestModel(
            text: text,
            tgtLang: target,
            srcLang: source,
            userL2: _pangeaController.languageController
                .activeL2Code(roomID: room.id)!,
            userL1: _pangeaController.languageController
                .activeL1Code(roomID: room.id)!,
          ),
          room: room,
        ),
      ),
    );

    return _cache.last.data;
  }
}

class MessageDataQueueItem {
  String transactionId;

  List<RepTokensAndRecord> repTokensAndRecords;

  UseType useType;

  MessageDataQueueItem(
    this.transactionId,
    this.repTokensAndRecords,
    this.useType,
    // required this.recentMessageRecord,
  );
}

class RepTokensAndRecord {
  PangeaRepresentation representation;
  ChoreoRecord? choreoRecord;
  PangeaMessageTokens? tokens;
  RepTokensAndRecord(this.representation, this.choreoRecord, this.tokens);

  Map<String, dynamic> toJson() => {
        "rep": representation.toJson(),
        "choreoRecord": choreoRecord?.toJson(),
        "tokens": tokens?.toJson(),
      };
}

class CacheItem {
  String parentId;
  String langCode;
  String type;
  Future<Event?> data;

  CacheItem(this.parentId, this.type, this.langCode, this.data);
}
