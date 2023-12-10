import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/span_data.dart';
import 'package:fluffychat/pangea/repo/igc_repo.dart';
import 'package:fluffychat/pangea/widgets/igc/span_card.dart';
import '../../../widgets/matrix.dart';
import '../../models/language_detection_model.dart';
import '../../models/span_card_model.dart';
import '../../repo/span_data_repo.dart';
import '../../repo/tokens_repo.dart';
import '../../utils/error_handler.dart';
import '../../utils/overlay.dart';

class IgcController {
  Choreographer choreographer;
  IGCTextData? igcTextData;
  Object? igcError;

  Completer<IGCTextData> igcCompleter = Completer();

  IgcController(this.choreographer);

  Future<void> getIGCTextData({required bool tokensOnly}) async {
    try {
      if (choreographer.currentText.isEmpty) return clear();

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

  Future<void> getSpanDetails(int matchIndex) async {
    if (igcTextData == null ||
        igcTextData!.matches.isEmpty ||
        matchIndex < 0 ||
        matchIndex >= igcTextData!.matches.length) {
      debugger(when: kDebugMode);
      return;
    }
    final SpanData span = igcTextData!.matches[matchIndex].match;

    final SpanDetailsRepoReqAndRes response = await SpanDataRepo.getSpanDetails(
      await choreographer.accessToken,
      request: SpanDetailsRepoReqAndRes(
        userL1: choreographer.l1LangCode!,
        userL2: choreographer.l2LangCode!,
        enableIGC: choreographer.igcEnabled,
        enableIT: choreographer.itEnabled,
        span: span,
      ),
    );

    igcTextData!.matches[matchIndex].match = response.span;

    choreographer.setState();
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
      igcTextData!.loading = false;
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
            if (choreographer.itEnabled) {
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
    MatrixState.pAnyState.closeOverlay();
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
