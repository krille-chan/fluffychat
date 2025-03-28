import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/choreographer/enums/edit_type.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import '../models/custom_input_translation_model.dart';
import '../models/it_response_model.dart';
import '../models/it_step.dart';
import '../repo/interactive_translation_repo.dart';
import 'choreographer.dart';

class ITController {
  Choreographer choreographer;

  bool _isOpen = false;
  bool _willOpen = false;
  bool _isEditingSourceText = false;
  bool showChoiceFeedback = false;
  bool dismissed = false;

  ITStartData? _itStartData;
  String? sourceText;
  List<ITStep> completedITSteps = [];
  CurrentITStep? currentITStep;
  Completer<CurrentITStep?>? nextITStep;
  GoldRouteTracker goldRouteTracker = GoldRouteTracker.defaultTracker;
  List<int> payLoadIds = [];

  ITController(this.choreographer);

  void clear() {
    _isOpen = false;
    _willOpen = false;
    showChoiceFeedback = false;
    _isEditingSourceText = false;
    dismissed = false;

    _itStartData = null;
    sourceText = null;
    completedITSteps = [];
    currentITStep = null;
    nextITStep = null;
    goldRouteTracker = GoldRouteTracker.defaultTracker;
    payLoadIds = [];

    choreographer.altTranslator.clear();
    choreographer.choreoMode = ChoreoMode.igc;
    choreographer.setState();
  }

  Duration get animationSpeed => const Duration(milliseconds: 500);

  Future<void> initializeIT(ITStartData itStartData) async {
    _willOpen = true;
    Future.delayed(const Duration(microseconds: 100), () {
      _isOpen = true;
    });
    _itStartData = itStartData;
  }

  void closeIT() {
    // if the user hasn't gone through any IT steps, reset the text
    if (completedITSteps.isEmpty && sourceText != null) {
      choreographer.textController.setSystemText(
        sourceText!,
        EditType.itDismissed,
      );
    }
    clear();
    dismissed = true;
  }

  /// if IGC isn't positive that text is full L1 then translate to L1
  Future<void> _setSourceText() async {
    if (_itStartData == null || _itStartData!.text.isEmpty) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "choreo context",
          data: {
            "igcTextData": choreographer.igc.igcTextData?.toJson(),
            "currentText": choreographer.currentText,
          },
        ),
      );
      throw Exception("null _itStartData or empty text in _setSourceText");
    }
    debugPrint("_setSourceText with detectedLang ${_itStartData!.langCode}");
    // if (_itStartData!.langCode == choreographer.l1LangCode) {
    sourceText = _itStartData!.text;
    return;
    // }

    // final FullTextTranslationResponseModel res =
    //     await FullTextTranslationRepo.translate(
    //   accessToken: await choreographer.accessToken,
    //   request: FullTextTranslationRequestModel(
    //     text: _itStartData!.text,
    //     tgtLang: choreographer.l1LangCode!,
    //     srcLang: _itStartData!.langCode,
    //     userL1: choreographer.l1LangCode!,
    //     userL2: choreographer.l2LangCode!,
    //   ),
    // );
    // sourceText = res.bestTranslation;
  }

  // used 1) at very beginning (with custom input = null)
  // and 2) if they make direct edits to the text field
  Future<void> getTranslationData(bool useCustomInput) async {
    try {
      choreographer.startLoading();

      final String currentText = choreographer.currentText;

      if (sourceText == null) await _setSourceText();

      if (useCustomInput && currentITStep != null) {
        completedITSteps.add(
          ITStep(
            currentITStep!.continuances,
            customInput: currentText,
          ),
        );
      }

      currentITStep = null;

      // During first IT step, next step will not be set
      if (nextITStep == null) {
        final ITResponseModel res = await _customInputTranslation(currentText);
        if (sourceText == null) return;

        if (res.goldContinuances != null && res.goldContinuances!.isNotEmpty) {
          goldRouteTracker = GoldRouteTracker(
            res.goldContinuances!,
            sourceText!,
          );
        }

        currentITStep = CurrentITStep(
          sourceText: sourceText!,
          currentText: currentText,
          responseModel: res,
          storedGoldContinuances: goldRouteTracker.continuances,
        );

        _addPayloadId(res);
      } else {
        currentITStep = await nextITStep!.future;
      }

      if (isTranslationDone) {
        nextITStep = null;
        choreographer.altTranslator.setTranslationFeedback();
        choreographer.getLanguageHelp(onlyTokensAndLanguageDetection: true);
      } else {
        nextITStep = Completer<CurrentITStep?>();
        final nextStep = await getNextTranslationData();
        nextITStep?.complete(nextStep);
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      if (e is! http.Response) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "currentText": choreographer.currentText,
            "sourceText": sourceText,
            "currentITStepPayloadID": currentITStep?.payloadId,
          },
        );
      }
      choreographer.errorService.setErrorAndLock(
        ChoreoError(type: ChoreoErrorType.unknown, raw: e),
      );
    } finally {
      choreographer.stopLoading();
    }
  }

  Future<CurrentITStep?> getNextTranslationData() async {
    if (sourceText == null) {
      ErrorHandler.logError(
        e: Exception("sourceText is null in getNextTranslationData"),
        data: {
          "sourceText": sourceText,
          "currentITStepPayloadID": currentITStep?.payloadId,
          "continuances": goldRouteTracker.continuances.map((e) => e.toJson()),
        },
      );
      return null;
    }

    if (completedITSteps.length >= goldRouteTracker.continuances.length) {
      return null;
    }

    try {
      final String currentText = choreographer.currentText;
      final String nextText =
          goldRouteTracker.continuances[completedITSteps.length].text;

      final ITResponseModel res =
          await _customInputTranslation(currentText + nextText);
      if (sourceText == null) return null;

      return CurrentITStep(
        sourceText: sourceText!,
        currentText: nextText,
        responseModel: res,
        storedGoldContinuances: goldRouteTracker.continuances,
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      if (e is! http.Response) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "sourceText": sourceText,
            "currentITStepPayloadID": currentITStep?.payloadId,
            "continuances":
                goldRouteTracker.continuances.map((e) => e.toJson()),
          },
        );
      }
      choreographer.errorService.setErrorAndLock(
        ChoreoError(type: ChoreoErrorType.unknown, raw: e),
      );
    } finally {
      choreographer.stopLoading();
    }
    return null;
  }

  Future<void> onEditSourceTextSubmit(String newSourceText) async {
    try {
      _isOpen = true;
      _isEditingSourceText = false;
      _itStartData = ITStartData(newSourceText, choreographer.l1LangCode);
      completedITSteps = [];
      currentITStep = null;
      nextITStep = null;
      goldRouteTracker = GoldRouteTracker.defaultTracker;
      payLoadIds = [];

      _setSourceText();
      getTranslationData(false);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      if (err is! http.Response) {
        ErrorHandler.logError(
          e: err,
          s: stack,
          data: {
            "newSourceText": newSourceText,
            "l1Lang": choreographer.l1LangCode,
          },
        );
      }
      choreographer.errorService.setErrorAndLock(
        ChoreoError(type: ChoreoErrorType.unknown, raw: err),
      );
    } finally {
      choreographer.stopLoading();
      choreographer.textController.setSystemText(
        "",
        EditType.other,
      );
    }
  }

  Future<ITResponseModel> _customInputTranslation(String textInput) async {
    return ITRepo.customInputTranslate(
      CustomInputRequestModel(
        //this should be set by this time
        text: sourceText!,
        customInput: textInput,
        sourceLangCode: sourceLangCode,
        targetLangCode: targetLangCode,
        userId: choreographer.userId!,
        roomId: choreographer.roomId!,
        goldTranslation: goldRouteTracker.fullTranslation,
        goldContinuances: goldRouteTracker.continuances,
      ),
    );
  }

  // MessageServiceModel? messageServiceModelWithMessageId() =>
  //     usedInteractiveTranslation
  //         ? MessageServiceModel(
  //             classId: choreographer.classId,
  //             roomId: choreographer.roomId,
  //             message: choreographer.currentText,
  //             messageId: null,
  //             payloadIds: payLoadIds,
  //             userId: choreographer.userId!,
  //             l1Lang: sourceLangCode,
  //             l2Lang: targetLangCode,
  //           )
  //         : null;

  //maybe we store IT data in the same format? make a specific kind of match?
  void selectTranslation(int chosenIndex) {
    if (currentITStep == null) return;
    final itStep = ITStep(currentITStep!.continuances, chosen: chosenIndex);

    completedITSteps.add(itStep);

    showChoiceFeedback = true;

    // Get a list of the choices that the user did not click
    final List<PangeaToken>? ignoredTokens = currentITStep?.continuances
        .where((e) => !e.wasClicked)
        .map((e) => e.tokens)
        .expand((e) => e)
        .toList();

    // Save those choices' tokens to local construct analytics as ignored tokens
    choreographer.pangeaController.putAnalytics.addDraftUses(
      ignoredTokens ?? [],
      choreographer.roomId,
      ConstructUseTypeEnum.ignIt,
    );

    Future.delayed(
      const Duration(
        milliseconds: ChoreoConstants.millisecondsToDisplayFeedback,
      ),
      () {
        showChoiceFeedback = false;
        choreographer.setState();
      },
    );

    choreographer.onITChoiceSelect(itStep);
    choreographer.setState();
  }

  String get uniqueKeyForLayerLink => "itChoices${choreographer.roomId}";

  void _addPayloadId(ITResponseModel res) {
    payLoadIds.add(res.payloadId);
  }

  bool get usedInteractiveTranslation => sourceText != null;

  bool get isTranslationDone => currentITStep != null && currentITStep!.isFinal;

  bool get isOpen => _isOpen;

  bool get willOpen => _willOpen;

  String get targetLangCode => choreographer.l2LangCode!;

  String get sourceLangCode => choreographer.l1LangCode!;

  bool get isLoading => choreographer.isFetching;

  String latestChoiceFeedback(BuildContext context) =>
      completedITSteps.isNotEmpty
          ? completedITSteps.last.choiceFeedback(context)
          : "";

  // String translationFeedback(BuildContext context) =>
  //     completedITSteps.isNotEmpty
  //         ? completedITSteps.last.translationFeedback(context)
  //         : "";

  bool get showAlternativeTranslationsOption => completedITSteps.isNotEmpty
      ? completedITSteps.last.showAlternativeTranslationOption &&
          sourceText != null
      : false;

  setIsEditingSourceText(bool value) {
    _isEditingSourceText = value;
    choreographer.setState();
  }

  bool get isEditingSourceText => _isEditingSourceText;

  int get correctChoices =>
      completedITSteps.where((element) => element.isCorrect).length;

  int get wildcardChoices =>
      completedITSteps.where((element) => element.isYellow).length;

  int get incorrectChoices =>
      completedITSteps.where((element) => element.isWrong).length;

  int get customChoices =>
      completedITSteps.where((element) => element.isCustom).length;

  bool get allCorrect => completedITSteps.every((element) => element.isCorrect);
}

class ITStartData {
  String text;
  String? langCode;

  ITStartData(this.text, this.langCode);
}

class GoldRouteTracker {
  late String _originalText;
  List<Continuance> continuances;

  GoldRouteTracker(this.continuances, String originalText) {
    _originalText = originalText;
  }

  static get defaultTracker => GoldRouteTracker([], "");

  Continuance? currentContinuance({
    required String currentText,
    required String sourceText,
  }) {
    if (_originalText != sourceText) {
      debugPrint("$_originalText != $_originalText");
      return null;
    }

    String stack = "";
    for (final cont in continuances) {
      if (stack == currentText) {
        return cont;
      }
      stack += cont.text;
    }

    return null;
  }

  String? get fullTranslation {
    if (continuances.isEmpty) return null;
    String full = "";
    for (final cont in continuances) {
      full += cont.text;
    }
    return full;
  }
}

class CurrentITStep {
  late List<Continuance> continuances;
  late bool isFinal;
  late String? translationId;
  late int payloadId;

  CurrentITStep({
    required String sourceText,
    required String currentText,
    required ITResponseModel responseModel,
    required List<Continuance>? storedGoldContinuances,
  }) {
    final List<Continuance> gold =
        storedGoldContinuances ?? responseModel.goldContinuances ?? [];
    final goldTracker = GoldRouteTracker(gold, sourceText);

    isFinal = responseModel.isFinal;
    translationId = responseModel.translationId;
    payloadId = responseModel.payloadId;

    if (responseModel.continuances.isEmpty) {
      continuances = [];
    } else {
      final Continuance? goldCont = goldTracker.currentContinuance(
        currentText: currentText,
        sourceText: sourceText,
      );
      if (goldCont != null) {
        continuances = [
          ...responseModel.continuances
              .where((c) => c.text.toLowerCase() != goldCont.text.toLowerCase())
              .map((e) {
            //we only want one green choice and for that to be our gold
            if (e.level == ChoreoConstants.levelThresholdForGreen) {
              e.level = ChoreoConstants.levelThresholdForYellow;
            }
            return e;
          }),
          goldCont,
        ];
        continuances.shuffle();
      } else {
        continuances = responseModel.continuances;
      }
    }
  }

  // get continuance with highest level
  Continuance get best =>
      continuances.reduce((a, b) => a.level < b.level ? a : b);
}
