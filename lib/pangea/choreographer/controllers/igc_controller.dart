import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/choreographer/controllers/span_data_controller.dart';
import 'package:fluffychat/pangea/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/repo/igc_repo.dart';
import 'package:fluffychat/pangea/widgets/igc/span_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/span_card_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/overlay.dart';

class IgcController {
  Choreographer choreographer;
  IGCTextData? igcTextData;
  Object? igcError;
  Completer<IGCTextData> igcCompleter = Completer();
  late SpanDataController spanDataController;

  IgcController(this.choreographer) {
    spanDataController = SpanDataController(choreographer);
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
        userL1: choreographer.l1LangCode!,
        userL2: choreographer.l2LangCode!,
        enableIGC: choreographer.igcEnabled && !onlyTokensAndLanguageDetection,
        enableIT: choreographer.itEnabled && !onlyTokensAndLanguageDetection,
      );

      final IGCTextData igcTextDataResponse = await IgcRepo.getIGC(
        choreographer.accessToken,
        igcRequest: reqBody,
      );

      // this will happen when the user changes the input while igc is fetching results
      if (igcTextDataResponse.originalInput != choreographer.currentText) {
        return;
      }

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
      ErrorHandler.logError(e: err, s: stack);
      clear();
    }
  }

  void showFirstMatch(BuildContext context) {
    if (igcTextData == null || igcTextData!.matches.isEmpty) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be calling showFirstMatch with this igcTextData ${igcTextData?.toJson().toString()}",
        s: StackTrace.current,
      );
      return;
    }

    const int firstMatchIndex = 0;
    final PangeaMatch match = igcTextData!.matches[firstMatchIndex];

    if (match.isITStart &&
        choreographer.itAutoPlayEnabled &&
        igcTextData != null) {
      choreographer.onITStart(igcTextData!.matches[firstMatchIndex]);
      return;
    }

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
      cardSize: match.isITStart ? const Size(350, 260) : const Size(350, 400),
      transformTargetId: choreographer.inputTransformTargetKey,
    );
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
    // Not sure why this is here
    // MatrixState.pAnyState.closeOverlay();
  }

  bool get canSendMessage {
    if (choreographer.isFetching) return false;
    if (igcTextData == null ||
        choreographer.errorService.isError ||
        igcTextData!.matches.isEmpty) {
      return true;
    }

    return !((choreographer.itEnabled &&
            igcTextData!.matches.any((match) => match.isOutOfTargetMatch)) ||
        (choreographer.igcEnabled &&
            igcTextData!.matches.any((match) => !match.isOutOfTargetMatch)));
  }
}
