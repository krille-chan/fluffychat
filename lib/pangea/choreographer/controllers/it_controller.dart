import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../../models/custom_input_translation_model.dart';
import '../../models/it_response_model.dart';
import '../../models/it_step.dart';
import '../../models/system_choice_translation_model.dart';
import '../../repo/interactive_translation_repo.dart';
import '../../repo/message_service.repo.dart';
import 'choreographer.dart';

class ITController {
  Choreographer choreographer;

  bool _isOpen = false;
  bool _isEditingSourceText = false;
  bool showChoiceFeedback = false;

  ITStartData? _itStartData;
  String? sourceText;
  List<ITStep> completedITSteps = [];
  CurrentITStep? currentITStep;
  GoldRouteTracker goldRouteTracker = GoldRouteTracker.defaultTracker;
  List<int> payLoadIds = [];

  ITController(this.choreographer);

  void clear() {
    _isOpen = false;
    showChoiceFeedback = false;
    _isEditingSourceText = false;

    _itStartData = null;
    sourceText = null;
    completedITSteps = [];
    currentITStep = null;
    goldRouteTracker = GoldRouteTracker.defaultTracker;
    payLoadIds = [];

    choreographer.altTranslator.clear();
    choreographer.errorService.resetError();
    choreographer.choreoMode = ChoreoMode.igc;
    choreographer.setState();
  }

  Future<void> initializeIT(ITStartData itStartData) async {
    Future.delayed(const Duration(microseconds: 100), () {
      _isOpen = true;
    });
    _itStartData = itStartData;
  }

  void closeIT() {
    //if they close it before choosing anything, just put their text back
    //PTODO - explore using last itStep
    if (choreographer.currentText.isEmpty) {
      choreographer.textController.text = sourceText ?? "";
    }
    clear();
  }

  /// if IGC isn't positive that text is full L1 then translate to L1
  Future<void> _setSourceText() async {
    // try {
    if (_itStartData == null || _itStartData!.text.isEmpty) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "choreo context", data: {
          "igcTextData": choreographer.igc.igcTextData?.toJson(),
          "currentText": choreographer.currentText
        }),
      );
      throw Exception("null _itStartData or empty text in _setSourceText");
    }
    debugPrint("_setSourceText with detectedLang ${_itStartData!.langCode}");
    if (_itStartData!.langCode == choreographer.l1LangCode) {
      sourceText = _itStartData!.text;
      return;
    }

    final FullTextTranslationResponseModel res =
        await FullTextTranslationRepo.translate(
      accessToken: await choreographer.accessToken,
      request: FullTextTranslationRequestModel(
        text: _itStartData!.text,
        tgtLang: choreographer.l1LangCode!,
        srcLang: choreographer.l2LangCode,
        userL1: choreographer.l1LangCode!,
        userL2: choreographer.l2LangCode!,
      ),
    );
    sourceText = res.bestTranslation;
    // } catch (err, stack) {
    //   debugger(when: kDebugMode);
    //   if (_itStartData?.text.isNotEmpty ?? false) {
    //     ErrorHandler.logError(e: err, s: stack);
    //     sourceText = _itStartData!.text;
    //   } else {
    //     rethrow;
    //   }
    // }
  }

  // used 1) at very beginning (with custom input = null)
  // and 2) if they make direct edits to the text field
  Future<void> getTranslationData(bool useCustomInput) async {
    try {
      choreographer.startLoading();

      final String currentText = choreographer.currentText;
      final String? translationId = currentITStep?.translationId;

      if (sourceText == null) await _setSourceText();

      if (useCustomInput && currentITStep != null) {
        completedITSteps.add(ITStep(
          currentITStep!.continuances,
          customInput: currentText,
        ));
      }

      currentITStep = null;

      final ITResponseModel res = await (useCustomInput ||
              currentText.isEmpty ||
              translationId == null ||
              completedITSteps.last.chosenContinuance?.indexSavedByServer ==
                  null
          ? _customInputTranslation(currentText)
          : _systemChoiceTranslation(translationId));

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

      if (isTranslationDone) {
        choreographer.altTranslator.setTranslationFeedback();
        choreographer.getLanguageHelp(true);
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      if (e is! http.Response) {
        ErrorHandler.logError(e: e, s: s);
      }
      choreographer.errorService.setErrorAndLock(
        ChoreoError(type: ChoreoErrorType.unknown, raw: e),
      );
    } finally {
      choreographer.stopLoading();
    }
  }

  Future<void> onEditSourceTextSubmit(String newSourceText) async {
    try {
      sourceText = newSourceText;
      _isEditingSourceText = false;
      final String currentText = choreographer.currentText;

      choreographer.startLoading();

      final List<ITResponseModel> responses = await Future.wait([
        _customInputTranslation(""),
        _customInputTranslation(choreographer.currentText),
      ]);
      if (responses[0].goldContinuances != null &&
          responses[0].goldContinuances!.isNotEmpty) {
        goldRouteTracker = GoldRouteTracker(
          responses[0].goldContinuances!,
          sourceText!,
        );
      }
      currentITStep = CurrentITStep(
        sourceText: sourceText!,
        currentText: currentText,
        responseModel: responses[1],
        storedGoldContinuances: goldRouteTracker.continuances,
      );

      _addPayloadId(responses[1]);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      if (err is! http.Response) {
        ErrorHandler.logError(e: err, s: stack);
      }
      choreographer.errorService.setErrorAndLock(
        ChoreoError(type: ChoreoErrorType.unknown, raw: err),
      );
    } finally {
      choreographer.stopLoading();
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
        classId: choreographer.classId,
      ),
    );
  }

  // used when user selects a choice
  Future<ITResponseModel> _systemChoiceTranslation(String translationId) =>
      ITRepo.systemChoiceTranslate(
        SystemChoiceRequestModel(
          userId: choreographer.userId!,
          nextWordIndex:
              completedITSteps.last.chosenContinuance?.indexSavedByServer,
          roomId: choreographer.roomId!,
          translationId: translationId,
          targetLangCode: targetLangCode,
          sourceLangCode: sourceLangCode,
          classId: choreographer.classId,
        ),
      );

  MessageServiceModel? messageServiceModelWithMessageId() =>
      usedInteractiveTranslation
          ? MessageServiceModel(
              classId: choreographer.classId,
              roomId: choreographer.roomId,
              message: choreographer.currentText,
              messageId: null,
              payloadIds: payLoadIds,
              userId: choreographer.userId!,
              l1Lang: sourceLangCode,
              l2Lang: targetLangCode,
            )
          : null;

  //maybe we store IT data in the same format? make a specific kind of match?
  void selectTranslation(int chosenIndex) {
    final itStep = ITStep(currentITStep!.continuances, chosen: chosenIndex);

    completedITSteps.add(itStep);

    showChoiceFeedback = true;
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

  String get targetLangCode => choreographer.l2LangCode!;

  String get sourceLangCode => choreographer.l1LangCode!;

  bool get isLoading => choreographer.isFetching;

  bool get correctChoicesSelected =>
      completedITSteps.every((ITStep step) => step.isCorrect);

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
          goldCont
        ];
        continuances.shuffle();
      } else {
        continuances = responseModel.continuances;
      }
    }
  }
}
