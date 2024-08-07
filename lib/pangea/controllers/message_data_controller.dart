import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/repo/tokens_repo.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/pangea_event_types.dart';
import '../enum/use_type.dart';
import '../models/choreo_record.dart';
import '../repo/full_text_translation_repo.dart';
import '../utils/error_handler.dart';

class MessageDataController extends BaseController {
  late PangeaController _pangeaController;

  final List<CacheItem> _cache = [];
  final List<RepresentationCacheItem> _representationCache = [];

  MessageDataController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  CacheItem? getItem(String parentId, String type, String langCode) =>
      _cache.firstWhereOrNull(
        (e) =>
            e.parentId == parentId && e.type == type && e.langCode == langCode,
      );

  RepresentationCacheItem? getRepresentationCacheItem(
    String parentId,
    String langCode,
  ) =>
      _representationCache.firstWhereOrNull(
        (e) => e.parentId == parentId && e.langCode == langCode,
      );

  Future<PangeaMessageTokens?> _getTokens(
    TokensRequestModel req,
  ) async {
    final accessToken = _pangeaController.userController.accessToken;

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
  Future<Event?> _sendRepresentationMatrixEvent({
    required PangeaRepresentation representation,
    required String messageEventId,
    required Room room,
  }) async {
    try {
      final Event? repEvent = await room.sendPangeaEvent(
        content: representation.toJson(),
        parentEventId: messageEventId,
        type: PangeaEventTypes.representation,
      );

      return repEvent;
    } catch (err, stack) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "err in _sendRepresentationMatrixEvent with messageEventId $messageEventId",
        ),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"room": room.toJson()}),
      );
      ErrorHandler.logError(e: err, s: stack);
      return null;
    }
  }

  Future<PangeaRepresentation?> getPangeaRepresentation({
    required String text,
    required String? source,
    required String target,
    required Room room,
  }) async {
    final RepresentationCacheItem? item =
        getRepresentationCacheItem(text, target);
    if (item != null) return item.data;

    _representationCache.add(
      RepresentationCacheItem(
        text,
        target,
        _getPangeaRepresentation(
          text: text,
          source: source,
          target: target,
          room: room,
        ),
      ),
    );

    return _representationCache.last.data;
  }

  Future<PangeaRepresentation?> _getPangeaRepresentation({
    required String text,
    required String? source,
    required String target,
    required Room room,
  }) async {
    if (_pangeaController.languageController.userL2 == null ||
        _pangeaController.languageController.userL1 == null) {
      ErrorHandler.logError(
        e: "userL1 or userL2 is null in _getPangeaRepresentation",
        s: StackTrace.current,
      );
      return null;
    }
    final req = FullTextTranslationRequestModel(
      text: text,
      tgtLang: target,
      srcLang: source,
      userL2: _pangeaController.languageController.userL2!.langCode,
      userL1: _pangeaController.languageController.userL1!.langCode,
    );

    try {
      final FullTextTranslationResponseModel res =
          await FullTextTranslationRepo.translate(
        accessToken: _pangeaController.userController.accessToken,
        request: req,
      );

      return PangeaRepresentation(
        langCode: req.tgtLang,
        text: res.bestTranslation,
        originalSent: false,
        originalWritten: false,
      );
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack);
      return null;
    }
  }

  /// make representation (originalSent and originalWritten always false)
  Future<Event?> sendRepresentationMatrixEvent({
    required PangeaRepresentation representation,
    required String messageEventId,
    required Room room,
    required String target,
  }) async {
    final CacheItem? item =
        getItem(messageEventId, PangeaEventTypes.representation, target);
    if (item != null) return item.data;

    _cache.add(
      CacheItem(
        messageEventId,
        PangeaEventTypes.representation,
        target,
        _sendRepresentationMatrixEvent(
          messageEventId: messageEventId,
          room: room,
          representation: representation,
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

class RepresentationCacheItem {
  String parentId;
  String langCode;
  Future<PangeaRepresentation?> data;

  RepresentationCacheItem(this.parentId, this.langCode, this.data);
}
