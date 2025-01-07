import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/choreographer/controllers/span_data_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/repo/igc_repo.dart';
import 'package:fluffychat/pangea/widgets/igc/span_card.dart';
import '../../models/span_card_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/overlay.dart';

class _IGCTextDataCacheItem {
  Future<IGCTextData> data;

  _IGCTextDataCacheItem({required this.data});
}

class IgcController {
  Choreographer choreographer;
  IGCTextData? igcTextData;
  Object? igcError;
  Completer<IGCTextData> igcCompleter = Completer();
  late SpanDataController spanDataController;

  // cache for IGC data and prev message
  final Map<int, _IGCTextDataCacheItem> _igcTextDataCache = {};

  Timer? _igcCacheClearTimer;

  IgcController(this.choreographer) {
    spanDataController = SpanDataController(choreographer);
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 1);
    _igcCacheClearTimer =
        Timer.periodic(duration, (Timer t) => _igcTextDataCache.clear());
  }

  Future<void> getIGCTextData({
    required bool onlyTokensAndLanguageDetection,
  }) async {
    try {
      if (choreographer.currentText.isEmpty) return clear();

      debugPrint('getIGCTextData called with ${choreographer.currentText}');
      debugPrint(
        'getIGCTextData called with tokensOnly = $onlyTokensAndLanguageDetection',
      );

      final IGCRequestBody reqBody = IGCRequestBody(
        fullText: choreographer.currentText,
        userId: choreographer.pangeaController.userController.userId!,
        userL1: choreographer.l1LangCode!,
        userL2: choreographer.l2LangCode!,
        enableIGC: choreographer.igcEnabled && !onlyTokensAndLanguageDetection,
        enableIT: choreographer.itEnabled && !onlyTokensAndLanguageDetection,
        prevMessages: prevMessages(),
      );

      if (_igcCacheClearTimer == null || !_igcCacheClearTimer!.isActive) {
        _initializeCacheClearing();
      }

      // Check if cached data exists
      if (_igcTextDataCache.containsKey(reqBody.hashCode)) {
        igcTextData = await _igcTextDataCache[reqBody.hashCode]!.data;
        return;
      }

      final igcFuture = IgcRepo.getIGC(
        choreographer.accessToken,
        igcRequest: reqBody,
      );
      _igcTextDataCache[reqBody.hashCode] =
          _IGCTextDataCacheItem(data: igcFuture);
      final IGCTextData igcTextDataResponse =
          await _igcTextDataCache[reqBody.hashCode]!.data;

      // this will happen when the user changes the input while igc is fetching results
      if (igcTextDataResponse.originalInput != choreographer.currentText) {
        return;
      }
      // get ignored matches from the original igcTextData
      // if the new matches are the same as the original match
      // could possibly change the status of the new match
      // thing is the same if the text we are trying to change is the smae
      // as the new text we are trying to change (suggestion is the same)

      // Check for duplicate or minor text changes that shouldn't trigger suggestions
      // checks for duplicate input

      igcTextData = igcTextDataResponse;

      // TODO - for each new match,
      // check if existing igcTextData has one and only one match with the same error text and correction
      // if so, keep the original match and discard the new one
      // if not, add the new match to the existing igcTextData

      // After fetching igc data, pre-call span details for each match optimistically.
      // This will make the loading of span details faster for the user
      if (igcTextData?.matches.isNotEmpty ?? false) {
        for (int i = 0; i < igcTextData!.matches.length; i++) {
          spanDataController.getSpanDetails(i);
        }
      }

      debugPrint("igc text ${igcTextData.toString()}");
    } catch (err, stack) {
      debugger(when: kDebugMode);
      choreographer.errorService.setError(
        ChoreoError(type: ChoreoErrorType.unknown, raw: err),
      );
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "onlyTokensAndLanguageDetection": onlyTokensAndLanguageDetection,
          "currentText": choreographer.currentText,
          "userL1": choreographer.l1LangCode,
          "userL2": choreographer.l2LangCode,
          "igcEnabled": choreographer.igcEnabled,
          "itEnabled": choreographer.itEnabled,
          "matches": igcTextData?.matches.map((e) => e.toJson()),
        },
      );
      clear();
    }
  }

  void showFirstMatch(BuildContext context) {
    if (igcTextData == null || igcTextData!.matches.isEmpty) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be calling showFirstMatch with this igcTextData.",
        s: StackTrace.current,
        data: {
          "igcTextData": igcTextData?.toJson(),
        },
      );
      return;
    }

    const int firstMatchIndex = 0;
    final PangeaMatch match = igcTextData!.matches[firstMatchIndex];

    if (match.isITStart &&
        // choreographer.itAutoPlayEnabled &&
        igcTextData != null) {
      choreographer.onITStart(igcTextData!.matches[firstMatchIndex]);
      return;
    }

    choreographer.chatController.inputFocus.unfocus();
    OverlayUtil.showPositionedCard(
      context: context,
      cardToShow: SpanCard(
        scm: SpanCardModel(
          matchIndex: firstMatchIndex,
          onReplacementSelect: choreographer.onReplacementSelect,
          onSentenceRewrite: (value) async {},
          onIgnore: () => choreographer.onIgnoreMatch(
            cursorOffset: match.match.offset,
          ),
          onITStart: () {
            if (choreographer.itEnabled && igcTextData != null) {
              choreographer.onITStart(igcTextData!.matches[firstMatchIndex]);
            }
          },
          choreographer: choreographer,
        ),
        roomId: choreographer.roomId,
      ),
      maxHeight: match.isITStart ? 260 : 350,
      maxWidth: 350,
      transformTargetId: choreographer.inputTransformTargetKey,
    );
  }

  /// Get the content of previous text and audio messages in chat.
  /// Passed to IGC request to add context.
  List<PreviousMessage> prevMessages({int numMessages = 5}) {
    final List<Event> events = choreographer.chatController.visibleEvents
        .where(
          (e) =>
              e.type == EventTypes.Message &&
              (e.messageType == MessageTypes.Text ||
                  e.messageType == MessageTypes.Audio),
        )
        .toList();

    final List<PreviousMessage> messages = [];
    for (final Event event in events) {
      final String? content = event.messageType == MessageTypes.Text
          ? event.content.toString()
          : PangeaMessageEvent(
              event: event,
              timeline: choreographer.chatController.timeline!,
              ownMessage: event.senderId ==
                  choreographer.pangeaController.matrixState.client.userID,
            )
              .getSpeechToTextLocal(
                choreographer.l1LangCode,
                choreographer.l2LangCode,
              )
              ?.transcript
              .text
              .trim(); // trim whitespace
      if (content == null) continue;
      messages.add(
        PreviousMessage(
          content: content,
          sender: event.senderId,
          timestamp: event.originServerTs,
        ),
      );
      if (messages.length >= numMessages) {
        return messages;
      }
    }
    return messages;
  }

  bool get hasRelevantIGCTextData {
    if (igcTextData == null) return false;

    if (igcTextData!.originalInput != choreographer.currentText) {
      debugPrint(
        "returning isIGCTextDataRelevant false because text has changed",
      );
      return false;
    }
    return true;
  }

  clear() {
    igcTextData = null;
    spanDataController.clearCache();
    spanDataController.dispose();
  }

  dispose() {
    clear();
    _igcTextDataCache.clear();
    _igcCacheClearTimer?.cancel();
  }
}
