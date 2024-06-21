import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/controllers/span_data_controller.dart';
import 'package:fluffychat/pangea/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/repo/igc_repo.dart';
import 'package:fluffychat/pangea/widgets/igc/span_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/language_detection_model.dart';
import '../../models/span_card_model.dart';
import '../../repo/tokens_repo.dart';
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

  Future<void> getIGCTextData({required bool tokensOnly}) async {
    try {
      if (choreographer.currentText.isEmpty) return clear();

      // the error spans are going to be reloaded, so clear the cache
      spanDataController.clearCache();
      debugPrint('getIGCTextData called with ${choreographer.currentText}');
      debugPrint('getIGCTextData called with tokensOnly = $tokensOnly');

      final IGCRequestBody reqBody = IGCRequestBody(
        fullText: choreographer.currentText,
        userL1: choreographer.l1LangCode!,
        userL2: choreographer.l2LangCode!,
        enableIGC: choreographer.igcEnabled && !tokensOnly,
        enableIT: choreographer.itEnabled && !tokensOnly,
        tokensOnly: tokensOnly,
      );

      final IGCTextData igcTextDataResponse = await IgcRepo.getIGC(
        await choreographer.accessToken,
        igcRequest: reqBody,
      );
      // temp fix
      igcTextDataResponse.originalInput = reqBody.fullText;

      //this will happen when the user changes the input while igc is fetching results
      if (igcTextDataResponse.originalInput != choreographer.currentText) {
        // final current = choreographer.currentText;
        // final igctext = igcTextDataResponse.originalInput;
        // Sentry.addBreadcrumb(
        //   Breadcrumb(message: "igc return input does not match current text"),
        // );
        // debugger(when: kDebugMode);
        return;
      }

      //TO-DO: in api call, specify turning off IT and/or grammar checking
      if (!choreographer.igcEnabled) {
        igcTextDataResponse.matches = igcTextDataResponse.matches
            .where((match) => !match.isGrammarMatch)
            .toList();
      }
      if (!choreographer.itEnabled) {
        igcTextDataResponse.matches = igcTextDataResponse.matches
            .where((match) => !match.isOutOfTargetMatch)
            .toList();
      }
      if (!choreographer.itEnabled && !choreographer.igcEnabled) {
        igcTextDataResponse.matches = [];
      }

      igcTextData = igcTextDataResponse;

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

  Future<void> justGetTokensAndAddThemToIGCTextData() async {
    try {
      if (igcTextData == null) {
        debugger(when: kDebugMode);
        choreographer.getLanguageHelp();
        return;
      }
      igcTextData!.loading = true;
      choreographer.startLoading();
      if (igcTextData!.originalInput != choreographer.textController.text) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "igcTextData fullText does not match current text",
          s: StackTrace.current,
          data: igcTextData!.toJson(),
        );
      }

      if (choreographer.l1LangCode == null ||
          choreographer.l2LangCode == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "l1LangCode and/or l2LangCode is null",
          s: StackTrace.current,
          data: {
            "l1LangCode": choreographer.l1LangCode,
            "l2LangCode": choreographer.l2LangCode,
          },
        );
        return;
      }

      final TokensResponseModel res = await TokensRepo.tokenize(
        await choreographer.pangeaController.userController.accessToken,
        TokensRequestModel(
          fullText: igcTextData!.originalInput,
          userL1: choreographer.l1LangCode!,
          userL2: choreographer.l2LangCode!,
        ),
      );
      igcTextData?.tokens = res.tokens;
    } catch (err, stack) {
      debugger(when: kDebugMode);
      choreographer.errorService.setError(
        ChoreoError(type: ChoreoErrorType.unknown, raw: err),
      );
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"igctextDdata": igcTextData?.toJson()}),
      );
      ErrorHandler.logError(e: err, s: stack);
    } finally {
      igcTextData?.loading = false;
      choreographer.stopLoading();
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
      cardSize: match.isITStart ? const Size(350, 220) : const Size(350, 400),
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

  String? get detectedLangCode {
    if (!hasRelevantIGCTextData) return null;

    final LanguageDetection first = igcTextData!.detections.first;

    return first.langCode;
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
