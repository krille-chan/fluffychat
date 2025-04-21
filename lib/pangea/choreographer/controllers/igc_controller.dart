import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/choreographer/controllers/span_data_controller.dart';
import 'package:fluffychat/pangea/choreographer/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/repo/igc_repo.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/span_card.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/error_handler.dart';
import '../../common/utils/overlay.dart';
import '../models/span_card_model.dart';

class _IGCTextDataCacheItem {
  Future<IGCTextData> data;

  _IGCTextDataCacheItem({required this.data});
}

class _IgnoredMatchCacheItem {
  PangeaMatch match;

  String get spanText => match.match.fullText.substring(
        match.match.offset,
        match.match.offset + match.match.length,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _IgnoredMatchCacheItem && other.spanText == spanText;
  }

  @override
  int get hashCode => spanText.hashCode;

  _IgnoredMatchCacheItem({required this.match});
}

class IgcController {
  Choreographer choreographer;
  IGCTextData? igcTextData;
  Object? igcError;
  Completer<IGCTextData> igcCompleter = Completer();
  late SpanDataController spanDataController;

  // cache for IGC data and prev message
  final Map<int, _IGCTextDataCacheItem> _igcTextDataCache = {};

  final Map<int, _IgnoredMatchCacheItem> _ignoredMatchCache = {};

  Timer? _cacheClearTimer;

  IgcController(this.choreographer) {
    spanDataController = SpanDataController(choreographer);
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 2);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) {
      _igcTextDataCache.clear();
      _ignoredMatchCache.clear();
    });
  }

  Future<void> getIGCTextData({
    required bool onlyTokensAndLanguageDetection,
  }) async {
    try {
      if (choreographer.currentText.isEmpty) return clear();

      // if tokenizing on message send, tokenization might take a while
      // so add a fake event to the timeline to visually indicate that the message is being sent
      if (onlyTokensAndLanguageDetection &&
          choreographer.choreoMode != ChoreoMode.it) {
        choreographer.chatController.sendFakeMessage();
      }

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

      if (_cacheClearTimer == null || !_cacheClearTimer!.isActive) {
        _initializeCacheClearing();
      }

      // if the request is not in the cache, add it
      if (!_igcTextDataCache.containsKey(reqBody.hashCode)) {
        _igcTextDataCache[reqBody.hashCode] = _IGCTextDataCacheItem(
          data: IgcRepo.getIGC(
            choreographer.accessToken,
            igcRequest: reqBody,
          ),
        );
      }

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

      final List<PangeaMatch> filteredMatches = List.from(igcTextData!.matches);
      for (final PangeaMatch match in igcTextData!.matches) {
        final _IgnoredMatchCacheItem cacheEntry =
            _IgnoredMatchCacheItem(match: match);

        if (_ignoredMatchCache.containsKey(cacheEntry.hashCode)) {
          filteredMatches.remove(match);
        }
      }

      // If there are any matches that don't match up with token offsets,
      // this indicates and choreographer bug. Remove them.
      final tokens = igcTextData!.tokens;
      final List<PangeaMatch> confirmedMatches = List.from(filteredMatches);
      for (final match in filteredMatches) {
        final substring = match.match.fullText.characters
            .skip(match.match.offset)
            .take(match.match.length);
        final trimmed = substring.toString().trim().characters;
        final matchOffset = (match.match.offset + match.match.length) -
            (substring.length - trimmed.length);
        final hasStartMatch = tokens.any(
          (token) => token.text.offset == match.match.offset,
        );
        final hasEndMatch = tokens.any(
          (token) => token.text.offset + token.text.length == matchOffset,
        );
        if (!hasStartMatch || !hasEndMatch) {
          confirmedMatches.clear();
          ErrorHandler.logError(
            m: "Match offset and/or length do not tokens with matching offset and length. This is a choreographer bug.",
            data: {
              "match": match.toJson(),
              "tokens": tokens.map((e) => e.toJson()).toList(),
            },
          );
          break;
        }
      }

      igcTextData!.matches = confirmedMatches;
      choreographer.acceptNormalizationMatches();

      // TODO - for each new match,
      // check if existing igcTextData has one and only one match with the same error text and correction
      // if so, keep the original match and discard the new one
      // if not, add the new match to the existing igcTextData

      // After fetching igc data, pre-call span details for each match optimistically.
      // This will make the loading of span details faster for the user
      if (igcTextData?.matches.isNotEmpty ?? false) {
        for (int i = 0; i < igcTextData!.matches.length; i++) {
          if (!igcTextData!.matches[i].isITStart) {
            spanDataController.getSpanDetails(i);
          }
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

  void onIgnoreMatch(PangeaMatch match) {
    final cacheEntry = _IgnoredMatchCacheItem(match: match);
    if (!_ignoredMatchCache.containsKey(cacheEntry.hashCode)) {
      _ignoredMatchCache[cacheEntry.hashCode] = cacheEntry;
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
    MatrixState.pAnyState.closeAllOverlays(RegExp(r'span_card_overlay_\d+'));
    OverlayUtil.showPositionedCard(
      overlayKey: "span_card_overlay_$firstMatchIndex",
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
      onDismiss: () => choreographer.setState(),
      ignorePointer: true,
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
    _ignoredMatchCache.clear();
    _cacheClearTimer?.cancel();
  }
}
